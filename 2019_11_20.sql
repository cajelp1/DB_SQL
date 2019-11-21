--Ư�� ���̺��� �÷� ��ȸ
--1. DESC ���̺��
--2. SELECT * FROM user_tab_columns;

-- prod ���̺��� �÷���ȸ
DESC prod;--���� �� ������ ��? �κ���

--NOT NULL = ���� �� �� ����. ���� �ݵ�� ǥ���ؾ��ϴµ� �������.
--NOT NULL ���� ������� = ���� �� �־ ��.



-- �Ʒ��� ���� �߿���
VARCHAR2, CHAR --> ���ڿ� (Character).. �ٵ� character�� ���ڰ� sentence�� ���ڿ� �ƴ�?
NUMBER -->����. 
CLOB --> character Large OBject, ���ڿ� Ÿ���� ���� ������ ���ϴ� Ÿ��
        -- VERCHAR2 : 4000byte�� �Ѱ�.
        -- CLOB : �ִ� 4GB

DATE --> ��¥ ( �Ͻ� = ��,��,�� + �ð�, ��, �� )


--dateŸ�Կ� ���� ������ �����?

'2019/11/20 09:16:20' + 1 = ? 
-- ���α׷��� ����� ȸ�翡 ���� �ٸ�. �ƿ� ������ �ȵǴ� ���α׷��� ����. 
--����Ŭ������ ���ǵǾ�����.

--USER ���̺��� ��� �÷��� ��ȸ�϶�
DESC users;

-- userid, usernm, reg_dt ������ �÷��� ��ȸ
-- ������ ���� ���ο� �÷��� ���� (�޸� �ڿ� ���ο� �÷� �̸��� ���ش�.)
-- ���⼭�� reg_dt �� ���� ������ �� ���ο� ���� �÷�
-- ��¥ + ���� ���� = ���ڸ� ���� ��¥Ÿ���� ����� ���´�.
SELECT userid, usernm, reg_dt, reg_dt+5
FROM users;

-- �÷��� ��Ī�� �� �� �ִ�. ����� �ΰ���. �÷� �Ŀ� AS�� ���� ��Ī���� ���ش�.
SELECT userid, usernm, reg_dt, reg_dt+5 AS after5day
FROM users;

-- �ƴϸ� ���� �÷��� �����̽� ��ĭ ���� �̸�����.
SELECT userid, usernm, reg_dt reg_date, reg_dt+5 AS after5day
FROM users;

-- ��Ī : ���� �÷����̳� ������ ���� ������ ���� �÷��� ������ �÷��̸��� �ο�
--     col | express [AS] ��Ī��

-- ���� ���, ���ڿ� ��� (oracle : '', JAVA : '', "")
-- table�� ���� ���� ���Ƿ� �÷����� ���� (�Ϸ��� �ش� ���ڸ� ���ָ� ��.)

-- ���̺� �տ� 1�̶�� ������ �÷��� ����
-- DB SQL ���� �̶�� �÷��� ����
SELECT 1, 'DB SQL ����', userid, usernm, reg_dt
FROM users;

-- ��Ģ������ �ϴ� �÷��� ���� ����. (+, -, /, *)
-- ��Ģ���� �켱������ ������ ()�� ���� ������� ���� ����
SELECT (10-2)*2, 'DB SQL ����', userid, usernm, reg_dt
FROM users;

-- ���ڿ� ���� ����
SELECT (10-2)*2, 'DB SQL ����', userid + '_modified', usernm, reg_dt
FROM users;
-- �����ڵ� 01722��� ��. ��ȿ���� ���� ���ڴٶ�� ���.
-- ���ڿ��� ������ �������� �ʱ⶧��.
-- �׶��� || �� ����Ѵ�.

SELECT (10-2)*2, 'DB SQL ����', --(���� �ĸ��� ���ָ� usernm �Ʒ��� DB SQL ���� �̶�°� aliasó�� ��)
        /*userid + '_modified, ���ڿ����� ���ϱ� ������ ����'*/
        usernm || '_modified', reg_dt
FROM users;



--NULL : ���� �𸣴� ��
--NULL�� ���� ���� ����� �׻� NULL�̴�
--DESC ���̺�� : NOT NULL�� �����Ǿ��ִ� �÷����� ���� �ݵ�� ���� �Ѵ�.

--users���ʿ��� ������ ����
SELECT *
FROM users;

DELETE users
WHERE userid NOT IN ('brown', 'sally', 'cony', 'moon', 'james');

rollback; -- ctrl + z

commit; --�����Ϳ� ���� ������ Ȯ����

--����Ŭ�� Ű���忡 ���� ��ҹ��ڴ� �������� ������ ���� �����Ͱ������� �����Ѵ�.
--���⼭ brown�� BROWN�̶�� ���� brown�����ʹ� ��������.

