# Миграции

В документации миграции разделяются на 
- changeSet: непосредственно изменения БД (создание/удаление таблиц, столбцов, данных и т.п.), по аналогии с Git это `commit`
- deployment: набор changeSet'ов, которые могут быть совершенно не связаны между собой. Продолжая аналогию Git, это `merge` нескольких коммитов в `master`.

Миграции могут создаваться в 4 форматах файлов:

- [SQL](https://docs.liquibase.com/concepts/changelogs/sql-format.html)
- [XML](https://docs.liquibase.com/concepts/changelogs/xml-format.html)
- [JSON](https://docs.liquibase.com/concepts/changelogs/json-format.html)
- [YAML](https://docs.liquibase.com/concepts/changelogs/yaml-format.html)

//TODO: IN PROGRESS