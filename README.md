# artifactory
# Добавлено 3 файла:
# firstrun.sh - нужно запустить перед docker скриптом при первом запуске (artifactory.sh) или перед docker-compose скриптом при первом запуске (docker-compose.yml)
# artifactory.sh - скрипт на основе docker, предполагает запуск контейнера например по крону (либо можно добавить параметр --restart="always", тогда крон не нужен)
# docker-compose.yml - скрипт на основе docker-compose, параметр --restart="always" уже указан (если это не нужно, можно убрать и запускать по крону)
# Работа с artifactory:
jfrog config add -> add your server-id (test-jfrog)

jfrog config edit test-jfrog --url=http://127.0.0.1:8081/ --apikey=*** --user=admin

jfrog config show                                              Server ID:                      test-jfrog

JFrog platform URL:             http://127.0.0.1:8081/

Artifactory URL:                http://127.0.0.1:8081/artifactory/

Distribution URL:               http://127.0.0.1:8081/distribution/

Xray URL:                       http://127.0.0.1:8081/xray/

Mission Control URL:            http://127.0.0.1:8081/mc/

Pipelines URL:                  http://127.0.0.1:8081/pipelines/

User:                           admin

Password:                       ***

Default:                        true

# Примеры curl команд:
curl -X PUT -u $ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD http://127.0.0.1:8081/artifactory/test-local-repository/ssl.txt -T ~/ssl.txt

curl -X GET -u $ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD http://127.0.0.1:8081/artifactory/test-local-repository/ssl.txt > ~/ssl.txt

curl -X DELETE -u $ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD http://127.0.0.1:8081/artifactory/api/storage/test-local-repository/ssl.txt (only with licence key)

curl -X DELETE -u $ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD http://127.0.0.1:8081/artifactory/test-local-repository/ssl.txt

# Примеры jfrog команд:
jfrog rt dl test-local-repository/ssl.txt download-repo/ --url=$ARTIFACTORY_URL --user=$ARTIFACTORY_USER --password=$ARTIFACTORY_PASSWORD --server-id=test-jfrog (if not default)

jfrog rt u ~/ssl.txt test-local-repository/ --url=$ARTIFACTORY_URL --user=$ARTIFACTORY_USER --password=$ARTIFACTORY_PASSWORD --server-id=test-jfrog (if not default)

jfrog rt cp test-local-repository/ssl.txt test-local-repository/ssl2.txt --url=$ARTIFACTORY_URL --user=$ARTIFACTORY_USER --password=$ARTIFACTORY_PASSWORD --server-id=test-jfrog (if not default) (only with licence key)

jfrog rt mv test-local-repository/ssl.txt test-local-repository/ssl1.txt --url=$ARTIFACTORY_URL --user=$ARTIFACTORY_USER --password=$ARTIFACTORY_PASSWORD --server-id=test-jfrog (if not default) (only with licence key)

jfrog rt del test-local-repository/ssl.txt --url=$ARTIFACTORY_URL --user=$ARTIFACTORY_USER --password=$ARTIFACTORY_PASSWORD --server-id=test-jfrog (if not default)

jfrog rt s test-local-repository/*.txt --url=$ARTIFACTORY_URL --user=$ARTIFACTORY_USER --password=$ARTIFACTORY_PASSWORD --server-id=test-jfrog (if not default)

# Работа с aql файлами для удаления файлов из artifactory:
Перед выполнением команды при первом запуске:

export CI=True

source ~/.bashrc

Далее выполняем команду:

jf rt del --spec artifactory/test_files_folders.aql --url=$ARTIFACTORY_URL --user=$ARTIFACTORY_USER --password=$ARTIFACTORY_PASSWORD

На хосте хранится специальный aql файл с кодом:

cat artifactory/test_files_folders.aql

{
"files": [{
    "aql": {
         "items.find": {
             "repo": "test",
             "name": { "$match": "4*" },
             "created": {
                 "$before": "5d"
             },
             "type": "any",
            "$or": [{
    "path": { "$match": "test-server/main" },
    "path": { "$match": "test-server/test-01" },
    "path": { "$match": "test-server/test-02" },
    "path": { "$match": "test-server/test-03" },
       }]
         }
    }
}]}
# Также в качестве альтернативы был создан скрипт на основе curl запроса, но он менее юзабельный, так как предполагает постоянное введение конечной даты в милисекундах и может удалять только файлы, при этом оставляя папки пустыми:

RESULTS=`curl -u $ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD "http://127.0.0.1:8081/artifactory/api/search/creation?from=$date_in_milisec_from&to=$date_in_milisec_to&repos=test" | grep /test-server | grep uri | awk '{print $3}' | sed s'/.$//' | sed s'/.$//' | sed -r 's/^.{1}//' | sed -r 's|/api/storage||'`

curl -X DELETE -u $ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD $RESULTS

online convertor date to milisec -> https://currentmillis.com/
