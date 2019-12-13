
-- �������� Ȱ��ȭ / ��Ȱ��ȭ
-- ALTER TABLE ���̺�� ENABLE OR DISABLE CONSTRAINT ��������


SELECT *
FROM USER_TABLES;

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name='DEPT_TEST'; --���̺��̸� �빮�� ����

ALTER TABLE dept_test DISABLE CONSTRAINT SYS_C007102;

SELECT *
FROM dept_test;

-- dept_test ���̺��� deptno �÷��� ����� primary key ����������
-- ��Ȱ��ȭ�Ͽ� ������ �μ���ȣ�� ���� �����͸� �Է��� �� �ִ�
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (99, 'DDIT', '����');


-- dept_test ���̺��� primary key �������� Ȱ��ȭ
-- �̹� ������ ������ �ΰ��� INSERT ������ ����
-- ���� �μ���ȣ�� ���� �����Ͱ� �����ϱ� ������ primary key ����������
-- Ȱ��ȭ �� �� ����. Ȱ��ȭ�Ϸ��� �ߺ������͸� �����ؾ��Ѵ�.

-- �������� Ȱ��ȭ
ALTER TABLE dept_test ENABLE CONSTRAINT SYS_C007102;

-- �ߺ� ������ �˻�
-- �ش� �����Ϳ� ���� ���� �� PRIMARY KEY ���������� Ȱ��ȭ �� �� ����
SELECT deptno, count(*)
FROM dept_test
GROUP BY deptno
HAVING COUNT(*) >=2;


-- �������� Ȯ��
SELECT *
FROM user_constraints
WHERE table_name = 'BUYER';

SELECT *
FROM user_cons_columns --�̰� ���� �ǹ���?
WHERE table_name='BUYER';

-- table_name, constraint_name, column name
-- postion asc
SELECT table_name, constraint_name, column_name
FROM user_cons_columns
WHERE table_name='BUYER'
ORDER BY POSITION;


-- ���̺� ���� ���� (�ּ�) VIEW
SELECT *
FROM user_tab_comments;

-- ���̺� �ּ�
-- COMMENT ON TABLE ���̺�� IS '�ּ�';
COMMENT ON TABLE dept IS '�μ�';

-- �÷� �ּ�
-- COMMENT ON COLUMN ���̺��, �÷��� IS '�ּ�';
COMMENT ON COLUMN dept.deptno IS '�μ���ȣ';
COMMENT ON COLUMN dept.dname IS '�μ���';
COMMENT ON COLUMN dept.loc IS '�μ���ġ����';

SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'DEPT';


--------- comment 1
SELECT a.table_name, table_type, a.comments tab_comment, 
       b.column_name, b.comments col_comment
FROM user_tab_comments a, user_col_comments b
WHERE a.table_name = b.table_name --������ �������̶� ������°ǰ�?
AND a.table_name IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY'); ---�빮�ھƤ����ƾƤ���
-- �ФФ� ��û ��̳�... �׷��� ������ �� ���� �� �� ��������! �����Ұ���!!!!


SELECT *
FROM user_col_comments;
SELECT *
FROM user_tab_comments;


-- VIEW : QUERY �̴� (O)
-- ���� ������ �� = QUERY
-- ���̺�ó�� �����Ͱ� ���������� �����ϴ� ���� �ƴϴ�.
-- VIEW : ���̺��̴� (X) (�������̺���)

-- VIEW ����
-- CREATE OR REPLACE VIEW ���̸� [(�÷���Ī1, �÷���Ī2...)] AS
-- SUBQUERY

-- empt ���̺��� sal, comm �÷��� ������ 
-- ������ 6�� �÷��� ��ȸ�� �Ǵ� view
-- v_emp �̸����� ����
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr hiredate, deptno
FROM emp;

-- �ٵ� �ȵ�! ��? insufficient privilage! ������ ����!
-- SYSTEM �������� VIEW�� �۾���. ���... �ý��� ������ ����
-- �Ʒ� ������ �ۼ�
GRANT CREATE VIEW TO PC20;
-- ���� v_emp �������� �ٽ� ����


-- view�� ������ ��ȸ
SELECT *
FROM emp;

-- INLINE VIEW ���·� ����
SELECT *
FROM (SELECT empno, ename, job, mgr hiredate, deptno
      FROM emp);
-- ��� ������ ���������� �� �����ؾ��� ��. ������ VIEW�� �ξ� Ȱ���� ����


