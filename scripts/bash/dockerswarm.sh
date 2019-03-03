#!/bin/bash

echo '¿Cuántos nodos quieres que tenga tu Docker Swarm?:'
read NumeroNodos
echo '¿Cuántos replicas quieres para tu servicio?:'
read NumeroReplicas
echo 'Imagen del servicio que se creará:'
read Imagen
echo 'Puerto interno del servicio:'
read PuertoInterno
echo 'Puerto externo del servicio:'
read PuertoExterno

for ((i=1;i<=$NumeroNodos;i++));
do
   docker-machine create --driver virtualbox nodo$i
done

IpManager=$(docker-machine ip nodo1)
eval $(docker-machine env nodo1)
docker swarm init --advertise-addr $IpManager
TokenNodo=$(docker swarm join-token worker -q)

for ((i=2;i<=$NumeroNodos;i++));
do
	eval $(docker-machine env nodo$i)
	docker swarm join --token $TokenNodo $IpManager:2377
done

eval $(docker-machine env nodo1)

docker service create --replicas $NumeroReplicas --name miweb --publish published=$PuertoExterno,target=$PuertoInterno $Imagen
