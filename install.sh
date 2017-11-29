#!/bin/sh
read -p "Project name: " PROJECT
: ${PROJECT:?"You must provide a project name"}

read -p "Your timezone: (America/Los_Angeles) " TIMEZONE
: ${TIMEZONE:?"You must provide your timezone"}


IMAGE_NAME=`printf '%s\n' "${PWD##*/}" | tr -d '-'`_django

docker build --build-arg PROJECT_NAME=$PROJECT --build-arg TIMEZONE=$TIMEZONE -t $IMAGE_NAME .
docker run --name $PROJECT -it --rm -v `pwd`/application:/root $IMAGE_NAME django-admin startproject $PROJECT .
docker run --name $PROJECT -it --rm $IMAGE_NAME pip freeze > application/requirements.txt
