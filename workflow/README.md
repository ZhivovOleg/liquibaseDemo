> Раздел в разработке

# Общие требования

На билд-агентах необходимо установить следующий софт для всех OS:
- [Java JRE](https://www.java.com/ru/download/manual.jsp)
- [Liquibase CLI](https://www.liquibase.org/download)
- [PostgreSQL JDBC driver](https://jdbc.postgresql.org/download.html)
- [SnakeYaml](https://bitbucket.org/snakeyaml/snakeyaml/wiki/Installation)

# Сценарий 1: монолит или SOA+sharedDB

1. Заводим репозиторий `<project_name>.liquibase`.
2. В корневом каталоге создается `liquibase.properties` с соответствующими настройками для сервиса и `dbchangelog.yaml`.
3. В корневом каталоге создаем каталог `.migrations`, там храним файлы миграций.
...
...

# Сценарий 2: микросервисы

Внутри этого сценария есть несколько вариантов

## Native
Сервисы деплоятся на виртуалки, базы данных это отдельные стабильные инстансы.

1. В корневом каталоге создаем каталог `.migrations`, там храним файлы миграций.
2. В корневом каталоге создается `liquibase.properties` с соответствующими настройками для сервиса и `dbchangelog.yaml`.
3. На билд-агенте добавляется шаг запуска консольной команды
    ```bash
    liquibase update
    ```
<br />
...
...

## Docker/Kubernetes + sharedDB
Сервисы сохраняются в виде образов Docker, базы данных это отдельные стабильные инстансы.
...
...

## Docker/Kubernetes (true microservice)
Сервисы сохраняются в виде образов Docker, база данных у каждого пода отдельная.
...
...

