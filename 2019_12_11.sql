
-- INDEX�� ��ȸ�Ͽ� ������� �䱸���׿� �����ϴ� 
-- �����͸� ����� �� �� �ִ� ���

EXPLAIN PLAN FOR 
SELECT *
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE (dbms_xplan.display);



-- empno �÷��� ��ȸ�ϸ�?
EXPLAIN PLAN FOR 
SELECT empno
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE (dbms_xplan.display);


-- ���� �ε��� ����
-- pk_emp �������� ���� -> unique���� -> pk_emp �ε��� ����
ALTER TABLE emp DROP CONSTRAINT pk_emp;

-- INDEX ���� (�÷��ߺ�����)
-- UNIQUE INDEX : �ε��� �÷��� ���� �ߺ��� �� ���� �ε���
-- e.g.(emp.empno, dept.deptno)
-- NON-UNIQUE INDEX(dafault) : �ε��� �÷� ���� �ߺ��� �� �ִ� �ε��� 
-- e.g.(emp.job)


-- CREATE UNIQUE INDEX idx_n_emp_01 ON emp (empno); �̷� �ߺ��ȵ�
CREATE INDEX idx_n_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7782;

SELECT*
FROM TABLE(dbms_xplan.display);
-- �ε����� �ٲ�� INDEX RANGE SCAN �̶�� ������ �ٲ�


--7782�� �߰��Ǹ�?
INSERT INTO emp (empno, ename) VALUES (7782, 'brown');
COMMIT;


-- emp ���̺� job�÷����� non-unique �ε��� ����
-- �ε����� : idx_n_emp_02
CREATE INDEX idx_n_emp_02 ON emp (job);

SELECT job, rowid
FROM emp
ORDER BY job;


-- emp ���̺��� �ε����� 2�� ������
-- 1. empno
-- 2. job
-- ���ٹ���� �뷫 5����...? ��. �׳� �÷��� ��ȸ�ϸ� �ε����� ���� ������?

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

-- **PPT84 predicate!!!

-- ����̸��� c ������ ���� �߰�
SELECT *
FROM emp
WHERE job='MANAGER'
AND ename LIKE 'C%'; --> �̰͵� ��ҹ��� ������


-- idx_n_emp_03
-- emp ���̺��� job, ename �÷����� non-unique �ε��� ����
CREATE INDEX idx_n_emp_03 ON emp (job, ename);
                   --���⼭ (job, ename)�̶� (ename, job) �ٸ��� 


-- idx_n_emp_04
CREATE INDEX idx_n_emp_04 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER'
AND ename LIKE 'J%';

SELECT *
FROM TABLE(dbms_xplan.display);


-- JOIN ���������� �ε���
-- emp ���̺��� empno �÷����� primary key ���������� ����
-- dept ���̺��� deptno �÷����� primary key ���������� ����
-- emp ���̺��� primary key ������ ������ �����̹Ƿ� �����
-DELETE emp
WHERE ename = 'brown';
COMMIT;

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
SELECT *
FROM emp;

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);


Plan hash value: 3070176698

----------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |     1 |    63 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |              |       |       |            |          |
|   2 |   NESTED LOOPS                |              |     1 |    63 |     2   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    33 |     1   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     0   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN          | PK_DEPT      |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT         |   409 | 12270 |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")


DROP TABLE dept_test;

-- IDX1
CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1=1;

CREATE UNIQUE INDEX u_deptno ON dept_test (deptno);
CREATE INDEX un_dname ON dept_test(dname);
CREATE INDEX un_deptno_dname ON dept_test (deptno, dname);

DROP INDEX u_deptno;
DROP INDEX un_dname;
DROP INDEX un_deptno_dname;


-- idx3
CREATE INDEX u_emp_deptno ON emp (deptno);

-- idx4
-- emp.deptno
-- dept.deptno









