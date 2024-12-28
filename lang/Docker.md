
<p align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/7/70/Docker_logo.png" width="400">
</p>


# Installation

```bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
```

## Container manipulation

```bash

docker run --rm --ti -d --name c1 nginx:latest
# Run an image as a container
# --rm delete container on stop
# --d (detach, run in background)
# --name name the container (useful!)
# --ti Get an interactive terminal
# nginx:latest image name to run

docker exec --ti <name|uuid> <command>
docker exec --ti c1 bash
# Launch a command inside a container
# --ti Get an interactive terminal

docker ps -a
# List active container
# -a list stopped containers too

docker stop <name|uuid>
# Stop a container, do not delete it

docker rm -f <name|uuid>
# Delete a container
# Cannot delete if running
# -f is equivalent to docker stop <id> && docker rm <id>

```


## Volumes

```bash

# Create a volume
docker volume create myVolume

# List volumes
docker volume ls

# Launch a container with a volume
docker run -d -v myVolume:/var/www/html/data --name c1 debian:latest

# Delete a volume
docker volume rm myVolume
```

Note on volume type :

> While bind mounts are dependent on the directory structure and OS of the host machine, volumes are completely managed by Docker. Volumes have several advantages over bind mounts: Volumes are easier to back up or migrate than bind mounts. You can manage volumes using Docker CLI commands or the Docker API.


```bash

555 B

# Bind mount docker
run -d --hostname --mount type=bind,src=/data/,destination=/usr/share/nginx/html/ --name c1 debian:latest

# Docker volume
docker volume create mynginx
docker run -d --hostname --mount type=volume,src=mynginx,destination=/usr/share/nginx/html/ --name c1 debian:latest

# TMPFS
docker run -d --hostname --mount type=tmpfs,destination=/usr/share/nginx/html/ --name c1 debian:latest
```

### Dockerfile

```dockerfile
# Commentaire
# INSTRUCTION
# escape \

# Image metadata
LABEL key=value

# Base image
FROM debian:latest

# Work directory for next instructions
WORKDIR /var/www/html

# User for the next instructions
USER ubuntu

# Build argument
ARG key value

# Environment variable
ENV key=value

# Copy files/directories
COPY source dist

# Run a shell command
RUN apt update && apt install git

# CMD run a shell command with an array
CMD ["apt", "update"]

# Declare listening ports
EXPOSE 80/tcp
```

Example

```dockerfile
FROM python@sha256:2659ee0e84fab5bd62a4d9cbe5b6750285e79d6d6ec00d8e128352dad956f096

# Labels
LABEL version=v1.0.0
LABEL owner=app

# Env vars
ENV FLASK_APP=app.py
ENV FLASK_ENV=dev

ARG APP_USER=ubuntu

# Create a dedicated user

RUN adduser -D ${APP_USER}

# Directory
WORKDIR /app

# Copy & install requirements
RUN apk add --no-cache curl=8.0.1-r0

USER ${APP_USER}:${APP_USER}
COPY --chown=${APP_USER} requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy all files
COPY --chown=${APP_USER} . .

# Expose port
EXPOSE 5000

CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]
```


Build an image
```bash
docker build -t myimage:v1.0.0 .
```