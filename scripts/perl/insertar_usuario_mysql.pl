
# Conexión con la base de datos
$dbh = DBI->connect("DBI:mysql:$dbname;host=$dbhost", $dbuser, $dbpwd) or die "Error de conexion: $DBI::errstr";

# Inserción de usuarios en la tabla de usuarios
$sth = $dbh->prepare("INSERT tbusuarios (username, passwd) VALUES( ? , ? )");

# Ejecutar la inserción con los usuarios introducidos por teclado
$sth->execute( "$usuario", "$clavecifrada" );
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
