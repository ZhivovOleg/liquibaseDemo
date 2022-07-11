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

Подробнее об установке и конфигурации в [примере](./demo/demo.md).

# Миграции

Предусмотрено четыре формата миграций:

- SQL
- XML
- JSON
- YAML

При развитии проекта исторически сложилось так, что формат SQL самый скудный в плане функционала, а XML/JSON/YAML самые полные.<br/>

# Применение

Изначально Liquibase разрабатывался Java-разработчиками для применения в Java среде. Соответственно, интеграции предусмотрены с инфраструктурой именно Java, например Maven. <br/>
Для всех остальных сред Liquibase со временем были разработаны свои [Workflow](https://docs.liquibase.com/workflows/liquibase-community/home.html) и в том числе образы `docker`, однако связка `CI/CD + CLI` остается самой удобной и гибкой.
