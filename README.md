# mcsaky_opengts
credited to : https://registry.hub.docker.com/u/mcsaky/opengts/

OpenGTS tracking server from http://opengts.sourceforge.net/

How to use:

- install docker
- docker pull mysql
- docker pull mcsaky/opengts

Start mysql and set the root password:

docker run --name opengts_mysql -e MYSQL_ROOT_PASSWORD=GtsSecretPassword -d mysql

Start opengts and link to mysql database:

docker run -it  -p 8080:8080  --name opengts --link opengts_mysql:mysql  mcsaky/opengts

After tomcat started, you can log to your machine on port 8080, for example:

http://localhost:8080 for tomcat (manager is admin, password admin)

or to opengts track application:

http://localhost:8080/track/Track (Account sysadmin is created without password).

Keep in touch on my G+ page related to opengts: https://plus.google.com/u/0/b/111505754940008833839/111505754940008833839/posts

