#!/usr/bin/perl

## NOTA: Este script debe ser ejecutado desde el equipo que tiene los contenedores docker.

# Pedir datos de usuario y contraseña por teclado
print "Nuevo usuario del Sistema: ";
$usuario=<STDIN>;
print "Contraseña: ";
$clave=<STDIN>;

# Eliminar salto de línea
chop($usuario);
chop($clave);

# Ejecutar openssl para cifrar la contraseña
my $clavecifrada = qx(openssl passwd -crypt $clave);

# Eliminar salto de línea
chop($clavecifrada);

# Bucle para crear el usuario y modificar su contraseña en los tres servidores apache
@ListadoServidoresWeb = ("SrvWeb1", "SrvWeb2", "SrvWeb3"); 
foreach $SrvWeb (@ListadoServidoresWeb) { 
   system("docker exec -it $SrvWeb useradd $usuario");
   system("docker exec -it $SrvWeb usermod -p $clavecifrada $usuario");
}

# Crea el usuario y modifica su contraseña en el servidor de correos postfix
system("docker exec -it SrvCorreoServer useradd $usuario");
system("docker exec -it SrvCorreoServer usermod -p $clavecifrada $usuario");
system("docker exec -it SrvCorreoServer mkdir /home/$usuario");
