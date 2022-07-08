-- liquibase formatted sql 
-- preconditions onFail:HALT onError:HALT
-- changeset zhivov_oa_sql:1 dbms:postgresql labels:sql_create_table
-- comment: sql create table
CREATE TABLE test_sql (id INT PRIMARY KEY, name VARCHAR(255));
-- rollback drop TABLE test_sql;