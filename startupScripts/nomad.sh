wget -P /tmp/ https://releases.hashicorp.com/nomad/0.5.6/nomad_0.5.6_linux_amd64.zip -O nomad.zip
sudo unzip nomad.zip
sudo chown +x nomad
sudo cp nomad /usr/local/bin/
