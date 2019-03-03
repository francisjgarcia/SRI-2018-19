FROM debian
MAINTAINER Francis "francisjgarcia94@gmail.com"

RUN apt-get update && apt-get -y install mysql-server && service mysql start &&  mysql -u root -e "grant all privileges on *.* to 'frodo'@'%' identified by 'bolson'" && mysql -u root -e "flush privileges" && mysql -u root -e "CREATE DATABASE dbmysql" && mysql -u root -e "CREATE TABLE dbmysql.tbusuarios ( id int not null auto_increment, username varchar(50) not null, passwd text not null, email varchar(100) not null, primary key (id))"

EXPOSE 3306
ADD ["datos/50-server.cnf","/etc/mysql/mariadb.conf.d/50-server.cnf"]

ENTRYPOINT ["mysqld_safe"]
