#!/usr/bin/env bash
USER=ubuntu
SERVER_URI=example.com
# SERVER_URI can be an ip (192.168.0.112), an alias located in your .ssh/config file (my-server) or a domain.

git archive -o /tmp/application.tar.gz HEAD:application
tar -czvf /tmp/new_release.tar.gz Dockerfile docker-compose.yml docker-compose.prod.yml nginx.conf

scp /tmp/application.tar.gz $USER@$SERVER_URI:/tmp/
scp /tmp/new_release.tar.gz $USER@$SERVER_URI:/tmp/

DATE_NOW=$(date +"%Y%m%d_%H%M%S")

ssh $USER@$SERVER_URI '
source ~/.bash_profile
cd ~/running
docker-compose down
cd ~/
mkdir ~/v-'$DATE_NOW'
cd ~/v-'$DATE_NOW'
mv /tmp/new_release.tar.gz ~/v-'$DATE_NOW'/
tar zxvf new_release.tar.gz
rm new_release.tar.gz
mv docker-compose.prod.yml docker-compose.override.yml
mkdir application
cd application
tar zxvf /tmp/application.tar.gz
rm /tmp/application.tar.gz
cd ~/
test -e ~/running/database/ && \
sudo chown -R '$USER':'$USER' ~/running/database && \
sudo cp -R ~/running/database ~/v-'$DATE_NOW'/database && \
sudo chown -R '$USER':'$USER' ~/v-'$DATE_NOW'/database
rm -Rf ~/running
ln -s ~/v-'$DATE_NOW'/ ~/running
cd ~/running
docker-compose up --build --force-recreate -d
sleep 10
docker-compose exec -T django ./manage.py migrate
docker-compose exec -T django ./manage.py collectstatic --noinput
cd ~/
LATEST=$(cat ~/latest.txt)
docker rmi ${LATEST}_django ${LATEST}_django_robot
echo v'${DATE_NOW//_/}' > ~/latest.txt
'
