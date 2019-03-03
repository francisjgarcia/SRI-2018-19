#!/usr/bin/perl

use POSIX qw/strftime/;

$DirectorioWeb="/root/proyecto_docker/apache/datos/web";

$DirectorioBackup="/root/backups";
system("mkdir -p $DirectorioBackup");

$Nombre="MiWeb";
$Separador="_";
$Fecha=strftime("%Y-%m-%d", localtime);

system("tar -pczf $DirectorioBackup/$Nombre$Separador$Fecha.tar.gz $DirectorioWeb");
