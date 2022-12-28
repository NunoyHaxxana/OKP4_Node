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
```
NODE_MONIKER="YOUR_NODE_MONIKER"
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
