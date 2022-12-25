
#!/bin/bash
echo -e "\033[0;33m"
echo "==========================================================================================================================="
echo " "
echo "██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗ █████╗ ███╗   ██╗ █████╗ ";
echo "██║  ██║██╔══██╗╚██╗██╔╝╚██╗██╔╝██╔══██╗████╗  ██║██╔══██╗";
echo "███████║███████║ ╚███╔╝  ╚███╔╝ ███████║██╔██╗ ██║███████║";
echo "██╔══██║██╔══██║ ██╔██╗  ██╔██╗ ██╔══██║██║╚██╗██║██╔══██║";
echo "██║  ██║██║  ██║██╔╝ ██╗██╔╝ ██╗██║  ██║██║ ╚████║██║  ██║";
echo "╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝";
echo -e "\033[0;33m"
echo "==========================================================================================================================="                                                                                    
sleep 1



function InstallingRequiredtool {
echo -e "\e[1m\e[32mInstalling required tool ... \e[0m" && sleep 1
sudo apt install curl -y > /dev/null 2>&1
sudo apt update > /dev/null 2>&1 && apt install git sudo unzip wget -y > /dev/null 2>&1
sudo apt install curl tar wget vim clang pkg-config libssl-dev jq build-essential git make ncdu -y > /dev/null 2>&1
}


function InstallingGo {
echo " "
echo -e "\e[1m\e[32mInstalling Go ... \e[0m" && sleep 1
if ! command -v go > /dev/null; then
  wget https://golang.org/dl/go1.18.2.linux-amd64.tar.gz
  tar -C /usr/local -xzf go1.18.2.linux-amd64.tar.gz
  export PATH=$PATH:/usr/local/go/bin
  echo "Go installed successfully"
else
  echo "Go is already installed"
fi
rm "go1.18.2.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
}


function InstallingOKP4-App {
echo " "
echo -e "\e[1m\e[32mInstalling okp4 App ... \e[0m" && sleep 1
cd $HOME 
rm -rf okp4d
git clone https://github.com/okp4/okp4d.git
cd okp4d
git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
make install
}


function Createwallet {
echo " "
echo -e "\e[1m\e[32mCreate OKP4 Wallet ... \e[0m" && sleep 1
source ~/.bash_profile


if [ ! $OKP4NODENAME ]; then
while true; do
  read -p "Insert node name: " OKP4NODENAME
  if [[ $OKP4NODENAME =~ ^[a-zA-Z0-9]+$ ]]; then
    break
  else
    echo "Error: Please enter only text and numbers."
  fi
done
echo 'export OKP4NODENAME='$OKP4NODENAME >> $HOME/.bash_profile
fi

if [ ! $OKP4WALLET ]; then
while true; do
  read -p "Insert wallet name: " OKP4WALLET
  if [[ $OKP4WALLET =~ ^[a-zA-Z0-9]+$ ]]; then
    break
  else
    echo "Error: Please enter only text and numbers."
  fi
done
echo 'export OKP4WALLET='${OKP4WALLET} >> $HOME/.bash_profile

fi

}



function SetchainID {
echo " "
echo -e "\e[1m\e[32mSet chain id mocha and keyring-backend test... \e[0m" && sleep 1
source $HOME/.bash_profile
okp4d config keyring-backend test
okp4d config chain-id okp4-nemeton-1
okp4d init ${OKP4NODENAME} --chain-id okp4-nemeton-1 && sleep 2
}


function SetupGenesis  {
echo " "
echo -e "\e[1m\e[32mDownload Genesis.json... \e[0m" && sleep 1
curl https://raw.githubusercontent.com/okp4/networks/main/chains/nemeton-1/genesis.json > $HOME/.okp4d/config/genesis.json
}



function Setseedsandpeers  {
echo " "
echo -e "\e[1m\e[32mSet seeds and peers... \e[0m" && sleep 1
SEEDS=""
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.okp4d/config/config.toml
}


function Addnewpeer  {
echo " "
echo -e "\e[1m\e[32mAdd new peers... \e[0m" && sleep 1
sudo systemctl stop okp4d
SEEDS=""
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.okp4d/config/config.toml
sudo systemctl start okp4d 
}



function Setpruning {
echo " "
echo -e "\e[1m\e[32mSet Pruning... \e[0m" && sleep 1
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.okp4d/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.okp4d/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "17"|g' $HOME/.okp4d/config/app.toml
}


