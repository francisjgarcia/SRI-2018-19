#!/usr/bin/perl

use POSIX qw/strftime/;

$DirectorioWeb="/root/proyecto_docker/ftp/datos/ficheros";

$DirectorioBackup="/root/backups";
system("mkdir -p $DirectorioBackup");

$Nombre="MiFTP";
$Separador="_";
$Fecha=strftime("%Y-%m-%d", localtime);

system("tar -pczf $DirectorioBackup/$Nombre$Separador$Fecha.tar.gz $DirectorioFTP");
