# My own Django starter

- Docker & Docker Compose
- Nginx & SSL (Let's Encrypt)
- PostgreSQL
- Django
- Gunicorn

## Install (first usage)
1. Fork this project (or download the master.zip)
2. Delete the `.git` folder
3. Rename the folder to your project name
4. Execute `install.sh` and provide your project name

## Usage
Run `docker-compose up`

## Deploy
1. Edit `deploy.sh` with your project envvars (`USER` and `SERVER_URI`)
2. Run `./deploy.sh`


## Roadmap
- [ ] Edit `DATABASE` in `settings.py` to connect with the `database` service