function Recoverwallet {
echo " "
if [ ! $OKP4NODENAME ]; then
while true; do
  read -p "Insert node name: " OKP4NODENAME
  if [[ $OKP4NODENAME =~ ^[a-zA-Z0-9]+$ ]]; then
    break
  else
    echo "Error: Please enter only text and numbers."
  fi
done
echo 'export OKP4NODENAME='$OKP4NODENAME >> $HOME/.bash_profile
fi
echo " "

if [ ! $OKP4WALLET ]; then
while true; do
  read -p "Insert wallet name: " OKP4WALLET
  if [[ $OKP4WALLET =~ ^[a-zA-Z0-9]+$ ]]; then
    break
  else
    echo "Error: Please enter only text and numbers."
  fi
done
echo 'export OKP4WALLET='${OKP4WALLET} >> $HOME/.bash_profile
fi
echo " "

source $HOME/.bash_profile
okp4d config chain-id mocha
okp4d config keyring-backend test
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/.okp4d/config/config.toml

echo -e "\e[1m\e[31mPlease write you mnemonic phrase. \e[0m" && sleep 1
echo " "
source $HOME/.bash_profile && okp4d keys add $OKP4OKP4WALLET --recover
echo " "

echo -e "\e[1m\e[33mYour okp4 Wallet address : $(okp4d keys show ${OKP4WALLET} -a)\e[0m" && sleep 1
echo -e "\e[1m\e[34mYour okp4 Validator address : $(okp4d keys show ${OKP4WALLET} --bech val -a)\e[0m" && sleep 1    
  
echo 'export OKP4WALLET_ADDRESS='$(okp4d keys show ${OKP4WALLET} -a) >> $HOME/.bash_profile
echo 'export OKP4VALOPER_ADDRESS='$(okp4d keys show ${OKP4WALLET} --bech val -a) >> $HOME/.bash_profile

}


function Setsystemd {
echo " "
echo -e "\e[1m\e[32mCreate okp4d.service ... \e[0m" && sleep 1
sudo tee /etc/systemd/system/okp4d.service > /dev/null << EOF
[Unit]
Description=okp4 Validator Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which okp4d) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable okp4d
}



function Syncsnap {
echo " "
sudo systemctl stop okp4d && sleep 5

echo -e "\e[1m\e[32mDownload data from Lasted snap ... \e[0m" && sleep 1
okp4d tendermint unsafe-reset-all --home $HOME/.okp4-app --keep-addr-book && sleep 5
cd $HOME
rm -rf ~/.okp4-app/data
mkdir -p ~/.okp4-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/okp4/ | \
    egrep -o ">mocha.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/okp4/${SNAP_NAME} | tar xf - \
    -C ~/.okp4-app/data/
sudo systemctl restart okp4d
}


function Restart {
echo " "
echo -e "\e[1m\e[32mRestart you node ... \e[0m" && sleep 1
sudo systemctl restart okp4d
}


function Checksync {
echo " "
echo -e "\e[1m\e[32mCheck you node sync... \e[0m" && sleep 1
source $HOME/.bash_profile 
echo -e "\e[1m\e[32mYou node Latest Block is $(okp4d status 2>&1 | jq .SyncInfo.latest_block_height) \e[0m" 
echo -e "\e[1m\e[32mYou node sync is $(okp4d status 2>&1 | jq .SyncInfo.catching_up) \e[0m" 
}

function Addwallet {
echo " "
echo -e "\e[1m\e[32mCreate you wallet... \e[0m" && sleep 1
echo -e "\e[1m\e[31m **Important** Please write this mnemonic phrase in a safe place. \e[0m" && sleep 1
echo " "
echo " "
echo -e "\e[1m\e[32mCreate WALLET ADDRESS... \e[0m" && sleep 1
source $HOME/.bash_profile && okp4d keys add $OKP4WALLET
echo " "
echo -e "\e[1m\e[33mYour okp4 Wallet address : $(okp4d keys show ${OKP4WALLET} -a)\e[0m" && sleep 1
echo -e "\e[1m\e[34mYour okp4 Validator address : $(okp4d keys show ${OKP4WALLET} --bech val -a)\e[0m" && sleep 1      
echo 'export OKP4WALLET_ADDRESS='$(okp4d keys show ${OKP4WALLET} -a) >> $HOME/.bash_profile
echo 'export OKP4VALOPER_ADDRESS='$(okp4d keys show ${OKP4WALLET} --bech val -a) >> $HOME/.bash_profile

}

function Checkbalances {
echo " "
echo -e "\e[1m\e[32mCheck you balance... \e[0m" && sleep 1
source $HOME/.bash_profile
echo -e "\e[1m\e[32mYou Balance is $(okp4d query bank balances $OKP4WALLET_ADDRESS) \e[0m" 

}


function CreateValidator {
echo " "
echo -e "\e[1m\e[32mCreate Validator ... \e[0m" && sleep 1 
source $HOME/.bash_profile && sleep 1 
okp4d tx staking create-validator \
--amount=9000000utia \
--pubkey=$(okp4d tendermint show-validator) \
--moniker=$OKP4NODENAME \
--chain-id=okp4-nemeton-1 \
--commission-rate=0.1 \
--commission-max-rate=0.2 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1000000 \
--from=$OKP4WALLET_ADDRESS \
--keyring-backend=test \
--gas-prices=0.1uknow \
--gas-adjustment=1.5 \
--gas=auto \
-y

sleep 10

}


function Delegate {
echo " "
echo -e "\e[1m\e[32mDelegate Token to you validator ... \e[0m" && sleep 1
YBalance=$(source $HOME/.bash_profile && okp4d query bank balances $OKP4WALLET_ADDRESS  |grep amount |awk -F"\"" '{print $2}')
echo "You utia Balance $YBalance"
echo -e "\e[1m\e[34mYou utia Balance : ${YBalance}\e[0m" && sleep 1
echo " "
echo " "
#read -p "Insert utia need Delegate : " ToDelegate && sleep 2
CanDelegate=$((YBalance - 2000000))
source $HOME/.bash_profile && okp4d tx staking delegate $OKP4VALOPER_ADDRESS ${CanDelegate}utia --from=$OKP4WALLET_ADDRESS --chain-id=mocha --fees 5000utia --gas 1000000 --gas-adjustment 1.3 -y
}


function Delete {
echo " "
echo -e "\e[1m\e[32mDelete you node ... \e[0m" && sleep 1
sudo systemctl stop okp4d && sudo systemctl disable okp4d && sudo rm /etc/systemd/system/okp4d.service && sudo systemctl daemon-reload && rm -rf $HOME/.okp4-app && rm -rf $HOME/okp4-app  && rm $(which okp4d) 
sudo sed -i '/OKP4WALLET/d' $HOME/.bash_profile
sudo sed -i '/OKP4WALLET_ADDRESS/d' $HOME/.bash_profile
sudo sed -i '/OKP4VALOPER_ADDRESS/d' $HOME/.bash_profile
sudo sed -i '/OKP4NODENAME/d' $HOME/.bash_profile
}






PS3='Please enter your choice (input your option number and press enter): '
options=("Install" "Install with Snapshot" "Install with old wallet and Snapshot" "Check Sync" "Snapshort" "Check Balance" "Create Validator" "Restart" "Delegate" "Uninstall" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Install")
            echo -e '\e[1m\e[32mYou choose Install without Snapshort ...\e[0m' && sleep 1
InstallingRequiredtool
InstallingGo
Installingokp4-app
Createwallet
SetchainID
Setupgenesis
Setseedsandpeers
Setpruning
Setsystemd
Restart
Addwallet
echo -e "\e[1m\e[32mYour Node was Install!\e[0m" && sleep 1
break
;;

"Install with Snapshot")
            echo -e '\e[1m\e[32mYou choose Install with Snapshort ...\e[0m' && sleep 1
InstallingRequiredtool
InstallingGo
Installingokp4-app
Createwallet
SetchainID
Setupgenesis
Setseedsandpeers
Setpruning
Setsystemd
Syncsnap
Restart
Addwallet
echo -e "\e[1m\e[32mYour Node was Install!\e[0m" && sleep 1

;;

"Install with old wallet and Snapshot")
            echo -e '\e[1m\e[32mYou choose Install with Snapshort ...\e[0m' && sleep 1
InstallingRequiredtool
InstallingGo
Installingokp4-app
Recoverwallet
#Createwallet
SetchainID
Setupgenesis
Setseedsandpeers
Setpruning
Setsystemd
Syncsnap
Restart
echo -e "\e[1m\e[32mYour Node was Install!\e[0m" && sleep 1

;;

"Check Sync")
            echo -e '\e[1m\e[32mYou choose Check Sync ...\e[0m' && sleep 1
Checksync

;;

"Check Balance")
            echo -e '\e[1m\e[32mYou choose Check Balance ...\e[0m' && sleep 1
Checkbalances

;;

"Snapshort")
            echo -e '\e[1m\e[32mYou choose Download Snapshot ...\e[0m' && sleep 1
Syncsnap
echo -e "\e[1m\e[32mDownload Snapshot complete!\e[0m" && sleep 1


;;


"Create Validator")
echo -e '\e[1m\e[32mYou choose Create Validator ...\e[0m' && sleep 1
CreateValidator
echo -e "\e[1m\e[34mYour okp4 Validator address : $(okp4d keys show ${OKP4WALLET} --bech val -a)\e[0m" && sleep 1

;;

"Restart")
echo -e '\e[1m\e[32mYou choose Restart You Node ...\e[0m' && sleep 1
Restart
echo -e "\e[1m\e[32mRestart You Node complete!\e[0m" && sleep 1


;;

"Delegate")
echo -e '\e[1m\e[32mYou choose Delegate ...\e[0m' && sleep 1
Delegate
echo -e "\e[1m\e[32mDelegate Complete!\e[0m" && sleep 1

;;

"Uninstall")
echo -e '\e[1m\e[32mYou choose Uninstall ...\e[0m' && sleep 1
Delete
echo -e "\e[1m\e[32mYour Node was Uninstall complete!\e[0m" && sleep 1
break
;;



"Quit")
break
;;

*) echo -e "\e[91minvalid option $REPLY\e[0m";;
    esac
done
