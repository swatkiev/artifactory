# artifactory
# Добавлено 3 файла:
# firstrun.sh - нужно запустить перед docker скриптом при первом запуске (artifactory.sh) или перед docker-compose скриптом при первом запуске (docker-compose.yml)
# artifactory.sh - скрипт на основе docker, предполагает запуск контейнера например по крону (либо можно добавить параметр --restart="always", тогда крон не нужен)
# docker-compose.yml - скрипт на основе docker-compose, параметр --restart="always" уже указан (если это не нужно, можно убрать и запускать по крону)
