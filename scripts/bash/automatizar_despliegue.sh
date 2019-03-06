#!/bin/bash

DockerHub="francisjgarcia"

cd ..

## GENERANDO LAS IMÁGENES
for Servicio in nginx apache mysql ftp
do
	echo "Generando imagen $DockerHub/$Servicio"
	cd ../$Servicio
	docker build -t $DockerHub/$Servicio .
done

## GENERANDO LAS IMÁGENES POSTFIX
for Servicio in reenviador servidor
do
	echo "Generando imagen $DockerHub/$Servicio"
	cd ../postfix/$Servicio
	docker build -t $DockerHub/postfix$Servicio .
	cd ..
done

## Desplegando contenedores
echo "Ejecutando docker-compose"
cd ..
docker-compose up -d
