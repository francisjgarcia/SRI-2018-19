FROM debian

RUN apt-get update \
    && apt-get install -y vsftpd libpam-mysql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --home /home/vsftpd --gid nogroup -m --shell /bin/false vsftpd

EXPOSE 20-21
EXPOSE 10090-10100

ADD ["datos/vsftpd.conf","/etc"]
ADD ["datos/vsftpd","/etc/pam.d"]
ADD ["datos/iniciar_vsftpd.sh","/usr/sbin/autostartftp.sh"]

CMD ["/usr/sbin/autostartftp.sh"]