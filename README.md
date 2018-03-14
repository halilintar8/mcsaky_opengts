# mcsaky_opengts

## credited to : 

https://registry.hub.docker.com/u/mcsaky/opengts/

Keep in touch on my (mcsaky) G+ page related to opengts: 

https://plus.google.com/u/0/b/111505754940008833839/111505754940008833839/posts


- Modified by halilintar8 :) :

OpenGTS tracking server from http://opengts.sourceforge.net/

http://www.geotelematic.com/CelltracGTS/GPRMC.html


## How to use:

- install docker ce for ubuntu 16 (https://docs.docker.com/install/linux/docker-ce/ubuntu/):

- pull docker

        $ docker pull halilintar8/mcsaky-opengts

        $ docker pull halilintar8/mcsaky-opengts-mysql


To build the Dockerfile:

    clone this github repo to your folder, and then

    $ docker build -t halilintar8/opengts .


Start mysql and set the root password:

    $ docker run --name opengts_mysql -e MYSQL_ROOT_PASSWORD=GtsSecretPassword -d mariadb:latest

Start opengts and link to mysql database:

    $ docker run -d -p 8080:8080 -p 5055:5055 --name opengts --link opengts_mysql:mysql halilintar8/opengts (recommended)
    
    or :

    $ docker run -it -p 8080:8080 -p 5055:5055 --name opengts --link opengts_mysql:mysql halilintar8/opengts

    ctrl p+q (to exit/detach from docker container without closing it)


After tomcat started, you can log to your machine on port 8080, for example:

      http://localhost:8080 for tomcat (manager is admin, password admin)

or to opengts track application:

      http://localhost:8080/track/Track (account=sysadmin, password=sysadmin).


