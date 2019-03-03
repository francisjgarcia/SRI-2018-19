#!/usr/bin/perl

use POSIX qw/strftime/;

$DirectorioBackup="/root/backups";

system("mkdir -p $DirectorioBackup");

$NumArgs = $#ARGV + 1;
if ($NumArgs != 4) {
    print "Debes pasarle al script los siguientes parámetros y en el siguiente orden:\n";
    print "Host, Usuario, contraseña y base de datos.\n";
    exit;
}

$Host=$ARGV[0];
$Usuario=$ARGV[1];
$Clave=$ARGV[2];
$Database=$ARGV[3];

$Separador="_";
$Fecha=strftime("%Y-%m-%d", localtime);

system("mysqldump -h $Host -u $Usuario -p$Clave $Database | gzip > $DirectorioBackup/$Database$Separador$Fecha.sql.gz");
