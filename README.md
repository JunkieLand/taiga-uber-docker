# What is it ?

This project is a full, production ready,
[Docker](https://www.docker.com/) image for [Taiga](https://taiga.io/).

Everything is self contained in this image : the database (PostgreSQL),
every Taiga dependency, Nginx... You just need to run the image to
have a fully working Taiga.

It includes Taiga-Events for some live refreshments and interactions.

# Motivation

Though you can find many Docker images on
the [Docker Hub](https://hub.docker.com/search/?isAutomated=0&isOfficial=0&page=1&pullCount=0&q=taiga&starCount=0),
I have found out that it's really hard to make one work properly.

First, there are often remaning bugs in the install process, or the
examples are not up to date, and when the projects are not maintained,
it's up to you to debug it.

Then, most of them (if not all) made the choice to split [Taiga-Back](https://github.com/taigaio/taiga-back),
[Taiga-Front](https://github.com/taigaio/taiga-front), and sometimes
when they use it, [Taiga-Events](https://github.com/taigaio/taiga-events),
into separate Docker images. Besides, they are also dependent on other
Docker images such as PostgreSQL, Redis, RabbitMQ, Celery...

Though this may be a good practice for the reusability of Docker images,
it makes it complicated to debug, and to handle upgrade. Thus, here is
a single Docker image containing everything necessary to have a working
Taiga.

It just work.

# How to run it ?

## The command

All you need is :

    docker run \
      -d \
      --name working-taiga \
      -p 8080:80 \
      -v PATH_TO_LOG_DIRECTORY:/home/taiga/logs \
      -e TAIGA_HOSTNAME=localhost \
      JunkieLand:taiga

## The options

Here are the different settings you can tune though environment
variables (option `-e` as above in the command :

 * `-e TAIGA_HOSTNAME` : defaults to `localhost`.
 * `-e PUBLIC_REGISTER_ENABLED` : defaults to `True`. Other possible value is `False`.
 * `-e SCHEME` : defaults to `http`.
 * `-e DEBUG` : defaults to `False`. Other possible value is `True`.
   Usefull if you want to have more logs from the Taiga backend.

# How to build the image ?

To build the image, run the following command in this very directoy :

    docker build --tag taiga .

You can customize the build by changing variables in `scripts/env.sh`
