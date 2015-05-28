# mcsaky_opengts
credited to : 

https://registry.hub.docker.com/u/mcsaky/opengts/

Keep in touch on my G+ page related to opengts: 

https://plus.google.com/u/0/b/111505754940008833839/111505754940008833839/posts


Modified by halilintar8 :) :

OpenGTS tracking server from http://opengts.sourceforge.net/

How to use:

- install docker

for ubuntu 14 (https://docs.docker.com/installation/ubuntulinux/):

$ sudo apt-get update $ sudo apt-get install wget

$ wget -qO- https://get.docker.com/ | sh

- docker pull halilintar8/mcsaky-opengts

- docker pull halilintar8/mcsaky-opengts-mysql

To build the Dockerfile:

- clone this github repo to your folder, and then

- docker build -t halilintar8/opengts .


Start mysql and set the root password:

docker run --name opengts_mysql -e MYSQL_ROOT_PASSWORD=GtsSecretPassword -d halilintar8/mcsaky-opengts-mysql

Start opengts and link to mysql database:

docker run -it  -p 8080:8080  --name opengts --link opengts_mysql:mysql halilintar8/mcsaky-opengts

ctrl p+q (to exit/detach from docker container without closing it)

After tomcat started, you can log to your machine on port 8080, for example:

http://localhost:8080 for tomcat (manager is admin, password admin)

or to opengts track application:

http://localhost:8080/track/Track (Account sysadmin is created without password).

