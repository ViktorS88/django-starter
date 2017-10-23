#!/bin/sh
read -p "Project name: " PROJECT
: ${PROJECT:?"You must provide a project name"}

docker build --build-arg project_name=$PROJECT -t $PROJECT .
docker run --name $PROJECT -it --rm -v `pwd`/application:/root $PROJECT django-admin startproject $PROJECT .
docker run --name $PROJECT -it --rm $PROJECT pip freeze > application/requirements.txt
