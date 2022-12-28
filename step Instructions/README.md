# Setting up a OKP4 validator NODE
### Step-by-step Instructions
Full vdo Tutorial setting up your validator node : https://youtu.be/8cYhk1ccA0k



![okp0](https://user-images.githubusercontent.com/83507970/209745737-24f855be-8c2e-4fa7-9383-ff483cb61f3b.jpg)
![okp1](https://user-images.githubusercontent.com/83507970/209745744-307efe92-3205-4599-9a13-7e658ee559f8.jpg)

---

![okp3](https://user-images.githubusercontent.com/83507970/209746137-ad7ad896-a152-45b3-a5af-dd0f5b05804b.jpg)

```
sudo apt update > /dev/null 2>&1 && apt install git sudo unzip wget -y > /dev/null 2>&1
sudo apt install curl tar wget vim clang pkg-config libssl-dev jq build-essential git make ncdu -y > /dev/null 2>&1
```

```
wget https://golang.org/dl/go1.18.2.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.18.2.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
```


---


![okp4](https://user-images.githubusercontent.com/83507970/209746036-bc4e815a-734f-4f4a-a0a6-dda335bbc90c.jpg)
```
cd $HOME 
rm -rf okp4d
git clone https://github.com/okp4/okp4d.git
cd okp4d
git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
make install
```

---

![okp5](https://user-images.githubusercontent.com/83507970/209746544-10a32530-64f9-421b-9558-075bc392ad9f.jpg)
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

```
---

![okp6](https://user-images.githubusercontent.com/83507970/209746798-a4549284-3727-4019-bf09-0e6a542aa95a.jpg)
```
mkdir -p $HOME/.okp4d/cosmovisor/genesis/bin
mkdir -p $HOME/.okp4d/cosmovisor/upgrades
cp $HOME/go/bin/okp4d $HOME/.okp4d/cosmovisor/genesis/bin
```

---

![okp7](https://user-images.githubusercontent.com/83507970/209746974-b9abf6ad-41de-4e39-b030-dbd2c194a2b1.jpg)
```
okp4d config keyring-backend test
okp4d config chain-id okp4-nemeton-1
```

---

![okp8](https://user-images.githubusercontent.com/83507970/209747091-27176196-ba40-4c71-89cd-9028ad15f040.jpg)
* Please adjusted paramitor of YOUR_MONIKER_NAME match to your NODE NAME.
```
NODE_MONIKER="YOUR_MONIKER_NAME"
```

```
okp4d init ${NODE_MONIKER} --chain-id okp4-nemeton-1
```
---


![okp9](https://user-images.githubusercontent.com/83507970/209747289-e1ed874a-c45a-4463-9f06-93e64e58f47d.jpg)
```
curl -o $HOME/.okp4d/config/genesis.json https://raw.githubusercontent.com/okp4/networks/main/chains/nemeton-1/genesis.json
```
---


![okp10](https://user-images.githubusercontent.com/83507970/209747349-17f2586b-89f0-4657-84ba-f6cab6e4948f.jpg)
```
curl -o $HOME/.okp4d/config/addrbook.json https://snapshots.polkachu.com/testnet-addrbook/okp4/addrbook.json 
```
---



![okp11](https://user-images.githubusercontent.com/83507970/209747481-357421f8-8617-4c71-9a08-bf2237d3c495.jpg)
```
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001uknow"|g' $HOME/.okp4d/config/app.toml
```
---


![okp12](https://user-images.githubusercontent.com/83507970/209747524-dcd5d567-8773-4fba-8e5d-681d8e0f83bd.jpg)
```
sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.okp4d/config/app.toml
sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.okp4d/config/app.toml
sed -i 's|^pruning-interval *=.*|pruning-interval = "17"|g' $HOME/.okp4d/config/app.toml

```
---


![okp13](https://user-images.githubusercontent.com/83507970/209747614-9ca3fd3e-f0df-4ae3-b56b-3cba55fa39a9.jpg)
```
PEERS=3ecbc8aa00b5dd8af88af7496489b0054e3b4d7f@138.68.182.247:26656,9c462b1c0ba63115bd70c3bd4f2935fcb93721d0@65.21.170.3:42656,2e85c1d08cfca6982c74ef2b67251aa459dd9b2f@65.109.85.170:43656,ee4c5d9a8ac7401f996ef9c4d79b8abda9505400@144.76.97.251:12656,affaad7c297b627020f63d5bc5b1c1a9d8842f44@152.32.192.192:26656,264256d32511c512a0a9d4098310a057c9999fd1@65.21.90.141:12234,e20b9048c220d4a8b7e7934fddb3c4fb20c20bdd@81.0.246.196:26656,0448864ede56d3c96d7d3bb8ea9f546b70cc722e@51.159.149.68:26656,fa04503a35476204861f06b75be4839562205527@65.109.85.226:6070,e3c602b146121c88d350bd7e0f6ce8977e1aacff@161.97.122.216:26656,da8e2423cb90fba519e685aa47669eb861ea18c4@65.108.249.79:36656,2182373d3ffba08d67a54b50a78102bd1ec4b037@95.216.14.72:33656,6bc178290d0773e244cf04598a3919d7a9391bf1@65.109.131.71:36656,61544968b65e34a59513b67613519cd37ace7ecb@161.97.151.109:26656,8cdeb85dada114c959c36bb59ce258c65ae3a09c@88.198.242.163:36656,ed52ad66f7c30b322c1e58d226791f1402883db3@23.88.72.246:36656,1e48c09a0f78070e90ed49b2e3d59f8fdc188e74@162.55.234.70:55156,e1635bec0e5a14dbbf1a41557714632627729ff9@95.217.144.44:36656,307fb25cd6998d0d5bd1d947571f6043c6bb4069@65.109.31.114:2280,5ed1edac2d35c91577b34f6002c85927027058b9@95.217.202.49:30656,1655cdc8fdfe1dc2209d47ff68c02a417ef9ed52@135.181.222.179:31656,4ea26ce893d8f4f89a7b49b9bd77e0fbd914e029@65.109.88.162:36656,d4305fcb7b20dc96481a6ae6ae84f281f3413a4e@65.109.37.58:13656,1f4fa23210cc1d086a928a3c6de7c24f6c8f17ba@202.61.226.120:16656,977373e6ff096d43c928e14724b8c6d9d7f48cb7@5.9.147.185:51656,84da5ad673d086c5c0b4a8da8b8b1c1c29e1d81e@142.132.130.196:36656,751d8d4bc73443aef9f95ddfac3572ddfc34e035@5.75.226.80:26656,08c925f04cb7a324b1aa91b472faa99c7cccc6ab@65.108.56.126:36656,a009a02a23428538b57591f73ba5a6462c476a70@136.243.88.91:6040,c3db3a07493e8f04d93a9228998ae799fa89877f@5.78.48.118:26656,126dc25a6a5aa0cfa83010550dfb3c5a1a861755@65.108.201.15:21337,5c2a752c9b1952dbed075c56c600c3a79b58c395@95.214.55.232:26996,2bfd405e8f0f176428e2127f98b5ec53164ae1f0@142.132.149.118:26656,61a8b9fdd5c21ebe6c02359cb192a4eda13d44cb@135.181.139.153:26656,dcc5b70f1df82def300db6f9dd859c1828514286@65.108.152.201:26656,b0b56d944cf1cc569a1e77e0923e075bad94d755@141.95.145.41:28656,82bb185819e5cf2bb6a9896447672efca27f28cb@65.109.15.202:26656,fff0a8c202befd9459ff93783a0e7756da305fe3@38.242.150.63:16656,8028015d1c6828a0b734f3b108f0853b0e19305e@157.90.176.184:26656,8a7605d8ae4338de5b7a0d5c70244ce05e377630@85.10.200.221:26656,506ae7340c1c1dfa893e916b5c9f40dda373cbc0@161.97.68.60:26656,f74f793a1efa51778fd74d4dbc5a1e88a8c644db@116.202.227.117:36656,d1a0ff9bd7ea1ebd06bc7158f3523f5e557328be@163.172.131.169:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:36656,8af258bbe73f4c66127a7b3e8b1ec23fde2950a6@65.108.192.123:19656,d1c1b729eff9afe7dfd371f190df6282c82ccfad@37.187.144.187:31656,a49302f8999e5a953ebae431c4dde93479e17155@141.95.153.244:26656,a98484ac9cb8235bd6a65cdf7648107e3d14dab4@116.202.231.58:36656,f3cccec7bdba9d5d4bd156087e3c6e2e5aa42948@65.108.134.215:29656,869bad4136d773f9ae83909257fd6c422b5cbe7a@142.132.151.169:26656,30092d2717053f1c0813e8354c07c761c9c3ac5c@194.163.161.234:26656,9f55b6fbf5d246138cc88acfe193ac45aa49c288@31.7.196.148:26656,07023da2f1fd638d40e37d13741e8e3d5525b4f1@65.108.96.104:26656,a4a96019d2fbc1b5df07940cd971585311166acd@65.108.206.118:61356,854cc8b83a48ba4394c1940b57d0f42ec013e033@38.242.251.204:26656,6916e6e4d7a313abc759286f995ac29f58792f19@85.114.134.219:10656,1ba6a539a9f8115ea0e0e161b0fc3f2c8a276e8b@51.68.204.169:26643,15fdc722cd49ef7676205b6ad3120a84728d948c@65.108.225.158:17656,99f6675049e22a0216af0e2447e7a4c5021874cd@142.132.132.200:28656,cb6ae22e1e89d029c55f2cb400b0caa19cbe5523@142.93.156.231:26603,540e0e9b33b2d87315fdf7089404671581d36e94@95.217.203.43:26656,370057fa4a5b3c835ea9eaf1a33d2d6e1e8820ee@65.108.234.126:24656

```
```
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.okp4d/config/config.toml
```
---


![okp14](https://user-images.githubusercontent.com/83507970/209747808-98ee545a-159c-4366-8ee5-578c697fba4e.jpg)
```
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.okp4d/config/config.toml
```
---


![okp15](https://user-images.githubusercontent.com/83507970/209747856-e3442b1d-4b5e-4e33-b8ed-8ed5d357532e.jpg)
```
SNAP_NAME=$(curl -s https://snapshots2-testnet.nodejumper.io/okp4-testnet/ | egrep -o ">okp4-nemeton-1.*\.tar.lz4" | tr -d ">")
```
```
curl https://snapshots2-testnet.nodejumper.io/okp4-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.okp4d
```
---

![okp16](https://user-images.githubusercontent.com/83507970/209747962-43d8ebba-82ad-47c6-9720-25f0b91f4869.jpg)
```
sudo tee /etc/systemd/system/okp4d.service > /dev/null << EOF
[Unit]
Description=okp4-testnet node service
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.okp4d"
Environment="DAEMON_NAME=okp4d"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable okp4d
```
---


![okp17](https://user-images.githubusercontent.com/83507970/209748027-67361ffe-1c84-4778-b60c-133727379a23.jpg)

```
sudo systemctl start okp4d
```
---


![okp18](https://user-images.githubusercontent.com/83507970/209748115-82a6602f-580c-4b72-b4f3-92f7db249d50.jpg)

```
sudo journalctl -u okp4d -f --no-hostname -o cat
```
---


![okp19](https://user-images.githubusercontent.com/83507970/209748158-721ea584-f575-4f4d-bc59-6a461cfee396.jpg)

* Please adjusted paramitor of OKP4WALLET match to your values before create wallet.

```
okp4d keys add OKP4WALLET
```
---



![okp20](https://user-images.githubusercontent.com/83507970/209748287-42a95497-2089-498c-931f-ddfedfef9d37.jpg)

* Please adjusted paramitor of wallet, moniker, identity, details and website match to your values before create validator.

```
okp4d tx staking create-validator \
--amount=1000000uknow \
--pubkey=$(okp4d tendermint show-validator) \
--moniker="YOUR_MONIKER_NAME" \
--identity="YOUR_KEYBASE_ID" \
--details="YOUR_DETAILS" \
--website="YOUR_WEBSITE_URL"\
--chain-id=okp4-nemeton-1 \
--commission-rate=0.05 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from="YOUR_WALLET" \
--keyring-backend=test \
--gas-prices=0.1uknow \
--gas-adjustment=1.5 \
--gas=auto \
-y
```
---



![okp21](https://user-images.githubusercontent.com/83507970/209748568-285571ef-45fa-4c07-be89-29f8627036a7.jpg)

* Basic commands for node operators

### Key management 🔑

Add New Key
```
okp4d keys add wallet
```

Recover Existing Key
```
okp4d keys add wallet --recover
```

List All Keys
```
okp4d keys list
```

Delete Key
```
okp4d keys delete wallet
```

Export Key (save to wallet.backup)
```
okp4d keys export wallet
```

Import Key
```
okp4d keys import wallet wallet.backup
```

Query Wallet Balance
```
okp4d q bank balances $(seid keys show wallet -a)
```


### Validator management 👷

Create New Validator
* Please adjusted paramitor of wallet, moniker, identity, details and website match to your values before create validator.

```
okp4d tx staking create-validator \
--amount=1000000uknow \
--pubkey=$(okp4d tendermint show-validator) \
--moniker="YOUR_MONIKER_NAME" \
--identity="YOUR_KEYBASE_ID" \
--details="YOUR_DETAILS" \
--website="YOUR_WEBSITE_URL"\
--chain-id=okp4-nemeton-1 \
--commission-rate=0.05 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from="YOUR_WALLET" \
--keyring-backend=test \
--gas-prices=0.1uknow \
--gas-adjustment=1.5 \
--gas=auto \
-y
```

Edit Existing Validator

```
okp4d tx staking edit-validator \
--moniker="YOUR_MONIKER_NAME" \
--identity="YOUR_KEYBASE_ID" \
--details="YOUR_DETAILS" \
--website="YOUR_WEBSITE_URL"
--chain-id=okp4-nemeton-1 \
--commission-rate=0.05 \
--from="YOUR_WALLET" \
--keyring-backend=test \
--gas-prices=0.1uknow \
--gas-adjustment=1.5 \
--gas=auto \
-y
```

Unjail Validator
```
okp4d tx slashing unjail --from wallet --chain-id okp4-nemeton-1 --gas-prices 0.1uknow --gas-adjustment 1.5 --gas auto -y
```

Signing Info
```
okp4d query slashing signing-info $(okp4d tendermint show-validator)
```

List All Active Validators
```
okp4d q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

List All Inactive Validators
```
okp4d q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

View Validator Details
```
okp4d q staking validator $(okp4d keys show wallet --bech val -a)
```

### Token management 💲 
Withdraw Rewards From All Validators
```
okp4d tx distribution withdraw-all-rewards --from wallet --chain-id okp4-nemeton-1 --gas-prices 0.1uknow --gas-adjustment 1.5 --gas auto -y
```

Withdraw Commission And Rewards From Your Validator
```
okp4d tx distribution withdraw-rewards $(okp4d keys show wallet --bech val -a) --commission --from wallet --chain-id okp4-nemeton-1 --gas-prices 0.1uknow --gas-adjustment 1.5 --gas auto -y
```

Delegate to yourself
```
okp4d tx staking delegate $(okp4d keys show wallet --bech val -a) 1000000uknow --from wallet --chain-id okp4-nemeton-1 --gas-prices 0.1uknow --gas-adjustment 1.5 --gas auto -y
```

Delegate to another validator
```
okp4d tx staking delegate Valoper_address 1000000uknow --from wallet --chain-id okp4-nemeton-1 --gas-prices 0.1uknow --gas-adjustment 1.5 --gas auto -y
```

Redelegate
```
okp4d tx staking redelegate $(okp4d keys show wallet --bech val -a) Valoper_address 1000000uknow --from wallet --chain-id okp4-nemeton-1 --gas-prices 0.1uknow --gas-adjustment 1.5 --gas auto -y
```

Unbond
```
okp4d tx staking unbond $(okp4d keys show wallet --bech val -a) 1000000uknow --from wallet --chain-id okp4-nemeton-1 --gas-prices 0.1uknow --gas-adjustment 1.5 --gas auto -y
```

Send Token
```
okp4d tx bank send wallet Destination_address 1000000uknow --from wallet --chain-id okp4-nemeton-1 --gas-prices 0.1uknow --gas-adj
```


### Utility ⚡️ 
Get Validator Info
```
okp4d status 2>&1 | jq .ValidatorInfo
```
Get Catching Up
```
okp4d status 2>&1 | jq .SyncInfo.catching_up
```
Get Latest Height
```
okp4d status 2>&1 | jq .SyncInfo.latest_block_height
```
Get Peer
```
echo $(okp4d tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.okp4d/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
Reset Node
```
okp4d tendermint unsafe-reset-all --home $HOME/.okp4d --keep-addr-book
```
Remove Node
```
sudo systemctl stop okp4d && sudo systemctl disable okp4d && sudo rm /etc/systemd/system/okp4d.service && sudo systemctl daemon-reload && rm -rf $HOME/.okp4d && rm -rf $HOME/okp4d && sudo rm $(which okp4d)
```
Get IP Address
```
wget -qO- eth0.me
```


### Service Management ⚙️
Reload Services
```
sudo systemctl daemon-reload
```
Enable Service
```
sudo systemctl enable okp4d
```
Disable Service
```
sudo systemctl disable okp4d
```
Run Service
```
sudo systemctl start okp4d
```
Stop Service
```
sudo systemctl stop okp4d
```
Restart Service
```
sudo systemctl restart okp4d
```
Check Service Status
```
sudo systemctl status okp4d
```
Check Service Logs
```
sudo journalctl -u okp4d -f --no-hostname -o cat
```
