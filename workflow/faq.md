# FAQ
Базовые рабочие вопросы

## История создания

Кто когда какую миграцию сделал (как разработчик) + в рамках какой задачи (и мб кто это одобрил).

##### Answer:

В файле миграции должны быть заданы поля:
```yaml
- changeSet:
    author: "zhivov_oa"
    comment: "<ссылка на задачу в гитлабе>
```
<br />
Тогда в БД можно выполнить запрос вида:
```sql
SELECT * FROM databasechangelog WHERE author=<имя разработчика>
```
чтобы получить все миграции от разработчика 

## История стендов

когда какую миграцию мы накатили на стенд + кто накатил (в рамках какого процесса).

##### Answer:

Для разделения стендов используется поле [contextFilter](https://docs.liquibase.com/concepts/changelogs/attributes/contexts.html) changeSet'а:
```yaml
- changeSet:
    contextFilter: "bank_a, bank_b, !test"
```
соответственно запуск соотв миграций:
```bash
liquibase --context="bank_b" update
```

## Связь миграций с билдами сервисов. 
в идеале сквозная на группу сервисов, чтобы иметь возможность группового отката.

##### Answer:

Используется функционал тэгов:
- команда [tag](https://docs.liquibase.com/commands/maintenance/tag.html) помечает текущую версию базы данных тэгом.
- элемент [tagDatabase](https://docs.liquibase.com/change-types/tag-database.html) делает то же самое, но при применении changeSet'а.


## Версионирование состояния базы данных
С возможностью разделять на стенды/коробки, чтобы понимать, например, что у нас сейчас в конкретном стенде.

##### Answer:

Для того чтобы пометить БД для определенной "коробки" или версии использовуется поле [labels](https://docs.liquibase.com/concepts/changelogs/attributes/labels.html)
```yaml
- changeSet:
    id: 1
    labels: "v1.4, !v2.0"
```
а для их применения используется флаг `--labelFilter`

## Автотестирование миграций
как повышение стабильности.

##### Answer:

Автотестирования миграций в рамках `liquibase` не предусмотрено, для этого предполагается использовать либо [локальную БД в контейнере](./../demo/README.md), либо тестовый контур в рамках CI/CD.

## Возможность проведения code review на миграции

##### Answer:

Согласно [workflow](./README.md), миграции проходят такой же CI-процесс (git-flow/svn-flow), как и любой другой код, соответственно перед слиянием в релизную ветку код может быть проверен.

## Возможность встраивания в devops процесса накатки/отката миграций

##### Answer:

Согласно [workflow](./README.md), миграции проходят такой же СD-процесс, как и любой другой код, соответственно деплой миграций в БД происходит в инструменте CD (gitlab/bitbucket).

## Возможность разворота стенда с базой данных нужной конфигурации

##### Answer:

Стенд может быть развернут изменением адреса БД в файле конфигурации и запуском команды 
```bash
liquibase update
```
к примеру [локально](./../demo/README.md)

## Возможность наполнения стенда нужными данными

##### Answer:

Для наполнения данных можно использовать одно из следующих полей:
- [insert](https://docs.liquibase.com/change-types/insert.html) для вставки данных
- [update](https://docs.liquibase.com/change-types/update.html) для модификации данных
- [loadData](https://docs.liquibase.com/change-types/load-data.html) для вставки данных из `.CSV`
- [loadUpdateData](https://docs.liquibase.com/change-types/load-update-data.html) для вставки/изменения данных из `.CSV`
- либо можно использовать [sql](https://docs.liquibase.com/change-types/sql.html) для любой SQL-команды

## Процесс параллельной разработки 
с возможностью обновить состояние базы данных на своем (нужном) стенде.

##### Answer:

[local development](./../demo/README.md)

## Контролируемый откат миграций

##### Answer:

Для откатов существует комплекс команд и полей:    
- элемент [rollback](https://docs.liquibase.com/commands/rollback/rollback-by-tag.html) содержит SQL-код, который будет выполнен для выполнения отката миграции.
- набор команд [rollback-...](https://docs.liquibase.com/commands/home.html#database-rollback-commands). Эти команды непосредственно запускают процесс отката.


