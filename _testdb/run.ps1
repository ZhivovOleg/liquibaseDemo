Set-Location "C:\_testdb";
liquibase --changelog-file=simple_ChangeLog.xml update;
liquibase --changelog-file=preconditions_ChangeLog.yaml update;