#!/bin/bash
echo -e "\033[0;33m"
echo "============================================================"
echo " "
echo "██╗  ██╗ █████╗ ██╗  ██╗██╗  ██╗ █████╗ ███╗   ██╗ █████╗ ";
echo "██║  ██║██╔══██╗╚██╗██╔╝╚██╗██╔╝██╔══██╗████╗  ██║██╔══██╗";
echo "███████║███████║ ╚███╔╝  ╚███╔╝ ███████║██╔██╗ ██║███████║";
echo "██╔══██║██╔══██║ ██╔██╗  ██╔██╗ ██╔══██║██║╚██╗██║██╔══██║";
echo "██║  ██║██║  ██║██╔╝ ██╗██╔╝ ██╗██║  ██║██║ ╚████║██║  ██║";
echo "╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝";
echo -e "\033[0;33m"
echo "============================================================"                                                                                    
sleep 1



function InstallingRequiredtool {
echo -e "\e[1m\e[32mInstalling required tool ... \e[0m" && sleep 1
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

echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
}


function InstallingOKP4 {
echo " "
echo -e "\e[1m\e[32mInstalling okp4 App ... \e[0m" && sleep 1
cd $HOME 
rm -rf okp4d
git clone https://github.com/okp4/okp4d.git
cd okp4d
git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
make install
}



function installCosmovisor {
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
mkdir -p ~/.okp4d/cosmovisor/genesis/bin
mkdir -p ~/.okp4d/cosmovisor/upgrades
cp $HOME/go/bin/okp4d $HOME/.okp4d/cosmovisor/genesis/bin
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
echo -e "\e[1m\e[32mSet chain id okp4-nemeton-1 and keyring-backend test... \e[0m" && sleep 1
source $HOME/.bash_profile
okp4d config keyring-backend test
okp4d config chain-id okp4-nemeton-1
okp4d init ${OKP4NODENAME} --chain-id okp4-nemeton-1 && sleep 1
}


function SetupGenesis  {
echo " "
echo -e "\e[1m\e[32mDownload Genesis.json... \e[0m" && sleep 1
curl -o $HOME/.okp4d/config/genesis.json https://raw.githubusercontent.com/okp4/networks/main/chains/nemeton-1/genesis.json
curl -o $HOME/.okp4d/config/addrbook.json https://snapshots.polkachu.com/testnet-addrbook/okp4/addrbook.json 
}


