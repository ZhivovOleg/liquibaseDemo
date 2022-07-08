-- liquibase formatted sql 
-- changeset zhivov_oa_sql:3
-- preconditions onFail:HALT onError:HALT
-- precondition-sql-check expectedResult:t SELECT EXISTS(SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'test_sql');
-- comment: /*available preconditions:  https://docs.liquibase.com/concepts/changelogs/preconditions.html?Highlight=precondition-sql-check#available-preconditions*/
ALTER TABLE test_sql
ADD COLUMN dateColumn DATE;