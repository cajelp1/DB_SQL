

-- GROUPING SETS (col1, col2)
-- ������ ����� ����
-- �����ڰ� GROUP BY �� ������ ���� ����Ѵ�
-- ROLLUP�� �޸� ���⼺�� ���� �ʴ´�
-- GROUPING SETS(col1, col2) = GROUPING SETS (col2, col1)

-- GROUP BY COL1
-- UNION ALL
-- GROUP BY COL2

-- emp ���̺��� ������ job�� �޿�(sal)+��(comm)��,
--                 deptno�� �޿�(sal)+��(comm)�� ���ϱ�
-- �������(GROUPING FUNCTION) : 2���� SQL �ۼ� �ʿ� (union, union all)

SELECT job, NULL, SUM(sal+NVL(comm,0))
FROM emp
GROUP BY job
    UNION ALL
SELECT NULL, deptno, SUM(sal+NVL(comm,0))
FROM emp
GROUP BY deptno;


-- GROUPING SETS ������ �̿��Ͽ� ���� SQL�� ���տ����� ������� �ʰ�
-- ���̺��� �ѹ� �о ó��
SELECT job, deptno, SUM(sal+NVL(comm, 0)) SAL
FROM emp
GROUP BY GROUPING SETS (job, deptno);

SELECT job, deptno, SUM(sal+NVL(comm,0)) sal
FROM emp
GROUP BY grouping sets (deptno, job);


-- job, deptno�� �׷����� �� sal+comm ��
-- mgr�� �׷����� �� sal+comm ��
-- GROUP BY job, deptno
-- UNION ALL
-- GROUP BY mgr
-- --> GROUPING SETS ((job, deptno), mgr)

SELECT job, deptno, mgr, SUM(sal+NVL(comm,0)) SAL,
        GROUPING(job), GROUPING(deptno), GROUPING(mgr)
FROM emp
GROUP BY GROUPING SETS ((job, deptno), mgr);

-- ��.. KING�� �׳� null�� ������


/*
CUBE (col1, col2...)
- ������ �÷��� ��� ������ �������� GROUP BY subset�� �����
- CUBE�� ������ �÷��� 2���� ��� ������ ���� 4��
- CUBE�� ������ �÷��� 3���� ��� ������ ���� 8��
- CUBE�� ������ �÷����� 2�� ������ �� ����� ������ ��ȸ ������
- �÷��� ���ݸ� �������� ������ ������ ���ϱ޼������� �þ�� ������
  ���� ��������� �ʴ´�
*/

-- job, deptno �� cube ����
SELECT job, deptno, SUM(sal+NVL(comm,0)) sal
FROM emp
GROUP BY CUBE(job, deptno);
-- 1,1 GROUP BY job, deptno
-- 1,0 GROUP BY job
-- 0,1 GROUP BY deptno
-- 0,0 GROUP BY emp... ��� �࿡ ���� GROUP BY

-- GROUP BY ����
-- GROUP BY ROLLUP, CUBE�� ���� ����ϱ�
-- ������ ������ �����غ��� ����� ������ �� �ִ�
-- GROUP BY job, rollup(deptno), cube(mgr)

SELECT job, deptno, mgr, SUM(sal+NVL(comm, 0)) SAL
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

-- �������Ŀ���
SELECT job, sum(sal)
FROM emp
GROUP BY job, job; --�ߺ��� �����ϳ�


-- sub_a1
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER);

UPDATE dept_test SET empcnt=(
    SELECT count(*)
    FROM emp
    WHERE emp.deptno = dept_test.deptno
); --�̷��� NULL ���� ������? �ȳ����µ�

UPDATE dept_test SET empcnt=(
    SELECT count(deptno)
    FROM emp
    WHERE emp.deptno = dept_test.deptno
); -- �̷��� 0�� ������

SELECT *
FROM dept_test;


/*
COMMIT;
ROLLBACK;

DELETE FROM dept WHERE deptno=99;
SELECT *
FROM dept
WHERE deptno=99;
*/


-- sub_a2
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

INSERT INTO dept_test VALUES (99,'it1','daejeon');
INSERT INTO dept_test VALUES (98,'it2','daejeon');

SELECT *
FROM dept_test;
SELECT deptno
FROM emp
GROUP BY deptno;


DELETE FROM dept_test WHERE deptno NOT IN (
    SELECT deptno
    FROM emp
--    WHERE dept_test.deptno = emp.deptno
--    GROUP BY deptno
);


-- sub_a3
DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT *
FROM emp;
SELECT deptno, AVG(sal)
FROM emp
GROUP BY deptno;


UPDATE emp_test SET sal= sal+200
WHERE sal<(SELECT avg(sal)
           FROM emp
           WHERE deptno = emp_test.deptno);
--           GROUP BY deptno); �׷���� �Ƚᵵ �Ǵ°� �򰥷�...

SELECT *
FROM emp_test;

/* ������ʹ� �������� ��Ʈ �ֱ� ���� ����... �Ф�
UPDATE emp_test SET sal(
    SELECT sal+200
    FROM emp
    WHERE emp_test.sal < (SELECT avg(sal)
                          FROM emp
                          WHERE emp.deptno=emp_test.deptno
                          GROUP BY deptno)
);*/



ROLLBACK;

-- MERGE ������ �̿��� ������Ʈ
MERGE INTO emp_test a
USING (SELECT deptno, AVG(sal) sal FROM emp GROUP BY deptno) b
ON (a.deptno = b.deptno)
--    AND a.sal < b.sal) -- ������ ���. �ֳĸ� on���� ���ΰ� ������Ʈ �� �� ����
WHEN MATCHED THEN 
    UPDATE SET sal = sal+200
WHERE a.sal < b.sal -- �׷��� where���� �߰��� ���ش�
;-- �ƴ��� �� on�� ���õȰ� �� �˷��࿩�����þ� �Ѥ�


-- case ���� ���°�?
MERGE INTO emp_test a
USING (SELECT deptno, AVG(sal) sal FROM emp GROUP BY deptno) b
ON (a.deptno = b.deptno)
WHEN MATCHED THEN 
    UPDATE SET sal = case
                        WHEN a.sal < b.sal THEN sal+200
                        ELSE sal
                     END;

SELECT *
FROM emp_test;