function CustomPort  {
echo " "
sudo sed -i '/OKP4_PORT/d' $HOME/.bash_profile
echo -e "\e[1m\e[32mCustom You Port... \e[0m" && sleep 1
while true; do
  read -p "Insert Port 10-99: " OKP4_PORT
  if [[ $OKP4_PORT =~ ^[1-9][0-9]$ ]]; then
    # Port number is valid
    break
  else
    # Port number is invalid
    echo "Error: Please enter a number between 10 and 99."
  fi
done

echo "Port: $OKP4_PORT"
echo 'export OKP4_PORT='${OKP4_PORT} >> $HOME/.bash_profile
source $HOME/.bash_profile
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${OKP4_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${OKP4_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${OKP4_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${OKP4_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${OKP4_PORT}660\"%" $HOME/.okp4d/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${OKP4_PORT}17\"%; s%^address = \":8080\"%address = \":${OKP4_PORT}80\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${OKP4_PORT}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${OKP4_PORT}91\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${OKP4_PORT}45\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${OKP4_PORT}46\"%" $HOME/.okp4d/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${OKP4_PORT}657\"%" $HOME/.okp4d/config/client.toml 
}



function Setseedsandpeers  {
echo " "
echo -e "\e[1m\e[32mSet seeds and peers... \e[0m" && sleep 1
SEEDS=""
PEERS=3ecbc8aa00b5dd8af88af7496489b0054e3b4d7f@138.68.182.247:26656,9c462b1c0ba63115bd70c3bd4f2935fcb93721d0@65.21.170.3:42656,2e85c1d08cfca6982c74ef2b67251aa459dd9b2f@65.109.85.170:43656,ee4c5d9a8ac7401f996ef9c4d79b8abda9505400@144.76.97.251:12656,affaad7c297b627020f63d5bc5b1c1a9d8842f44@152.32.192.192:26656,264256d32511c512a0a9d4098310a057c9999fd1@65.21.90.141:12234,e20b9048c220d4a8b7e7934fddb3c4fb20c20bdd@81.0.246.196:26656,0448864ede56d3c96d7d3bb8ea9f546b70cc722e@51.159.149.68:26656,fa04503a35476204861f06b75be4839562205527@65.109.85.226:6070,e3c602b146121c88d350bd7e0f6ce8977e1aacff@161.97.122.216:26656,da8e2423cb90fba519e685aa47669eb861ea18c4@65.108.249.79:36656,2182373d3ffba08d67a54b50a78102bd1ec4b037@95.216.14.72:33656,6bc178290d0773e244cf04598a3919d7a9391bf1@65.109.131.71:36656,61544968b65e34a59513b67613519cd37ace7ecb@161.97.151.109:26656,8cdeb85dada114c959c36bb59ce258c65ae3a09c@88.198.242.163:36656,ed52ad66f7c30b322c1e58d226791f1402883db3@23.88.72.246:36656,1e48c09a0f78070e90ed49b2e3d59f8fdc188e74@162.55.234.70:55156,e1635bec0e5a14dbbf1a41557714632627729ff9@95.217.144.44:36656,307fb25cd6998d0d5bd1d947571f6043c6bb4069@65.109.31.114:2280,5ed1edac2d35c91577b34f6002c85927027058b9@95.217.202.49:30656,1655cdc8fdfe1dc2209d47ff68c02a417ef9ed52@135.181.222.179:31656,4ea26ce893d8f4f89a7b49b9bd77e0fbd914e029@65.109.88.162:36656,d4305fcb7b20dc96481a6ae6ae84f281f3413a4e@65.109.37.58:13656,1f4fa23210cc1d086a928a3c6de7c24f6c8f17ba@202.61.226.120:16656,977373e6ff096d43c928e14724b8c6d9d7f48cb7@5.9.147.185:51656,84da5ad673d086c5c0b4a8da8b8b1c1c29e1d81e@142.132.130.196:36656,751d8d4bc73443aef9f95ddfac3572ddfc34e035@5.75.226.80:26656,08c925f04cb7a324b1aa91b472faa99c7cccc6ab@65.108.56.126:36656,a009a02a23428538b57591f73ba5a6462c476a70@136.243.88.91:6040,c3db3a07493e8f04d93a9228998ae799fa89877f@5.78.48.118:26656,126dc25a6a5aa0cfa83010550dfb3c5a1a861755@65.108.201.15:21337,5c2a752c9b1952dbed075c56c600c3a79b58c395@95.214.55.232:26996,2bfd405e8f0f176428e2127f98b5ec53164ae1f0@142.132.149.118:26656,61a8b9fdd5c21ebe6c02359cb192a4eda13d44cb@135.181.139.153:26656,dcc5b70f1df82def300db6f9dd859c1828514286@65.108.152.201:26656,b0b56d944cf1cc569a1e77e0923e075bad94d755@141.95.145.41:28656,82bb185819e5cf2bb6a9896447672efca27f28cb@65.109.15.202:26656,fff0a8c202befd9459ff93783a0e7756da305fe3@38.242.150.63:16656,8028015d1c6828a0b734f3b108f0853b0e19305e@157.90.176.184:26656,8a7605d8ae4338de5b7a0d5c70244ce05e377630@85.10.200.221:26656,506ae7340c1c1dfa893e916b5c9f40dda373cbc0@161.97.68.60:26656,f74f793a1efa51778fd74d4dbc5a1e88a8c644db@116.202.227.117:36656,d1a0ff9bd7ea1ebd06bc7158f3523f5e557328be@163.172.131.169:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:36656,8af258bbe73f4c66127a7b3e8b1ec23fde2950a6@65.108.192.123:19656,d1c1b729eff9afe7dfd371f190df6282c82ccfad@37.187.144.187:31656,a49302f8999e5a953ebae431c4dde93479e17155@141.95.153.244:26656,a98484ac9cb8235bd6a65cdf7648107e3d14dab4@116.202.231.58:36656,f3cccec7bdba9d5d4bd156087e3c6e2e5aa42948@65.108.134.215:29656,869bad4136d773f9ae83909257fd6c422b5cbe7a@142.132.151.169:26656,30092d2717053f1c0813e8354c07c761c9c3ac5c@194.163.161.234:26656,9f55b6fbf5d246138cc88acfe193ac45aa49c288@31.7.196.148:26656,07023da2f1fd638d40e37d13741e8e3d5525b4f1@65.108.96.104:26656,a4a96019d2fbc1b5df07940cd971585311166acd@65.108.206.118:61356,854cc8b83a48ba4394c1940b57d0f42ec013e033@38.242.251.204:26656,6916e6e4d7a313abc759286f995ac29f58792f19@85.114.134.219:10656,1ba6a539a9f8115ea0e0e161b0fc3f2c8a276e8b@51.68.204.169:26643,15fdc722cd49ef7676205b6ad3120a84728d948c@65.108.225.158:17656,99f6675049e22a0216af0e2447e7a4c5021874cd@142.132.132.200:28656,cb6ae22e1e89d029c55f2cb400b0caa19cbe5523@142.93.156.231:26603,540e0e9b33b2d87315fdf7089404671581d36e94@95.217.203.43:26656,370057fa4a5b3c835ea9eaf1a33d2d6e1e8820ee@65.108.234.126:24656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.okp4d/config/config.toml
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
sed -i.bak -e 's|^pruning *=.*|pruning = "custom"|; s|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|; s|^pruning-keep-every *=.*|pruning-keep-every = "0"|; s|^pruning-interval *=.*|pruning-interval = "17"|' $HOME/.okp4d/config/app.toml
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


okp4d config keyring-backend test
okp4d config chain-id okp4-nemeton-1
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/.okp4d/config/config.toml
source $HOME/.bash_profile
echo -e "\e[1m\e[31mPlease write you mnemonic phrase. \e[0m" && sleep 1
echo " "
okp4d keys add $OKP4WALLET --recover
echo " "
 
  
echo 'export OKP4WALLET_ADDRESS='$(okp4d keys show ${OKP4WALLET} -a) >> $HOME/.bash_profile
echo 'export OKP4VALOPER_ADDRESS='$(okp4d keys show ${OKP4WALLET} --bech val -a) >> $HOME/.bash_profile
}


function Setsystemd {
echo " "
echo -e "\e[1m\e[32mCreate okp4d.service ... \e[0m" && sleep 1
sudo tee /etc/systemd/system/okp4d.service > /dev/null << EOF
[Unit]
Description="okp4d node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=okp4d"
Environment="DAEMON_HOME=/home/USER/.okp4d"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

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
sudo systemctl stop okp4d

cp $HOME/.okp4d/data/priv_validator_state.json $HOME/.okp4d/priv_validator_state.json.backup
okp4d tendermint unsafe-reset-all --home $HOME/.okp4d --keep-addr-book

SNAP_NAME=$(curl -s https://snapshots2-testnet.nodejumper.io/okp4-testnet/ | egrep -o ">okp4-nemeton-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots2-testnet.nodejumper.io/okp4-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.okp4d

mv $HOME/.okp4d/priv_validator_state.json.backup $HOME/.okp4d/data/priv_validator_state.json

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
echo -e "\e[1m\e[32mYou node Latest Block is $(curl -s localhost:${OKP4_PORT}657/status | jq .result.sync_info.latest_block_height) \e[0m" 
echo -e "\e[1m\e[32mYou node sync is $(curl -s localhost:${OKP4_PORT}657/status | jq .result.sync_info.catching_up) \e[0m" 
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
CanDelegate=$((YBalance - 2000000))
source $HOME/.bash_profile && okp4d tx staking delegate $OKP4VALOPER_ADDRESS ${CanDelegate}utia --from=$OKP4WALLET_ADDRESS --chain-id=mocha --fees 5000utia --gas 1000000 --gas-adjustment 1.3 -y
}


function Delete {
echo " "
echo -e "\e[1m\e[32mDelete you node ... \e[0m" && sleep 1
sudo systemctl stop okp4d && sudo systemctl disable okp4d && sudo rm /etc/systemd/system/okp4d.service && sudo systemctl daemon-reload 
sudo rm -rf $HOME/.okp4d 
sudo rm -rf $HOME/okp4d  
sudo rm $(which okp4d)
sudo rm $HOME/go/bin/okp4d
sudo sed -i '/OKP4WALLET/d' $HOME/.bash_profile
sudo sed -i '/OKP4WALLET_ADDRESS/d' $HOME/.bash_profile
sudo sed -i '/OKP4VALOPER_ADDRESS/d' $HOME/.bash_profile
sudo sed -i '/OKP4NODENAME/d' $HOME/.bash_profile
sudo sed -i '/OKP4_PORT/d' $HOME/.bash_profile
}






PS3='Please enter your choice (input your option number and press enter): '
options=("Install" "Install with Snapshot" "Install with old wallet and Snapshot" "Snapshort" "Custom Port" "Check Sync" "Check Balance" "Create Validator" "Restart" "Delegate" "Uninstall" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Install")
            echo -e '\e[1m\e[32mYou choose Install without Snapshort ...\e[0m' && sleep 1
InstallingRequiredtool
InstallingGo
InstallingOKP4
installCosmovisor
Createwallet
SetchainID
SetupGenesis
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
InstallingOKP4
installCosmovisor
Createwallet
SetchainID
SetupGenesis
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
InstallingOKP4
installCosmovisor
Recoverwallet
SetupGenesis
Setseedsandpeers
Setpruning
Setsystemd
Syncsnap
Restart
source $HOME/.bash_profile
echo -e "\e[1m\e[33mYour okp4 Wallet address : $(okp4d keys show ${OKP4WALLET} -a)\e[0m" && sleep 1
echo -e "\e[1m\e[34mYour okp4 Validator address : $(okp4d keys show ${OKP4WALLET} --bech val -a)\e[0m" && sleep 1   
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

"Custom Port")
            echo -e '\e[1m\e[32mYou choose Custom Port ...\e[0m' && sleep 1
CustomPort

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
