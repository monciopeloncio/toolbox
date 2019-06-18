#!/usr/bin/env bash
currentDir=`pwd`

cleanDanglingImages() {
    echo "Limpiando imagenes huerfanas"
    docker rmi $(docker images -f "dangling=true" 2> /dev/null -q)
}

back() {
    cd $currentDir;
    echo "Construyendo imagen del back"
    rm -fR back/code
    mkdir -p back/code
    cd back/code
    git clone <urlRepository> .
    git checkout pre
    docker build -t <dockerNameBack>:1.0 .

    echo "Levantando contenedor del back"
    docker stop <dockerNameBack> 2> /dev/null
    docker rm -f <dockerNameBack> 2> /dev/null
    docker run -d --name <dockerNameBack> -p 25000:80 <dockerNameBack>:1.0    
}

front() {
    cd $currentDir;
    echo "Construyendo imagen del front"
    rm -fR front/code
    mkdir -p front/code    
    cd front/code
    git clone <urlRepository> .
    git checkout pre
    yarn install
    yarn build    
    docker build -t <dockerNameFront>:1.0 .

    echo "Levantando contenedor del front"
    docker stop <dockerNameFront> 2> /dev/null
    docker rm -f <dockerNameFront> 2> /dev/null
    docker run -d --name <dockerNameFront> -p 22000:80 <dockerNameFront>:1.0
}

deploy(){
    echo "Iniciando despliegue"
    cleanDanglingImages 2> /dev/null
    front
    back
}

deploy