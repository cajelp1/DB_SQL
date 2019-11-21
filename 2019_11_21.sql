
-- col IN (value1, value2...)
-- col�� ���� IN ������ �ȿ� ������ �� �߿� ���Ե� �� ������ ����. 


-- RDBMS .. ���հ���.
-- 1. ���տ��� ������ ����.
-- ( 1, 3, 5)�� (3, 5, 1)�� ��������.

-- 2. ���տ��� �ߺ��� ����. 
-- (1, 2, 3, 4, 4, 4)�� (1, 2, 3, 4)�� ��������

SELECT *
FROM emp
WHERE deptno IN (10, 20); 
-- emp ���̺� ������ �Ҽ� �μ��� 10 �̰ų�(OR) 20���� ���� ������ ��ȸ

DESC users;
SELECT userid ���̵�, usernm " �̸�", alias ����
FROM users;
--WHERE alias LIKE '(null)';


-- like ������ : ���ڿ� ��Ī ����
-- % : ���� ���� (���ڰ� ���� ���� �ִ�)
-- _ : �ϳ��� ����
-- LIKE 'S%' --S�� �����ϴ� ���� �˻�
-- LIKE '%T' --T�� ������ ���� �˻�
-- LIKE 'S____' --S�� �����ϴ� �ټ� ������ �ܾ� �˻�
-- LIKE '_____' --�ټ� ������ �ܾ� �˻�


--emp ���̺��� ��� �̸��� s�� �����ϴ� ��� ������ ��ȸ
SELECT *
FROM emp
WHERE ename LIKE 'S__T_';


DESC member;

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';


-- �÷� ���� NULL�� ������ ã��
-- emp ���̺� ���� MGR �÷��� NULL �� ������ ����

SELECT *
FROM emp
WHERE mgr IS NULL;
WHERE mgr = NULL;  --mgr ���� NULL�� ��� ���� ��ȸ..�ȶ��.
WHERE mgr = 7698;  --mgr ���� 7698�� ��� ���� ��ȸ


DESC emp;
SELECT *
FROM emp
WHERE comm IS NOT NULL;

UPDATE  emp SET comm = 0
WHERE empno=7844;

COMMIT;


-- AND : ������ ���ÿ� ����
-- OR : ������ �Ѱ��� �����ϸ� ����
SELECT *
FROM emp
WHERE mgr = 7698
AND sal > 1000;


-- emp ���̺��� mgr�� 7698�̰ų�(or), �޿��� 1000���� ū ���
SELECT *
FROM emp
WHERE mgr=7698
OR sal > 1000;



--emp ���̺��� ������ ����� 7698, 7839�� �ƴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);


SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL); --�̰� �ƿ� �� ���´�. 

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
OR mgr IS NULL;



-- EMP���� JOB = SALESMAN & �Ի糯¥ = 19810601

SELECT *
FROM emp
WHERE job = 'SALESMAN'
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');





