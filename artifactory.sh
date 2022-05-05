#!/bin/bash

docker stop artifactory
ping -c3 127.0.0.1
docker ps -a | grep artifactory | docker rm $(awk '{print $1}')
ping -c3 127.0.0.1 
docker run --name artifactory -v /opt/artifactory/var/:/var/opt/jfrog/artifactory -d -p 8081:8081 -p 8082:8082 docker.bintray.io/jfrog/artifactory-oss:latest
