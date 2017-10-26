#!/usr/bin/env bash
USER=ubuntu

timedatectl set-timezone America/Sao_Paulo

apt-get update
apt-get install -y ntp
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
apt-get update
apt-get install -y docker-engine git

usermod -aG docker $USER

curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/1.15.0/docker-compose-$(uname -s)-$(uname -m)"
chmod +x /usr/local/bin/docker-compose

su $USER << EOF
  mkdir ~/ssl
  cd ~/ssl
  git clone https://github.com/gabrielfgularte/docker-nginx-proxy-letsencrypt.git .
  docker network create webproxy
EOF

echo "Para ativar o SSL, faça o deploy e depois rode docker-compose up -d na pasta ssl"
echo "Criar .bash_profile na raiz do usuário $USER com os exports das envvars"
