

-- emp ���̺�, dept ���̺� ����
EXPLAIN PLAN FOR
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno=10;

SELECT *
FROM TABLE (dbms_xplan.display);

Plan hash value: 615168685
 
---------------------------------------------------------------------------
| Id  | Operation          | Name | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |      |    14 |   588 |     7  (15)| 00:00:01 |
|*  1 |  HASH JOIN         |      |    14 |   588 |     7  (15)| 00:00:01 |
|   2 |   TABLE ACCESS FULL| DEPT |     4 |    88 |     3   (0)| 00:00:01 |
|   3 |   TABLE ACCESS FULL| EMP  |    14 |   280 |     3   (0)| 00:00:01 |
---------------------------------------------------------------------------
--�д� ������ 2-3-1-0
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
 
Note
-----
   - dynamic sampling used for this statement (level=2)



select ename, deptno
from emp;

SELECT deptno, dname
FROM dept;


--natural join : ���� ���̺� ���� Ÿ��, ���� �̸��� �÷�����
--               ���� ���� ���� ��� ����


DESC emp;
DESC dept;


-- ALTER TABLE emp DROP COLUMN dname;
-- dept�� emp�� ���� �̸��� �÷��� �ΰ� �����ϱ⿡ �ϴ� �ϳ��� ����


-- ANSI SQL
SELECT deptno, emp.empno, ename
FROM emp NATURAL JOIN dept;

SELECT deptno, a.empno, ename
FROM emp a NATURAL JOIN dept; --���̺� ��Ī ����

-- Oracle����
SELECT deptno, emp.empno, ename
FROM emp, dept;
WHERE emp.deptno = dept.deptno;

SELECT a.deptno, a.empno, ename
FROM emp a, dept b
WHERE a.deptno = b.deptno; --���⼭�� ���̺� ��Ī ����


-- JOIN USING
-- join�Ϸ��� �ϴ� ���̺� �� ������ �̸��� �÷��� �ΰ� �̻��� ��
-- join �÷��� �ϳ��� ����ϰ� ���� ��

-- ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno); -- ���� �� �÷��� ���� ǥ�õȴ�

-- Oracle SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno; --���⼭�� deptno�� �ι� ǥ�õȴ�.

SELECT *
FROM emp, dept; --ī�׼�?
-- WHERE 1=1; --���� ���̶�
--�̷��� �Ǹ� 4���� �� x 14���� ���� ���ؼ� ��� ����� ���� ����Ѵ�.



-- ANSI JOIN with ON
-- ���� �ϰ��� �ϴ� ���̺��� �÷� �̸��� �ٸ� ��
-- �����ڰ� ���� ������ ���� ������ ��



SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);


-- oracle
SELECT *
FROM emp, dept
WHERE emp.dptno = dept.deptno;


-- SELF JOIN : ���� ���̺� ����
-- emp ���̺� ���� �Ҹ��� ���� : ������ ������ ���� ��ȸ
-- ��������... ������ ������ �ش��ϴ°� �� ���̺��� �����ϴ� ��.?
SELECT *
FROM emp;



-- ������ ������ ������ ��ȸ
-- �����̸�, �������̸�
-- mgr �÷��� empno�� ��ĥ �� ������?
--ANSI
-- ���� �̸�, ������ ����� �̸�, ������ ������� ����� �̸�?
SELECT e.ename, m.ename p, m.empno pp
FROM emp e JOIN emp m ON (e.mgr = m.empno);
-- ����(=) ���꿡 ���յ��� �ʴ� �����ʹ� �����. King�� ������ 13�ุ ��ȸ
-- �׷� NULL�� �� ���°ž�? �Ѥ�


SELECT *
FROM emp;


--ORACLE
SELECT o, p, r.ename
FROM 
(SELECT e.ename o, m.ename p, m.mgr pp
FROM emp e, emp m
WHERE e.mgr = m.empno), emp r
WHERE pp = r.empno;


-- �����̸�, ������ ������ �̸�, ������ �������� ������ �̸�, �������� �������� ������ �̸�
SELECT e.ename, m.ename, r.ename, p.ename
FROM emp e, emp m, emp r, emp p
WHERE e.mgr = m.empno
AND m.mgr = r.empno
AND r.mgr = p.empno;


-- ���� ���̺��� ANSI JOIN�� �̿��� JOIN
SELECT e.ename, m.ename, r.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
           JOIN emp r ON(m.mgr = r.empno);



-- ������ �̸���, �ش� ������ ������ �̸��� ��ȸ�Ѵ�
-- ��, ������ ����� 7369~7698�� ������ ������� ��ȸ

SELECT o.empno, o.ename, t.ename
FROM emp o, emp t
WHERE o.mgr = t.empno
AND o.empno BETWEEN 7369 AND 7698;


-- ANSI
SELECT s.ename, m.ename
FROM emp s JOIN emp m ON(s.mgr = m.empno)
WHERE s.empno BETWEEN 7369 AND 7698;



-- NON-EQUIL JOIN : ���� ������ =(equal�� �ƴ� 
-- != , BETWEEN AND

SELECT *
FROM salgrade;


SELECT empno, ename, sal /* �޿� grade */
FROM emp;


SELECT empno, ename, sal, grade, losal, hisal
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;
-- ���� ������ �ƴϴ��� ������ �� �ִ� ����� ��. 

--ANSI��
SELECT empno, ename, sal, grade, losal, hisal
FROM emp JOIN salgrade ON( sal BETWEEN losal AND hisal);




------------------- �ǽ� join0

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY emp.deptno;

SELECT empno, ename, emp.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno);



----------------------- �ǽ� JOIN0_1

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno 
AND emp.deptno IN(10,30);


SELECT empno, ename, emp.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
AND emp.deptno IN (10,30);



----------------------- �ǽ� JOIN0_2
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno 
AND sal > 2500
ORDER BY emp.deptno;


SELECT empno, ename, sal, emp.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
AND sal > 2500;



------------------------------ �ǽ� 0_3
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno 
AND sal > 2500
AND empno>7600
ORDER BY emp.deptno;





---------------------------- �ǽ� 0_4
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno 
AND sal > 2500
AND empno>7600
AND dname = 'RESEARCH';





-------------------------------- �ǽ� JOIN1
SELECT prod_lgu
FROM prod;
SELECT lprod_gu
FROM lprod;

DESC prod;
DESC lprod;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM lprod, prod
WHERE lprod_gu = prod_lgu;



--------------------------------------------- �ǽ� join2
DESC buyer;
DESC prod;

SELECT buyer_id
FROM buyer;
SELECT prod_buyer
FROM prod;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE buyer_id = prod_buyer;





----------------------------------------- �ǽ� join3