SELECT userid, usernm, reg_dt
FROM users;
--NULL������ �����غ��� ���� moon�� reg_dt�÷��� null�� ����
UPDATE users SET reg_dt = NULL
WHERE userid = 'moon';

COMMIT;

--users ���̺��� reg_dt �÷����� 5���� ���� ���ο� �÷��� ����
--NULL���� ���� ������ ����� ���� NULL ���� Ȯ��. (���߿� �������� ������)
SELECT userid, usernm, reg_dt, reg_dt + 5
FROM users;



------------COLUMN ALIAS �ǽ�

--PROD���̺��� prod_id, prod_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��϶�
-- ��, prod_id -> id, prod_name -> name ���� �÷� ��Ī�� ����

SELECT prod_id AS id, prod_name name
FROM prod;

--lprod ���̺��� lprod_gu, lprod_nm �� �÷��� ��ȸ�϶�
--��, lprod_gu > gu, lpro_nm > nm���� �ٲ��

SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

--buyer ���̺��� buyer_id, buyer_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��϶�
--�� buyer_id > ���̾���̵�, buyer_name > �̸� ���� �÷� ��Ī�� �����϶�

SELECT buyer_id ���̾���̵�, buyer_name �̸�
FROM buyer;

---------------------

--���ڿ� �÷��� ����        (�÷� || �÷�, '���ڿ����' || �÷�, CONCAT(�÷�, �÷�))
SELECT userid, usernm, userid || usernm AS id_nm,
        CONCAT(userid, usernm) con_id_nm,
        -- ||�� �̿��ؼ� userid, usernm, pass ����
        userid || usernm || pass id_nm_pass,
        -- concat �� �̿��ؼ� userid, usernm, pass
        CONCAT(CONCAT(userid, usernm), pass) sadf
FROM users;


-- ����ڰ� ������ ���̺� ��� ��ȸ
SELECT table_name
FROM user_tables;


-- ���ڿ� ������ �̿��� ������ ���� ��ȸ�ǵ���~
SELECT 'SELECT * FROM '||table_name||';' query,
        --������ �Ѳ����� �ȴ�! �� �Ŀ� ���̺��� �̸� ���ϰ�
        --CONCAT �Լ��� �̿��ؼ� �����
        CONCAT(CONCAT('SELECT * FROM ', table_name), ';') query
FROM user_tables;



--WHERE : ������ ��ġ�ϴ� �ุ ��ȸȭ�� ���� ���
--          �࿡ ���� ��ȸ ������ �ۼ�
--where�� ������ �ش� ���̺��� ��� �࿡ ���� ��ȸ��
SELECT userid, usernm, alias, reg_dt
FROM users;

SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid = 'brown'; --userid �÷��� 'brown'�� ��(row)�� ��ȸ

SELECT *
FROM DBA_USERS;
--��������....



-- EMP ���̺��� ��ü ������ ��ȸ (��, ��... ROW, COLUNM)
SELECT *
FROM emp;

SELECT *
FROM dept;


--�μ���ȣ(deptno)�� 20���� ũ�ų� ���� �μ����� ���ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno >= 20;


--�����ȣ�� 7700���� ũ�ų� ���� ����� ���� ��ȸ
SELECT *
FROM emp
WHERE empno >= 7700;


-- TO_DATE �Լ�... ���ڿ��� ��¥ Ÿ������ ����. 
-- TO_DATE('��¥���ڿ�', '��¥���ڿ�format')
-- ��� �Ի����ڰ� 1982�� 1�� 1�� ������ ��� ���� ��ȸ
SELECT empno, ename, hiredate, 2000 no, '���ڿ����' str,
        TO_DATE('19820101', 'yyyymmdd')
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');


--������ȸ (BETWEEN ���۱��� AND �������)
--���۱���, ��������� ����!!!!!
--��� �� �޿�(SAL)�� 1000���� ũ�ų� ����, 2000���� �۰ų� ���� ��� ������ȸ
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;


-- BETWEEN AND �����ڴ� �ε�ȣ �����ڷ� �ٲ� �� �ִ�.
SELECT *
FROM emp
WHERE sal >= 1000
AND sal <= 2000;



--------------------
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('01/01/1982', 'dd/mm/yyyy')
AND hiredate <= TO_DATE('19830101', 'YYYYMMDD');

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'yyyymmdd')
AND hiredate <= TO_DATE('19830101', 'yyyymmdd');
-------------------------------


--------------------------------
SELECT *
FROM emp
WHERE deptno IN ( 10, 20, 30);

SELECT *
FROM emp
WHERE deptno = 10
OR deptno = 20;
---------------------------------





