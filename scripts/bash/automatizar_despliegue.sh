#!/bin/bash

DockerHub="francisjgarcia"

cd ..

## GENERANDO LAS IMÁGENES
for Servicio in nginx apache mysql ftp postfix
do
	echo "Generando imagen $DockerHub/$Servicio"
	cd ../$Servicio
	docker build -t $DockerHub/$Servicio .
done

## Desplegando contenedores
echo "Ejecutando docker-compose"
cd ..
docker-compose up -d
