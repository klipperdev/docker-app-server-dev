Documentation
=============

This document contains information on how to build and upload the docker image.

## 1) Installing the tools

- Install [Git](https://git-scm.com)
- Install [Amazon AWS CLI](https://aws.amazon.com/cli)
- Install [Docker Toolbox](https://www.docker.com/products/docker-toolbox)
- If you want to move the image of virtual machine:
  - Add the environment variable `MACHINE_STORAGE_PATH` with value `D:\Docker\machine` for example
- If your workspace isn't in the path `C:\Users`:
  - Launch the Docker Quickstart Terminal for the first initialization
  - Close the terminal and shutdown the VM in Virtualbox
  - In Virtualbox, add the shared folder:
    - `D:\Www` to `d/Wwww` with the automatic mounting
  - Close Virtualbox

## 2) Build the docker image

- Clone the repository `git@github.com:klipperdev/docker-app-server-dev.git` with Git
- Launch the Docker Quickstart Terminal
- Move the working directory in the folder of this repository (ex. `cd /d/Git/docker/klipper/docker-app-server-dev`)
- Create the docker image __*__:
  - `docker build -t <ecr-repository> .`
- Get the docker login for the Amazon AWS ECR __*__:
  - `aws ecr get-login --no-include-email --region <ecr-region>`
- Run the docker login command that was returned in the previous step __*__
- Tag the docker image __*__:
  - `docker tag <ecr-repository>:latest <ecr-repository-uri>:latest`
- Push the docker image in the Amazon AWS ECR __*__:
  - `docker push <ecr-repository-uri>:latest`

> **Notes:**
> - __*__ All commands are listed in the selected ECR repository of the Amazon AWS Console (button `Display push commands`)
> - `<ecr-region>` must be replaced by the name of the selected region of ECR repository (defined in the URI of the ECR repository)
> - `<ecr-repository>` must be replaced by the name of the selected ECR repository
> - `<ecr-repository-uri>` must be replaced by the URI of the selected ECR repository

## 3) Use the docker image in Docker Compose

Use the image directly in the docker compose file:

```yaml
# docker-compose.yml
version: '3.2'
services:
    app:
      container_name: app
      working_dir: /var/www/html
      image: <ecr-repository-uri>:latest
      volumes:
        - .:/var/www/html
```

Or with the Dockerfile:

```yaml
# ./docker-compose.yml
version: '3.2'
services:
    app:
      container_name: app
      working_dir: /var/www/html
      build:
        context: .
        dockerfile: docker/app/Dockerfile
      volumes:
        - .:/var/www/html
```

```
# ./docker/app/Dockerfile
FROM <ecr-repository-uri>:latest

# Your dockerfile actions
```

> **Notes:**
> - `<ecr-repository-uri>` must be replaced by the URI of the selected ECR repository

## List of useful commands

- `docker-machine ip`
- `docker-machine restart`
- `docker images`
- `docker rmi -f <image-tag-or-image-id>`
- `docker rmi $(docker images -f "dangling=true" -q)`
- `docker ps --filter "status=exited" | grep 'ago' | awk '{print $1}' | xargs --no-run-if-empty docker rm`
- `docker volume ls`
- `docker volume rm <volume-id>`
- `docker-compose build`
- `docker-compose up -d`
- `docker-compose up -d --remove-orphans`
- `docker-compose -f <docker-compose-file-1> -f <docker-compose-file-2> up -d`
- `docker-compose stop`
- `docker-compose kill`
- `docker-compose rm -f`
- `docker-compose ps`
- `docker-compose exec <service-name> <command>`
- `docker run -d --name <service-name> <image-tag-or-image-id>`
- `docker exec -it $(docker ps -aqf name=<container-name-pattern>) <command>`
- `docker exec -it $(docker ps | awk '{print $NF}' | grep -w <container-name-pattern>) <command>`
- `docker exec -it $(docker-compose ps -q <service-name>) <command>`
- `docker exec -it <container-name-or-id> <command>`

## List of useful commands to remove all containers

- `docker stop $(docker ps -a -q)`
- `docker rm $(docker ps -a -q)`
