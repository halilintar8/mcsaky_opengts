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

Dockerfile:

FROM dockerfile/ubuntu

MAINTAINER mcsaky <mihai.csaky@sysop-consulting.ro>

ENV GTS_HOME /usr/local/gts
ENV CATALINA_HOME /usr/local/tomcat
ENV GTS_VERSION 2.5.6
ENV TOMCAT_VERSION 7.0.54
ENV JAVA_HOME /usr/local/java
ENV ORACLE_JAVA_HOME /usr/lib/jvm/java-6-oracle/

RUN \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  apt-get update && \
  apt-get install -y python-software-properties && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java6-installer

RUN ln -s $ORACLE_JAVA_HOME $JAVA_HOME

RUN apt-get -y install libmysql-java  liblog4j1.2-java libgnumail-java ant curl unzip  sudo tar

RUN curl -L http://downloads.sourceforge.net/project/opengts/server-base/$GTS_VERSION/OpenGTS_$GTS_VERSION.zip -o /usr/local/OpenGTS_$GTS_VERSION.zip && \
    unzip /usr/local/OpenGTS_$GTS_VERSION.zip -d /usr/local && \
    ln -s /usr/local/OpenGTS_$GTS_VERSION $GTS_HOME

RUN curl -L http://archive.apache.org/dist/tomcat/tomcat-7/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz -o /usr/local/tomcat.tar.gz

RUN  tar zxf /usr/local/tomcat.tar.gz -C /usr/local && rm /usr/local/tomcat.tar.gz && ln -s /usr/local/apache-tomcat-$TOMCAT_VERSION $CATALINA_HOME

ADD tomcat-users.xml /usr/local/apache-tomcat-$TOMCAT_VERSION/conf/

#put java.mail in place
RUN curl -L http://java.net/projects/javamail/downloads/download/javax.mail.jar -o /usr/local/OpenGTS_$GTS_VERSION/jlib/javamail/javax.mail.jar

# put mysql.java in place
RUN curl -L http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.31.tar.gz  -o /usr/local/OpenGTS_$GTS_VERSION/jlib/jdbc.mysql/mysql-connector-java-5.1.31.tar.gz && \
     tar xvf /usr/local/OpenGTS_$GTS_VERSION/jlib/jdbc.mysql/mysql-connector-java-5.1.31.tar.gz mysql-connector-java-5.1.31/mysql-connector-java-5.1.31-bin.jar -O > /usr/local/OpenGTS_$GTS_VERSION/jlib/jdbc.mysql/mysql-connector-java-5.1.31-bin.jar && \
     rm -f /usr/local/OpenGTS_$GTS_VERSION/jlib/jdbc.mysql/mysql-connector-java-5.1.31.tar.gz

RUN cp $GTS_HOME/jlib/*/*.jar $CATALINA_HOME/lib
RUN cp $GTS_HOME/jlib/*/*.jar $JAVA_HOME/jre/lib/ext/

RUN cd $GTS_HOME; sed -i 's/\(mysql-connector-java\).*.jar/\1-5.1.31-bin.jar/' build.xml; \
    sed -i 's/\(<include name="mail.jar"\/>\)/\1\n\t<include name="javax.mail.jar"\/>/' build.xml; \
    sed -i 's/"mail.jar"/"javax.mail.jar"/' src/org/opengts/tools/CheckInstall.java

ADD run.sh /usr/local/apache-tomcat-$TOMCAT_VERSION/bin/
RUN chmod 755 /usr/local/apache-tomcat-$TOMCAT_VERSION/bin/run.sh


RUN rm -rf /usr/local/tomcat/webapps/examples /usr/local/tomcat/webapps/docs
EXPOSE 8080
CMD ["/usr/local/tomcat/bin/run.sh"]



run.sh

#!/bin/bash
sed -i 's/#db.sql.rootUser=root/db.sql.rootUser=root/' $GTS_HOME/common.conf
sed -i "s/#db.sql.rootPass=rootpass/db.sql.rootPass=$MYSQL_ENV_MYSQL_ROOT_PASSWORD/" $GTS_HOME/common.conf
sed -i "s/db.sql.host=localhost/db.sql.host=$MYSQL_PORT_3306_TCP_ADDR/" $GTS_HOME/common.conf
cd $GTS_HOME; ant all
$GTS_HOME/bin/initdb.pl -rootPass=$MYSQL_ENV_MYSQL_ROOT_PASSWORD
$GTS_HOME/bin/dbAdmin.pl -tables=ca
$GTS_HOME/bin/admin.sh Account -account=sysadmin -nopass -create
cp $GTS_HOME/build/*.war $CATALINA_HOME/webapps/
$CATALINA_HOME/bin/catalina.sh run



tomcat-users.xml

<?xml version='1.0' encoding='utf-8'?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<tomcat-users>
<!--
  NOTE:  By default, no user is included in the "manager-gui" role required
  to operate the "/manager/html" web application.  If you wish to use this app,
  you must define such a user - the username and password are arbitrary.
-->
<!--
  NOTE:  The sample user and role entries below are wrapped in a comment
  and thus are ignored when reading this file. Do not forget to remove
  <!.. ..> that surrounds them.
-->
  <role rolename="admin-gui"/>
  <role rolename="admin-script"/>
  <role rolename="manager-gui"/>
  <role rolename="manager-status"/>
  <role rolename="manager-script"/>
  <role rolename="manager-jmx"/>
  <user name="admin" password="admin" roles="admin-gui,admin-script,manager-gui,manager-status,manager-script,manager-jmx"/>
</tomcat-users>


