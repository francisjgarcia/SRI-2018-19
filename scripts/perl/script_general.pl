#!/usr/bin/perl

## NOTA: Este script debe ser ejecutado desde el equipo que tiene los contenedores docker.

# Pedir datos de usuario y contraseña por teclado
print "Nuevo usuario para la base de datos: ";
$usuario=<STDIN>;
print "Correo electrónico: ";
$email=<STDIN>;
print "Contraseña: ";
$clave=<STDIN>;

# Eliminar salto de línea
chop($usuario);
chop($email);
chop($clave);

# Ejecutar openssl para cifrar la contraseña
my $clavecifrada = qx(openssl passwd -crypt $clave);

# Eliminar salto de línea
chop($clavecifrada);

# Utilizar librería de conexión con la base de datos
use DBI;

# Parámetros de conexión con la base de datos
my $dbname = 'dbmysql';
my $dbhost = 'francisjgarcia.ml';
my $dbuser = 'frodo';
my $dbpwd = 'bolson';
my $dbh;
my $stmt;
my $sth;
my $row;

# Conexión con la base de datos
$dbh = DBI->connect("DBI:mysql:$dbname;host=$dbhost", $dbuser, $dbpwd) or die "Error de conexion: $DBI::errstr";

# Inserción de usuarios en la tabla de usuarios
$sth = $dbh->prepare("INSERT tbusuarios (username, passwd, email) VALUES( ? , ?, ? )");

#(MYSQL)# Crea el usuario para poder conectarnos utilizando el servidor MySQL en APACHE
$sth->execute( "$usuario", "$clavecifrada", "$email" );

#(VSFTPD)# Crea los el usuario para poder conectarnos vía FTP
system("docker exec -it SrvFTP mkdir -p -m 555 /home/vsftpd/$usuario");
system("docker exec -it SrvFTP chown vsftpd:nogroup /home/vsftpd/$usuario");

#(APACHE)# Crea el usuario para conectarnos útilizando PAM en los servidores APACHE
@ListadoServidoresWeb = ("SrvWeb1", "SrvWeb2", "SrvWeb3"); 
foreach $SrvWeb (@ListadoServidoresWeb) {
   system("docker exec -it $SrvWeb useradd $usuario");
   system("docker exec -it $SrvWeb usermod -p $clavecifrada $usuario");
}

#(SERVIDOR POSTFIX)# Crea el usuario y modifica su contraseña en el servidor de correos postfix
system("docker exec -it SrvCorreoServer useradd $usuario");
system("docker exec -it SrvCorreoServer usermod -p $clavecifrada $usuario");
system("docker exec -it SrvCorreoServer mkdir /home/$usuario");

#(REENVIADOR POSTFIX)# Envía un email al usuario con su nombre de usuario y contraseña
system("docker exec -it SrvCorreoReenviador mail -A documentacion.txt -s 'Se ha creado tu usuario personal: $usuario' $email");

print "Se ha insertado al usuario $usuario correctamente.\n";

# Obtener los usuarios existentes
$sth = $dbh->prepare("SELECT username FROM tbusuarios");
$sth->execute();

print "Existen los siguientes usuarios en la base de datos:\n";
$coma="";
while ($row = $sth->fetchrow_hashref) {
	print $coma;
	print $row->{username};
	$coma=", ";
}
print "\n";
# Desconexión de la base de datos en caso de error
if (! $dbh->disconnect) {
	warn "Error al desconectarse de la base de datos: $DBI::errstr";
}
