

-- OUTER join : join ���ῡ �����ϴ��� ������ �Ǵ� ���̺��� �����ʹ� ��������?
-- LEFT OUTER JOIN : ���̺�1 LEFT OUTER JOIN ���̺�2
-- ���̺�1�� ���̺�2�� ������ �� ���ο� �����ϴ��� ���̺�1 ���� �����ʹ� ��ȸ �ǵ���.

-- ���ο� ������ ��ROW���� ���̺�2�� �÷����� �������� �����Ƿ� NULL�� ǥ�õȴ�.


-- ANSI
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
     ON (e.mgr = m.empno AND m.deptno=10);

SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
     ON (e.mgr = m.empno)
WHERE m.depno=10;


-- ORACLE outer join syntax
-- �Ϲ� ���ΰ� �������� �÷��� (+) ǥ��.
-- �����Ͱ� �������� �ʴµ� ���;��ϴ� �÷��� (+) ǥ��.
-- ���� LEFT OUTER JOIN �Ŵ���
-- ON (����.�Ŵ�����ȣ = �Ŵ���.������ȣ)


-- ORACLE OUTER
-- WHERE ����.�Ŵ�����ȣ = �Ŵ���.������ȣ(+) -- �Ŵ����� �����Ͱ� �������� ����.
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e , emp m
WHERE e.mgr = m.empno(+);


--�Ŵ��� �μ���ȣ ����
-- ANSI SQL WHERE ���� ����� ����
-- --> OUTER JOIN�� ������� ���� ��Ȳ
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e , emp m
WHERE e.mgr = m.empno(+) 
AND m.deptno=10;


-- �ƿ��� ������ ����Ǿ�� �ϴ� ���̺��� ��� �÷��� (+)�� �پ�� �Ѵ�.
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e , emp m
WHERE e.mgr = m.empno(+) 
AND m.deptno(+)=10;


EXPLAIN PLAN FOR
-- emp ���̺��� 14���� ������ �ְ� 10,20,30 �μ� �� �� �μ��� ���Ѵ�.
-- ������ dept���̺��� 10, 20, 30, 40 �� ����
-- �μ���ȣ, �μ���, �ش�μ��� ���� �������� �������� ������ �ۼ�
SELECT dept.deptno, dept.dname, COUNT(emp.deptno)--�� NULL�� 0���� �ٲ�?
FROM dept LEFT OUTER JOIN emp ON (dept.deptno = emp.deptno)
GROUP BY dept.deptno, dept.dname
ORDER BY dept.deptno;

SELECT *
FROM TABLE (dbms_xplan.display);



-- ORACLE�� �ۼ�
SELECT dept.deptno, dept.dname, COUNT(emp.deptno) --����� + �� �ٿ��� �ǳ�? �L��
FROM dept, emp
WHERE dept.deptno = emp.deptno(+)
GROUP BY dept.deptno, dept.dname
ORDER BY dept.deptno;


-- �����԰� �Բ� �ǽ�
SELECT dept.deptno, dname, NVL(cnt,0)
FROM dept,
    (SELECT deptno, count(*) cnt
     FROM emp
     GROUP BY deptno)emp_cnt
WHERE dept.deptno = emp_cnt.deptno(+);

SELECT dept.deptno, dname, NVL(cnt,0)
FROM dept LEFT OUTER JOIN 
    (SELECT deptno, count(*) cnt
     FROM emp
     GROUP BY deptno)emp_cnt
ON (dept.deptno = emp_cnt.deptno);


-- RIGHT OUTER JOIN
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m
     ON (e.mgr = m.empno);


-- FULL OUTER : LEFT OUTER + RIGHT OUTER - �ߺ������� �� �Ǹ� �����
SELECT *
FROM BUYPROD
WHERE buy_date=TO_DATE('050125','YYMMDD');


-- OUTERJOIN 1
SELECT buy_date, buy_prod, prod.prod_id, prod_name, buy_qty
FROM PROD LEFT OUTER JOIN BUYPROD 
     ON (prod.prod_id = buyprod.buy_prod AND buy_date=TO_DATE('050125','YYMMDD'));


-- OUTERJOIN 2
SELECT NVL(buy_date,TO_DATE('050125','YYMMDD')) buy_date
     , buy_prod, prod.prod_id, prod_name, buy_qty
FROM PROD LEFT OUTER JOIN BUYPROD 
     ON (prod.prod_id = buyprod.buy_prod AND buy_date=TO_DATE('050125','YYMMDD'));


-- OUTERJOIN 3
SELECT NVL(buy_date,TO_DATE('050125','YYMMDD')) buy_date
     , buy_prod, prod.prod_id, prod_name
     , NVL(buy_qty,0)
FROM PROD LEFT OUTER JOIN BUYPROD 
     ON (prod.prod_id = buyprod.buy_prod AND buy_date=TO_DATE('050125','YYMMDD'));


-- OUTERJOIN 4
SELECT *
FROM cycle;
SELECT *
FROM product;

SELECT product.pid, pnm
     , NVL(cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt 
FROM product LEFT OUTER JOIN
    (SELECT *
     FROM cycle
     WHERE CID = 1) one ON (product.pid = one.pid);


-- OUTERJOIN 5
SELECT product.pid, pnm
     , NVL(cid,1) cid, NVL(cnm, 'brown') cnm
     , NVL(day,0) day, NVL(cnt,0) cnt 
FROM product LEFT OUTER JOIN
(SELECT cycle.cid, cnm, pid, day, cnt
FROM cycle, customer
WHERE cycle.cid = customer.cid AND cycle.cid = 1) one
ON (product.pid = one.pid)
ORDER BY pid DESC, day DESC;


-- nvl(brown) ����?
SELECT two.pid, pnm, customer.cid, cnm, day, cnt
FROM customer join 
    (SELECT product.pid, pnm
     , NVL(cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt 
     FROM product LEFT OUTER JOIN
        (SELECT *
         FROM cycle
         WHERE CID = 1) one ON (product.pid = one.pid)) two
     ON (two.cid = customer.cid)
ORDER BY pid DESC, day DESC;


---- ��� ī�׼� ����. ũ�ν� ����
SELECT p.pid pid ,p.PNM pnm,NVL(c.cid,1) cid ,cu.CNM CNM,NVL(c.day,0) day ,NVL(c.cnt,0) cnt
FROM     CUSTOMER cu,CYCLE c RIGHT OUTER JOIN PRODUCT p
ON  (c.PID=p.PID AND c.CID=1)
WHERE cu.CNM='brown';


