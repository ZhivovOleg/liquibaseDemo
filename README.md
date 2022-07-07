# Liqubase

Инструкция по использованию [Liquibase](https://www.liquibase.org) в качестве инструмента миграций БД.

# Описание

Liquibase это консольный инструмент для выполнения миграций БД без привязки к сервисам/языкам программирования/фреймворкам.<br/>
Официальная документация: 
- https://www.liquibase.org
- https://docs.liquibase.com

# Настройка

Настройка осуществляется с помощью файла `liquibase.properties`, расположенного в рабочем каталоге, в котором вызывается `liquibase`. <br/>
Пример файла:
```ini
url:  jdbc:postgresql://localhost:5432/testdb
username:  wsl  
password:  wsl 
classpath:  postgresql-42.3.2.jar
databaseChangeLog: databaseChangeLog.xml
logFile: testdb.log
logLevel: INFO
```

Подробнее об установке и конфигурации в [этом разделе](./config.md).

# Миграции

Предусмотрено четыре формата миграций:

- SQL
- XML
- JSON
- YAML

При развитии проекта исторически сложилось так, что формат SQL самый скудный в плане функционала, а JSON/YAML самые полные.<br/>
Подробнее о миграциях и примеры [в этом разделе](./migrations/migrations.md).

# Применение

Изначально Liquibase разрабатывался Java-разработчиками для применения в Java среде. Соответственно, интеграции предусмотрены с инфраструктурой именно Java, например Maven. <br/>
Для всех остальных сред Liquibase используется либо в виде чистого CLI, либо в связке с Ansible.<br/>
Подробнее о шаблонах и roadmap внедрения и применения в [этом разделе](./using/using.md)

