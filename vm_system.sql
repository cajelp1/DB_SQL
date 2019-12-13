
select *
from dba_data_files;


--table space ����
  CREATE TABLESPACE TS_DBSQL
   DATAFILE '/home/oracle/app/oracle/oradata/orcl/TS_DBSQL.dbf' 
   SIZE 100M 
   AUTOEXTEND ON;


--����� �߰�
create user PC20 identified by java
default tablespace TS_DBSQL
temporary tablespace temp
quota unlimited on TS_DBSQL
quota 0m on system;


--����, ��������
GRANT CONNECT, RESOURCE TO PC20;
