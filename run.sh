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