-- EMP ���̺��� �����ϸ� VIEW�� ������ ������?
-- KING�� �μ���ȣ�� ���� 1-��
-- EMP ���̺��� KING �μ���ȣ �����͸� 30������ ���� (COMMIT���� ����)
-- v_emp ���̺��� king�� �μ���ȣ ����

UPDATE emp SET deptno=30 WHERE ename='KING';
SELECT * FROM emp WHERE ename = 'KING';
ROLLBACK;

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- emp ���̺��� king ������ ���� (commit ���� �� ��)
DELETE emp WHERE ename='KING';
SELECT * FROM EMP WHERE ENAME='KING';

-- emp ���̺��� KING ������ ���� �� v_emp_view�� ��ȸ ��� Ȯ��
SELECT *
FROM v_emp_dept;


ROLLBACK;


-- emp ���̺��� empno �÷��� eno�� �÷��̸� ����
ALTER TABLE emp RENAME COLUMN empno TO eno;
ALTER TABLE emp RENAME COLUMN eno TO empno;

SELECT *
FROM v_emp_dept; -- ���� ���̺��� �÷��� ��ȭ�� ����� ��� ������


-- view ����
-- v_emp ����
DROP VIEW v_emp;


-- �μ��� ������ �޿� �հ�
-- �� ��� ������
CREATE OR REPLACE VIEW v_emp_sal AS
SELECT deptno, SUM(sal) sum_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM v_emp_sal
WHERE deptno=20;



-- SEQUENCE
-- ����Ŭ ��ü�� �ߺ����� �ʴ� ���� ���� �������ִ� ��ü
-- CREATE SEQUENCE ��������
-- [�ɼ�...]

CREATE SEQUENCE seq_board; -- �� replace�� �ȵ���?
-- order?

-- ������ ����� : ��������.nextval
SELECT seq_board.nextval
FROM dual; --���� �ߺ��Ǵ� ���� �������� ����. 
-- isolation level�� �������? �̱��ϳ�. �޸𸮶� ��ũ �� ����ϼ̴��� ���� �𸣰ٴ� ��

SELECT seq_board.currval
FROM dual; 


ALTER SEQUENCE seq_board CACHE 10; 
--> ������ ��ȣ�� �� �ٲ�. �ٸ� �ɼǵ鸸 �ٲٴ°�...


--- index
SELECT ROWID, ROWNUM, EMP.*
FROM emp;


-- emp ���̺� empno �÷����� primary key ������� : pk_emp
-- dept ���̺� deptno �÷����� primary key ������� : pk_dept
-- emp ���̺��� deptno �÷��� dept ���̺��� deptno �÷��� �����ϵ���
-- FOREGITN KEY �����߰� : fk_dept_deptno

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT fk_dept_deptno FOREIGN KEY (deptno)
                                REFERENCES dept (deptno);

DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT *
FROM emp_test;

-- emp_test ���̺��� �ε����� ���� ����
-- ���ϴ� �����͸� ã�� ���ؼ��� ���̺��� �����͸� ��� �о���� �Ѵ�
EXPLAIN PLAN FOR
SELECT *
FROM emp_test
WHERE empno=7369;

SELECT *
FROM table(dbms_xplan.display);

------------------------------------------------------------------------------
| Id  | Operation         | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |          |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP_TEST |     1 |    87 |     3   (0)| 00:00:01 |
------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)



-- �����ȹ�� ���� 7369 ����� ���� �������� ��ȸ �ϱ����� 
-- ���̺��� ��� �����͸� ���� �� 7369�� �����͸� �����Ͽ�
-- ����ڿ��� ��ȯ
-- 13���� �����͸� ���ʿ��ϰ� ��ȸ �� ����

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7369;

SELECT *
FROM table(dbms_xplan.display);


-- �����ȹ�� ���� �м��� �ϸ�
-- empno�� 7369�� ������ index�� ���� �ſ� ������ ����
-- ���� ����Ǿ� �ִ� rowid ���� ���� table�� �����Ѵ�.
-- table���� ���� �����ʹ� 7369��� ������ �ѰǸ� ��ȸ�ϰ�
-- ������ 13�ǿ� ���ؼ��� ���� �ʰ� ó��

Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    87 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    87 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7369) -- access�� ����. ���� filter�� ���� ���� ��󳽰�.


--rowid�� �˸�...
SELECT *
FROM emp
WHERE rowid = '����� �� ���ڿ�';
-- �����ȹ�� ���� �ٷ� rowid�� ã�ư�















