
-- emp ���̺��� �μ��� 10���� �ƴϰ� �Ի簡 1981�� 6��1�� ������ ����. 
-- IN, NOT IN ������


SELECT *
FROM emp
WHERE deptno != 10
AND hiredate >= TO_DATE('19810601', 'yyyymmdd');

SELECT *
FROM emp
WHERE deptno NOT IN(10)
AND hiredate >= TO_DATE('19810601', 'yyyymmdd');


SELECT *
FROM emp
WHERE JOB LIKE 'SALESMAN'
OR hiredate >= TO_DATE('19810601', 'yyyymmdd');


SELECT *
FROM emp
WHERE JOB = 'SALESMAN'
OR empno >= 7800 AND empno <7900;

-- ��������... 1. EMPNO�� ���ڿ��� �ȴ� / 2. ���ڰ� ���ڸ����� �Ѵ�.



-- �̸��� SMITH�̰ų� ALLEN �̸鼭 ������ SALESMAN

SELECT *
FROM emp
WHERE (ename = 'SMITH'
OR ename ='ALLEN') 
AND job = 'SALESMAN';


SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%'
AND hiredate > TO_DATE('19810601', 'YYYYMMDD');


/*
    SELECT ~, ~, ....
    FROM ���̺��
    WHERE coll = '��'
    ORDER BY ���ı����÷�1 [ASC / DESC], ���ı����÷�2 ... [ASC / DESC]
*/


-- emp ���̺��� ������ ���� �̸����� �������� ����

DESC emp;

SELECT *
FROM emp
ORDER BY ename DESC;


-- �μ���ȣ�� ��������, �μ���ȣ�� ������ sal ���� ��������
-- sal�� ������ �̸����� ��������

SELECT *
FROM emp
ORDER BY deptno, sal DESC, ename;


-- ���� �÷��� ALIAS�� ǥ��
SELECT deptno, sal, ename nm
FROM emp
ORDER BY nm;


-- ��ȸ�ϴ� �÷��� ��ġ �ε����� ǥ������
SELECT deptno, sal, ename nm
FROM emp
ORDER BY 3; 
-- ��õ���� ����. �÷� ������ �߰��ǰų� �����Ǹ� ���ı����� �ٲ�



-- DEPT �� �μ��̸����� ��������, �μ���ġ�� ��������

DESC dept;

SELECT *
FROM dept
ORDER BY dname, loc DESC;

SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm !=0
ORDER BY comm DESC, empno;


SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;


SELECT *
FROM emp
WHERE deptno IN(10, 30)
AND sal > 1500
ORDER BY ename DESC;



-- ROWNUM

SELECT ROWNUM, empno, ename
FROM emp;

--WHERE �������� ��� ����������
--WHERE ROWNUM = 1      <<���ٸ� ����� ���� 1�� ����
--WHERE ROWNUM < n      <<2���� ��밡��
--WHERER ROWNUM <= n    <<1���� ���������� ��ȸ�ϴ� ���� ����
--BETWEEN 1 AND 10      <<�׻� 1���� ����


SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 2 AND 20;


-- SELECT���� ORDER BY ������ �������
-- SELECT, �� �� ORDER BY. 
-- SELECT ���� ROWNUM�� �־��� ������ �� �Ŀ� ORDER BY �� ������ ROWNUM�� �ٲ��.
      
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;



-- INLINE VIEW�� ���� ���� ���� �����ϰ�, �ش� ����� ROWNUM�� ����
-- ()�� ������ �� �༮�� ���̺�� �ν���
-- * �� ǥ���ϰ� �ٸ� �÷� Ȥ�� ǥ������ ���� ���,
-- * �տ� ���̺���̳� ���̺��� ��Ī�� �����ؾ� ��.
-- ()�� �Ἥ ���� INLINE VIEW �ڿ� A�� ���̰�, �� ���� SELECT ���� A.*


SELECT ROWNUM, e.*
FROM emp e;


SELECT ROWNUM RN, empno, ename
FROM emp
WHERE ROWNUM <=10;


SELECT a.*
FROM   (SELECT ROWNUM RN, empno, ename
        FROM emp) A
WHERE RN BETWEEN 11 AND 14;


-- ROW3
-- EMP ���̺� ename���� �����ϰ� 11, 14�� ��ȸ�ض�

SELECT *
FROM
(SELECT ROWNUM RN, A.*
FROM   (SELECT empno, ename
        FROM emp
        ORDER BY ename)A)
WHERE RN BETWEEN 11 AND 14;



