#!/usr/bin/env bash
USER=ubuntu
SERVER_URI=example.com
# SERVER_URI can be an ip (192.168.0.112), an alias located in your .ssh/config file (my-server) or a domain.

git archive -o /tmp/application.tar.gz HEAD:application

scp /tmp/application.tar.gz $USER@$SERVER_URI:/tmp/
scp Dockerfile docker-compose.yml docker-compose.dev.yml nginx.conf $USER@$SERVER_URI:~/

DATE_NOW=$(date +"%Y%m%d_%H%M%S")

ssh $USER@$SERVER_URI '
source ~/.bash_profile
cd ~/running
docker-compose down
cd ~/
mkdir ~/v-'$DATE_NOW'
mv Dockerfile ~/v-'$DATE_NOW'/
mv docker-compose.yml ~/v-'$DATE_NOW'/
mv docker-compose.dev.yml ~/v-'$DATE_NOW'/docker-compose.override.yml
mv nginx.conf ~/v-'$DATE_NOW'/
cd ~/v-'$DATE_NOW'
mkdir application
cd application
tar zxvf /tmp/application.tar.gz
rm /tmp/application.tar.gz
cd ~/

test -e ~/running/database/ && \
sudo chown -R '$USER':'$USER' ~/running/database && \
sudo cp -R ~/running/database ~/v-'$DATE_NOW'/database && \
sudo chown -R '$USER':'$USER' ~/v-'$DATE_NOW'/database

test -e ~/running/application/media/ && \
sudo chown -R '$USER':'$USER' ~/running/application/media && \
sudo cp -R ~/application/media ~/v-'$DATE_NOW'/application/media && \
sudo chown -R '$USER':'$USER' ~/v-'$DATE_NOW'/application/media && \
sudo chmod -R a+wx ~/v-'$DATE_NOW'/application/media

rm -Rf ~/running
ln -s ~/v-'$DATE_NOW'/ ~/running
cd ~/running
docker-compose up --build --force-recreate -d
sleep 10
docker-compose exec -T django ./manage.py migrate
docker-compose exec -T django ./manage.py collectstatic --noinput
cd ~/
LATEST=$(cat ~/latest.txt)
docker rmi ${LATEST}
echo v-'${DATE_NOW}'_django > ~/latest.txt
'
