sudo apt-get -y install unzip
sudo wget -P /tmp/ https://releases.hashicorp.com/consul/0.8.3/consul_0.8.3_linux_amd64.zip -O consul.zip
sudo unzip consul.zip
sudo chmod +x consul
sudo cp consul /usr/local/bin/
