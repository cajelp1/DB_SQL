

-- sub4

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

-- ������ ������ �ʴ� �μ��� ��ȸ�ϴ� ������ �ۼ��϶�

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno 
                     FROM emp );

SELECT *
FROM dept, emp
WHERE dept.deptno = emp.deptno(+)
AND emp.ename IS NULL;


-- SUB5
SELECT *
FROM product p
WHERE p.pid NOT IN (SELECT cycle.pid
                    FROM cycle, customer
                    WHERE cycle.cid = customer.cid 
                    AND cycle.cid =1);

SELECT *
FROM product p
WHERE p.pid NOT IN (SELECT pid
                    FROM cycle
                    WHERE cid =1);


-- SUB6
-- cid=2�� ���� �����ϴ� ��ǰ �� (cid=1�� ���� �����ϴ� ��ǰ��) �������� ��ȸ
select*
from
    (SELECT *
    FROM cycle
    WHERE cid=1)a
,
    (SELECT distinct pid
    FROM cycle
    WHERE cid =2)b
WHERE a.pid=b.pid;
-- �̰� �� �ι��� ����????
-- cross join �ϰ� �ű⼭ ������ ã�°Ŷ�!


SELECT *
FROM cycle c
WHERE cid=1 AND pid=(SELECT pid
                    FROM cycle cy
                    WHERE cy.cid=2 and c.pid = cy.pid);
-- �ƴ��� ��� ������ ����???


SELECT *
FROM cycle
WHERE cid=1 
AND pid in (SELECT pid
            FROM cycle
            WHERE cid =2);
-- �� ����... in �� ���� �Ǵ°ſ�����.....



-- sub7
SELECT *
FROM customer, product, cycle
WHERE cycle.cid = customer.cid
AND cycle.pid = product.pid
AND cycle.cid=1
AND cycle.pid in (SELECT pid
                  FROM cycle
                  WHERE cid =2);


--�Ŵ����� �����ϴ� ���� ���� ��ȸ
SELECT *
FROM emp e
WHERE EXISTS (SELECT 1 FROM emp m WHERE m.empno = e.mgr);


-- SUB8
-- null ����
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- �����ؼ� null�� �ִ� ���ֱ�
SELECT e.*
FROM emp e, emp m
WHERE e.mgr = m.empno;


--SUB9,10
SELECT *
FROM product
WHERE NOT EXISTS (SELECT pid FROM cycle 
                  WHERE (cid=1 and cycle.pid=product.pid));

SELECT *
FROM product
WHERE EXISTS (SELECT pid FROM cycle where cid=1 );


-- ���տ���
-- UNION : ������. �� ������ �ߺ����� �����Ѵ�
-- �������� SALESMAN�� ������ ������ȣ, �����̸� ��ȸ
-- ���Ʒ� ������� �����ϱ� ������ ������ ������ �ϰ� �� ���
-- �ߺ��Ǵ� �����ʹ� �ѹ��� ǥ���Ѵ�.

SELECT empno, ename
FROM emp
WHERE job='SALESMAN'

UNION

SELECT empno, ename
FROM emp
WHERE job='CLERK';


-- UNION ALL
-- ������ ����� �ߺ� ���Ÿ� ���� �ʴ´�
-- ���Ʒ� ��� ���� �ٿ� �ֱ⸸ �Ѵ�.

SELECT empno, ename
FROM emp
WHERE job='SALESMAN'

UNION ALL

SELECT empno, ename
FROM emp
WHERE job='SALESMAN';


-- ���տ���� ���ռ��� �÷��� ���� �ؾ��Ѵ�.
SELECT empno, ename, null
FROM emp
WHERE job='SALESMAN'

UNION

SELECT empno, ename, job
FROM emp
WHERE job='CLERK';


-- INTERSECT : ������
-- ����� �����͸� ��ȸ
SELECT empno, job --���� �� ������� �� ���̺��� �÷����� �ٴ´�
FROM emp
WHERE job='SALESMAN'

INTERSECT

SELECT empno, ename
FROM emp
WHERE job='SALESMAN';


-- MINUS
-- ������ : ��, �Ʒ� ������ �������� �� ���տ��� ������ ������ ��ȸ
-- �������� ��� ������, �����հ� �ٸ��� 
-- ������ ���� ������ ��� ���տ� ������ �ش�.


SELECT empno, ename
FROM
    (SELECT empno, ename
    FROM emp
    WHERE job IN('SALESMAN','CLERK')
    ORDER BY JOB)

UNION

SELECT empno, ename
FROM emp
WHERE job='CLERK'
ORDER BY 2; -- �� �÷����� �����ϸ� �������̰� �� ������??


-- OUTER JOIN�� ����


-- DML
-- INSERT : ���̺� ���ο� ������ �Է�


DELETE dept
WHERE deptno=99;

SELECT *
FROM dept;
commit;

-- INSERT �� �÷��� ������ ���
-- ������ �÷��� ���� �Է��� ���� ������ ������ ����Ѵ�
-- INSERT INTO ���̺�� (�÷�1, �÷�2...)
--             VALUES (��1, ��2...._
-- dept ���̺� 99�� �μ���ȣ, ddit ������, daejeon �������� ���� ������ �Է�
INSERT INTO dept (deptno, dname, loc)
                VALUES (99, 'ddit', 'daejeon');

-- �÷��� ����� ��� ���̺��� �÷� ���� ������ �ٸ��� �����ص� ����� ����
-- dept ���̺��� �÷� ���� : deptno, dname, location
INSERT INTO dept (loc, deptno, dname)
                VALUES ('daejeon', 99, 'ddit');
                
-- �÷��� ������� ���� ���, ���̺��� �÷� ���� ������ ���� ���� ����Ѵ�
DESC dept;
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

rollback;

SELECT *
FROM dept;



-- ��¥ �� �Է��ϱ�
-- 1. SYSDATE
-- 2. ����ڷκ��� ���� ���ڿ��� DATEŸ������ �����Ͽ� �Է�
DESC emp;
INSERT INTO emp VALUES (9998, 'sally', 'SALESMAN', 
                        NULL, SYSDATE, 500, NULL, NULL);

SELECT *
FROM emp;

-- 2019�� 12�� 2�� �Ի�
INSERT INTO emp VALUES (9997, 'james', 'CLERK', 
NULL, TO_DATE(20191202, 'YYYYMMDD'), 500, NULL, NULL);

ROLLBACK;


-- ���� ���� �����͸� �ѹ��� �Է�
-- SELECT ����� ���̺� �Է� �� �� �ִ�.
INSERT INTO emp
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 500, NULL, NULL
FROM dual
UNION ALL
SELECT 9997, 'james', 'CLERK', NULL, TO_DATE(20191202, 'YYYYMMDD')
,500, NULL, NULL
FROM dual;


