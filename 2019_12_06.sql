
SELECT *
FROM dept;

-- dept ���̺� �μ���ȣ 99, �μ��� ddit, ��ġ daejeon

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;


-- UPDATE : ���̺� ����� �÷��� ���� ����
-- UPDATE ���̺�� SET �÷���1 = �����Ϸ��� �ϴ� ��1, �÷���2=���밪2...
-- [WHERE row ��ȸ ����]


-- �μ���ȣ�� 99���� �μ��� �μ����� ���IT��, ������ ���κ������� ����
UPDATE dept SET dname = '���IT', loc = '���κ���'
WHERE deptno = 99;

-- ������Ʈ ���� ������Ʈ �Ϸ��� �ϴ� ���̺��� WHERE���� ����� ��������
-- SELECT �� �Ͽ� ������Ʈ ��� ROW�� Ȯ���غ���
SELECT *
FROM dept
WHERE deptno = 99;


-- ���� QUERY�� �����ϸ� WHERE ���� ROW ���� ������ ���� ������ 
-- dept ���̺��� ��� �࿡ ���� �μ���, ��ġ ������ �����Ѵ�. 
UPDATE dept SET dname = '���IT', LOC = '���κ���';



-- SUBQUERY �� �̿��� UPDATE
-- emp ���̺� �ű� ������ �Է�
-- �����ȣ 9999, ����̸� BROWN, ���� NULL
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');
SELECT *
FROM emp;
commit;


-- �����ȣ�� 9999�� ����� �Ҽ� �μ��� �������� SMITH ����� �μ�, ������ ������Ʈ
UPDATE emp SET deptno=(SELECT deptno FROM emp WHERE ename='SMITH'),
               job=(SELECT job FROM emp WHERE ename='SMITH')
WHERE empno=9999;
rollback;

SELECT *
FROM emp
WHERE empno = 9999;


-- DELETE : ���ǿ� �ش��ϴ� ROW�� ����
-- �÷��� ���� ����? NULL�� ����? --> UPDATE�� ����϶�.
-- DELETE�� �߿��� ���� ROW!!!!!!!!!!!!!! �� �����Ѵٴ� ��.

-- DELETE ���̺�� [WHERE ����]

-- UPDATE������ ���������� DELETE ���� ���������� 
-- �ش� ���̺��� WHERE������ �����ϰ� �Ͽ� SELECT�� ����.
-- ������ ROW�� ���� Ȯ���غ���.

-- emp ���̺� �����ϴ� �����ȣ 9999�� ����� ���� 
DELETE emp
WHERE empno=9999;
COMMIT;

SELECT *
FROM emp
WHERE empno = 9999;


-- �Ŵ����� 7698 empno �� ��� ��� ����
SELECT *
FROM emp
WHERE mgr = 7698;

--DELETE *
--WHERE mgr = 7698;?

DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);
ROLLBACK;


-- �б� �ϰ��� (ISOLATION LEVEL)
-- LOCK�� ����.
-- DML���� �ٸ� ����ڿ��� ��� ������ ��ġ���� ������ ����(0~3)

-- LV0
-- COMMIT �� �� �����͵� �ٸ� Ʈ�����ǿ��� ����
-- ORACLE���� ���� ���

-- LV1
-- COMMIT �� �����͸� �ٸ� Ʈ�����ǿ��� ����

-- LV2
-- ���� ������ LOCK. 
-- �ٸ� Ʈ�����ǿ��� ������ ���ϱ� ������ �� Ʈ�����ǿ��� �ش� ROW��
-- �׻� ������ ��������� ��ȸ �� �� �ִ�.
-- (�ٵ� INSERT�� �ǳ�....)
-- ORACLE���� �������� ������ FOR UPDATE ������ ���� ����? ȿ���� �� �� �ִ�.

-- LV3
-- SERIALIZABLE READ
-- Ʈ�������� ������ ��ȸ ������ Ʈ������ ���� �������� ��������. 
-- ���� Ʈ�����ǿ��� �����͸� �ű� �Է�, ����, ���� �� COMMIT�ص�
-- ���� Ʈ�����ǿ����� �ش� �����͸� ���� �ʴ´�. 


-- Ʈ������ ���� ���� (serializable read)
-- SET TRANSACTION isolation LEVEL serializable;


-- DML? DDL? DCL? TCL?


-- DDL : TABLE ����
-- CREATE TABLE [����ڸ�.] ���̺��(
--        �÷���1 �÷�Ÿ��1, 
--        �÷���2 �÷�Ÿ��2, ...
--        �÷���N �÷�Ÿ��N);

-- ���̺� ���� DDL : Data Defination Language (������ ���Ǿ�)
-- DDL �� rollback�� ����. (�ڵ�Ŀ�� �ǹǷ� rollback�� �� �� ����.)
CREATE TABLE ranger(
    ranger_no NUMBER,               --������ ��ȣ
    ranger_nm VARCHAR2(50),         --������ �̸�
    reg_dt DATE default SYSDATE     --������ �������
);


SELECT *
FROM user_tables
WHERE table_name = 'RANGER'; 
-- ����Ŭ������ ��ü ������ �ҹ��ڷ� �����ϴ���
-- ���������δ� �빮�ڷ� �����Ѵ�



INSERT INTO ranger VALUES(1,'brown', sysdate);
SELECT *
FROM ranger;

-- DML���� DDL�� �ٸ��� ROLLBACK�� �����ϴ�


DESC emp;


-- DATE Ÿ�Կ��� �ʵ� ��������
-- EXTRACT (�ʵ�� FROM �÷�/expression)
SELECT TO_CHAR(sysdate,'YYYY')      -- ��� ���ڿ�
      ,EXTRACT(year FROM SYSDATE)   -- ��� ����
FROM dual;


-- ��������
-- NOT NULL, UNIQUE(NULL�� ������ ���� ����), PRIMARY KEY...


CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

SELECT *
FROM dept_test;
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);


-- dept_test ���̺��� deptno �÷��� PRIMARY KEY ���������� �ֱ� ������
-- deptno�� ������ �����͸� �Է��ϰų� ������ �� ����. 
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon'); --�Է¼���
INSERT INTO dept_test VALUES(99, '���', '����'); --�Է½���. 99�� �̹� ����.
-- ORA-00001: unique constraint (PC20.SYS_C007092) violated
-- SYS_C007092 ��� �̸��� �˾ƺ��� ����� ������ 
-- �������ǿ� �ڟ޷��� ���� �̸��� ���̴°� ���������� ����.


-- ���̺� ���� �� �������� �� ����
-- PRIMARY KEY : pk_���̺��
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(99, '���', '����');
-- ORA-00001: unique constraint (PC20.PK_DEPT_TEST) violated
-- ���������� �̸��� �޶���








