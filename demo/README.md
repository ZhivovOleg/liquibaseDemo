# Пример развертывания БД

## Предварительные требования
Для всех OS:
- [Java JRE](https://www.java.com/ru/download/manual.jsp)
- [Liquibase CLI](https://www.liquibase.org/download)
- [PostgreSQL JDBC driver](https://jdbc.postgresql.org/download.html)
- [SnakeYaml](https://bitbucket.org/snakeyaml/snakeyaml/wiki/Installation)

Для реализации демо-сценария в контейнере:
- доступ к [Docker hub](https://hub.docker.com)
- [Docker CLI](https://docs.docker.com/engine/reference/commandline/cli/)

## Подготовка пустой БД в контейнере
> Здесь используется докер-образ, но можно просто установить БД локально

1. Скачиваем нужную версию образа (в данном случае последняя версия postgres)
    bash:
    ```bash
    docker pull postgres:latest
    ```

2. Запускаем чистый экземпляр:
    bash:
    ```bash
    docker run --name testpostgres -e POSTGRES_USER=testuser -e POSTGRES_PASSWORD=testpassword -e POSTGRES_DB=teststorage -p 5432:5432  -d postgres:latest
    ```
    > В данном случае мы заранее создаем database в инстансе, однако ниже будет рассмотрен кейс с развертыванием на чистый инстанс.

## Подготавливаем настройки liquibase

Все необходимые настройки можно указывать как параметры командной строки при запуске liquibase, однако это неудобно и чревато ошибками. 
Вместо этого лучше создать файл [liquibase.properties](./demo/liquibase.properties) в корневой директории, откуда будет запускаться liquibase и сохранить настройки в нем:
```properties
url: jdbc:postgresql://localhost:5432/teststorage?createDatabaseIfNotExist=true
username: testuser
password: testpassword
classpath: /path/to/file/postgresql-42.4.0.jar:/path/to/file/snakeyaml-1.30.jar
databaseChangeLog: сhangelog.yaml
logFile: demoDB.log
logLevel: INFO
liquibase.hub.mode=off
```

> Подробные значения этих и других параметров конфигурации вы можете посмотреть в [соответствующем разделе документации](https://docs.liquibase.com/concepts/home.html)

> Обратите внимание на строку _classpath_, кроме драйвера БД в ней указана библиотека для работы с _.yaml_ файлами. Эти библиотеки должны быть в вашей системе.

## Слепок текущей структуры

Очень важный момент - создание "нулевой" миграции, то есть структуры базы данных, которая существует на момент начала работы `liquibase`.
Делается это одной простой командой:
```bash
liquibase --changelog-file=zero_changelog.yaml generate-changelog
```
> Важная проблема данной команды в том, что она не позволяет сохранять процедуры, функции, триггеры и прочую логику. Только структуру таблиц, поэтому скрипт миграции логики лучше подготовить нативными средствами, каими как pg_dump().

> Подробное описание работы данной команды вы можете посмотреть в [соответствующем разделе документации](https://docs.liquibase.com/commands/snapshot/generate-changelog.html)

## Создание миграций

При запуске liquibase необходимо указывать файлы с подготовленными миграциями, которые называются `changeset`. Это неудобно при автоматизации, поэтому в проде применяется другой подход.

> В примере мы будем использовать в основном формат _yaml_ как наиболее удобный. Для примера будут представлены и другие форматы, однако необходимо помнить, что формат _sql_ изначально лишен значительной части функционала и не рекомендуется к использованию.

Мы создадим `master-changelog`, в котором указывается директория, хранящая 'changeset'ы, назовем его [changelog.yaml](./demo/changelog.yaml):
```yaml
databaseChangeLog:
  - includeAll:
      path: "migrations"
```
для контраста вот аналогичный по функции `master-changelog`, но в формате `xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:ext="http://www.liquibase.org/xml/ns/dbchangelog-ext"
  xmlns:pro="http://www.liquibase.org/xml/ns/pro" xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
		http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.9.xsd
		http://www.liquibase.org/xml/ns/dbchangelog-ext http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-ext.xsd
		http://www.liquibase.org/xml/ns/pro http://www.liquibase.org/xml/ns/pro/liquibase-pro-4.9.0.xsd">
  <includeAll path="migrations"/>
</databaseChangeLog>
```
<br />
Мы указали, что все миграции будем складывать в каталоге `migrations`, так что создадим его и в нем нашу первую миграцию, `./migrations/changeset_1.yaml`:

```yaml
databaseChangeLog:
  - changeSet:
      id: 1
      author: zhivov_oa
      labels: "create_table"
      comment: "create table"
      changes:
        - tagDatabase:
            tag: yaml_tag
        - createTable:
            tableName: yaml_table
            columns:
              - column:
                  name: id
                  type: int
                  autoIncrement: true
                  constraints:
                    primaryKey: true
                    nullable: false
              - column:
                  name: name
                  type: varchar(255)
```

> подробные сведения о доступных атрибутах есть в [соответствующем разделе документации](https://docs.liquibase.com/concepts/changelogs/working-with-changelogs.html)
<br />

## Выполнение миграциий

> При указании путей файлов в параметрах командной строки liquibase необходимо учитывать, что каталог запуска является рабочим каталогом и все пути в файлах миграций тоже будут относительны этого каталога.

Для запуска миграций делаем следующее:
1. [Запускаем postgres](#подготовка-пустой-бд-в-контейнере)
0. Открываем bash/powershell;
0. Переходим в каталог с файлом liquibase.properties:
    ```bash
    cd ./liqubaseDemo/demo
    ```
0. запускаем миграцию:
    ```bash
    liquibase update
    ```
0. видим в консоли результат:
    ```bash
    Starting Liquibase at 08:15:05 (version 4.12.0 #3073 built at 2022-06-17 05:59+0000)
    Liquibase Version: 4.12.0
    Liquibase Community 4.12.0 by Liquibase
    Running Changeset: migrations/changeset_1.yaml::4::zhivov_oa_yaml
    Logs saved to /Users/aidaho/_git/liquibaseDemo/demo/demo/../testdb.log
    Liquibase command 'update' was executed successfully.
    ```

## Проверяем результат

В базе данных появились таблицы:
- `databasechangelog` - здесь хранится вся история миграций.
- `databasechangeloglock` - служебная таблица, необходимая при работе liquibase.
- `test_yaml` - таблица, которая создавалась миграцией.
<br />

рассмотрим подробнее таблицу истории:
```json
{
  "id": "1",
  "author": "zhivov_oa",
  "filename": "migrations/changeset_1.yaml",
  "dateexecuted": "2022-07-09 08:15:08.543702",
  "orderexecuted": 1,
  "exectype": "EXECUTED",
  "md5sum": "8:cfddea4e1dc5b8736dd0df8ed2d21812",
  "description": "tagDatabase; createTable tableName=test_yaml",
  "comments": "create table",
  "tag": "yaml_tag",
  "liquibase": "4.12.0",
  "contexts": null,
  "labels": "create_table",
  "deployment_id": "7343708323"
}
```
<br />
как видим, liquibase предоставляет множество параметров контроля - всяческие тэги, дату, id и порядковый номер миграции, автора и даже имя файла.

## Продвинутые миграции

А теперь воспользуемся более полным списком доступных фич и создадим продвинутую миграцию.

### Предусловия (preConditions)

В первую очередь зададим поведение в случае ошибок предусловий:
- onFail: регламентирует поведение changeset'а в случае нарушения условий
- onError: регламентирует поведение changeset'а в случае ошибок при проверке условий (например ошибок sql-команд)

Теперь зададим непосредственно предусловия (`preConditions`):
- and: обозначает, что мы ожидаем TRUE всех вложенных условий.
- dbms: указываем, к какому типу DB применим данный changeset
- tableExists: проверяем, существует ли указанная таблица в БД
- sqlCheck: запускаем SQL-скрипт и ожидаем от него определенный результат

> подробнее о предусловиях можно узнать в [разделе документации о Preconditions](https://docs.liquibase.com/concepts/changelogs/preconditions.html)

```yaml
- preConditions:
    - onFail: HALT
    - onError: HALT 
    - and:
        - dbms:
            type: 'postgresql'
        - tableExists:
            tableName: test_yaml
        - sqlCheck:
            expectedResult: 0
            sql: select count(*) from test_yaml
```

### Откат (roolback)

> Обратите внимание, что в первом changeset мы поставили тэг для базы данных. Тэги в первую очередь предназначены для использования при откате и предоставляют удобный и простой механизм.

> подробнее о предусловиях можно узнать в [разделе документации о RollBack](https://docs.liquibase.com/workflows/liquibase-community/using-rollback.html)

Теперь настроим поведение при откате:

```yaml
rollback: alter table test_yaml drop column age
```

### Итоговый changeset

Не забываем добавить тэг для удобства отката и кладем итоговый файл в каталог миграций, чтобы он сам подхватился при запуске `update`:
`./migrations/changeset_2.yaml`:
```yaml
databaseChangeLog:
  - preConditions:
      - onFail: WARN
      - onError: HALT
      - and:
          - dbms:
              type: "postgresql"
          - tableExists:
              tableName: test_yaml
          - sqlCheck:
              expectedResult: 0
              sql: select count(*) from test_yaml
  - changeSet:
      id: 2
      author: zhivov_oa
      labels: "update_table"
      comment: "update table"
      rollback: alter table test_yaml drop column age
      changes:
        - tagDatabase:
            tag: alter_table
        - addColumn:
            tableName: test_yaml
            columns:
              - column:
                  name: age
                  type: numeric

```
<br />
