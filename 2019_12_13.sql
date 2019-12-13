

--MERGE

SELECT *
FROM emp_test
order by empno;

-- emp ���̺� �����ϴ� �����͸� emp_test ���̺�� merge
-- ���� empno�� ������ �����Ͱ� �����ϸ�
-- ename update : ename ||'merge'
-- ���� empno�� ������ �����Ͱ� �������� ���� ���
-- emp���̺��� empno, ename�� emp_test�� insert

-- emp_test ���̺� ������ ���� ����
DELETE emp_test
WHERE empno>= 7788;
commit;

-- emp ���̺��� 14�� ������ ����
-- emp_test ���̺��� ����� 7788���� ���� 7���� �����Ͱ� ����
-- emp���̺��� �̿��Ͽ� emp_test���̺��� merge�ϰԵǸ�
-- emp���̺��� �����ϴ� ���� (����� 7788���� ũ�ų� ����) 7��
-- emp_test�� ���Ӱ� insert�ǰ�
-- emp, emp_test�� �����ȣ�� �����ϰ� �����ϴ� 7����
-- ename||'modify'�� ������Ʈ�Ѵ�

/*
MERGE INTO ���̺��
USING ������� ���̺�/��/��������
ON ���̺��� ��������� �������
WHEN MATCHED THEN
    UPDATE ....
WHEN NOT MATCHED THEN
    INSERT ....
*/

MERGE INTO emp_test
USING emp
ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = ename||'_M' --modify ��� ���� 12�ڸ��� �Ѿ
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);

SELECT *
FROM emp_test;


-- emp_test ���̺� ����� 9999�� �����Ͱ� �����ϸ�
-- ename�� 'brown'���� update
-- �������� ���� ��� empno, ename VALUE (9999,'brown')���� insert
-- ���� �ó������� merge ������ Ȱ���Ͽ� �ѹ��� sql�� ����

MERGE INTO emp_test
USING dual
ON (emp_test.empno = :empno)
WHEN MATCHED THEN
    UPDATE SET ename = :ename || '_mod'
WHEN NOT MATCHED THEN
    INSERT VALUES (:empno, :ename);

/*
���� merge ������ ���ٸ�
1. empno = 9999 �� �����Ͱ� �����ϴ��� Ȯ��
2-1. 1�� ���׿��� �����Ͱ� �����ϸ� update
2-2. 1�� ���׿��� �����Ͱ� �������� ������ insert
*/


-- GROUP_AD1
    SELECT deptno, SUM(sal) sal
    FROM emp
    GROUP BY deptno
UNION
    SELECT NULL, SUM(sal) sal
    FROM emp;


-- JOIN �������?
-- emp ���̺��� 14���� �����͸� 28������ ����
-- ������(1-14)(2-14)�� �༭ group by

SELECT DECODE(b.rn, 1, a.deptno, 2, NULL) deptno,
        SUM(a.sal) sal 
FROM emp a,
    (SELECT rownum rn
    FROM dept
    WHERE ROWNUM <=2) b
GROUP BY DECODE(b.rn, 1, a.deptno, 2, NULL)
ORDER BY DECODE(b.rn, 1, a.deptno, 2, NULL);

SELECT DECODE(b.rn, 1, a.deptno, 2, NULL) deptno,
        SUM(a.sal) sal 
FROM emp a,
    (SELECT 1 rn FROM dual UNION    --�̺κ� �ٸ���
     SELECT 2 rn FROM dual) b       --�̺κ� �ٸ���
GROUP BY DECODE(b.rn, 1, a.deptno, 2, NULL)
ORDER BY DECODE(b.rn, 1, a.deptno, 2, NULL);


SELECT DECODE(b.rn, 1, a.deptno, 2, NULL) deptno,
        SUM(a.sal) sal 
FROM emp a,
    (SELECT LEVEL rn FROM dual  --�̺κ� �ٸ���
     CONNECT BY LEVEL <=2) b    --�̺κ� �ٸ���
GROUP BY DECODE(b.rn, 1, a.deptno, 2, NULL)
ORDER BY DECODE(b.rn, 1, a.deptno, 2, NULL);


-- REPORT GROUP BY
-- ROLLUP
-- GROUP BY ROLLUP(coll....)
-- ROLLUP ���� ����� �÷��� �����ʿ������� ���� �����
-- SUB GROUP�� �����Ͽ� �������� GROUP BY ���� �ϳ��� SQL����
-- ����ǵ��� �Ѵ�.
GROUP BY ROLLUP (job, deptno)
-- GROUP BY job, deptno
-- GROUP BY job
-- GROUP BY ---> ��ü ���� ������� GROUP BY


-- emp ���̺��� �̿��Ͽ� �μ���ȣ��, ��ü������ �޿����� ���ϴ� ������
-- ROLLUP ����� �̿��Ͽ� �ۼ�
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);

/*
emp ���̺��� �̿��Ͽ� job, deptno �� sal+comm �հ�
                    job�� sal+comm �հ�
                    ��ü������ sal+comm�հ�
rollup�� Ȱ���Ͽ� �ۼ�
*/

SELECT job, deptno, SUM(sal+NVL(comm, 0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);
-- *** ROLLUP �� �÷������� ��ȸ ����� ������ ��ģ��.
-- GROUP BY job, deptno
-- GROUP BY job
-- GROUP BY ---> ��ü ���� ������� GROUP BY


-- GROUP_AD2

SELECT NVL(job, '�Ѱ�'), deptno, SUM(sal+NVL(comm, 0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);

SELECT decode(grouping(job),0,job,1,'�Ѱ�') job, --���� �� ������!
--     decode(grouping(job),1,'�Ѱ�',job) --���ɾ��� ��
       deptno, SUM(sal+NVL(comm, 0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);


-- deptno null���� �ٲٷ���?
select decode(grouping(job),1,'�Ѱ�',job) job,
       decode(grouping(job)+grouping(deptno),2,'��',1,'�Ұ�',deptno) deptno,
        case
          when grouping(job)=1 then '��'
          when grouping(deptno)=1 then '�Ұ�'
          when grouping(deptno)=0 then to_char(deptno)
        end deptno,
        SUM(sal+NVL(comm, 0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);


-- ���� �����ϱ� �ٸ��� �ٲٸ�?
select  case
          when grouping(job)=1 then '�Ѱ�'
          when grouping(deptno)=1 then '�Ұ�'
          when grouping(job)=0 then job
        end job, deptno,
        SUM(sal+NVL(comm, 0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);


-- group_ad3

SELECT deptno, job, SUM(sal+NVL(comm, 0)) sal_sum
FROM emp
GROUP BY ROLLUP (deptno, job);


-- group_ad4

SELECT dname, job, SUM(sal+NVL(comm, 0)) sal_sum
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job)
ORDER BY dname, sal_sum desc;


-- group_ad5

SELECT DECODE(dname, null, '����', dname) dname,
       job, SUM(sal+NVL(comm, 0)) sal_sum
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job)
ORDER BY dname, sal_sum desc;


-- �������� group_ad4,5
SELECT NVL(dept.dname, '�Ѱ�') dname, a.job, a.sal_sum
FROM
    (SELECT deptno, job, SUM(sal+NVL(comm, 0)) sal_sum
    FROM emp
    GROUP BY ROLLUP (deptno, job)) A, dept
WHERE a.deptno = dept.deptno(+);

