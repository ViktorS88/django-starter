#!/usr/bin/env bash
USER=ubuntu
SERVER_URI=example.com

git archive -o /tmp/application.tar.gz HEAD:application
scp /tmp/application.tar.gz $USER@$PROJECT_URI:/tmp/

scp Dockerfile $USER@$PROJECT_URI:/tmp/
scp docker-compose.yml $USER@$PROJECT_URI:/tmp/
scp docker-compose.dev.yml $USER@$PROJECT_URI:/tmp/docker-compose.override.yml
scp nginx.conf $USER@$PROJECT_URI:/tmp/nginx.conf

DATE_NOW=$(date +"%Y%m%d_%H%M%S")

ssh $USER@$PROJECT_URI "
source ~/.bash_profile
cd ~/running
docker-compose down
cd ~/
mkdir ~/v-$DATE_NOW
mv /tmp/Dockerfile ~/v-$DATE_NOW/
mv /tmp/docker-compose.yml ~/v-$DATE_NOW/
mv /tmp/docker-compose.override.yml ~/v-$DATE_NOW/
mv /tmp/nginx.conf ~/v-$DATE_NOW/
cd ~/v-$DATE_NOW
mkdir application
cd application
tar zxvf /tmp/application.tar.gz
rm /tmp/application.tar.gz
cd ~/
sudo chown -R $USER:$USER ~/running/database
sudo cp -R ~/running/database ~/v-$DATE_NOW/database
sudo chown -R $USER:$USER ~/v-$DATE_NOW/database
rm -Rf ~/running
ln -s ~/v-$DATE_NOW/ ~/running
cd ~/running
docker-compose up --build --force-recreate -d
sleep 10
docker-compose exec django python manage.py migrate
cd ~/
"
