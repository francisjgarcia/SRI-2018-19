FROM debian
MAINTAINER Francis "francisjgarcia94@gmail.com"

RUN apt-get update && apt-get install -y apache2 php libapache2-mod-php php-mysql libapache2-mod-authnz-external pwauth libaprutil1-dbd-mysql && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

ADD ["datos/francisjgarcia.conf","/etc/apache2/sites-available"]


RUN a2enmod dbd authn_dbd socache_shmcb authn_socache && usermod -a -G shadow www-data && useradd frodo && echo "frodo:bolson" | chpasswd && mkdir /dockerweb && a2dissite 000-default.conf && a2ensite francisjgarcia.conf && service apache2 restart

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
