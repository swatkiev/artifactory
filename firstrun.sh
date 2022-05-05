#!/bin/bash

mkdir -p /opt/artifactory/var/etc/
cd /opt/artifactory/var/etc/
touch ./system.yaml
chown -R 1030:1030 /opt/artifactory/var
chmod -R 777 /opt/artifactory/var
