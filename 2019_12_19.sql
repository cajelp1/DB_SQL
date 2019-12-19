

-- �޷�...  
-- �������� �ߴ� ��ó�� CONNECT BY ���� �������ְ�
-- �׷���� ������ MOD((LEVEL-1)/7) �� ���ָ� ���ָ��� 0�� ���´�.



-- �м��Լ� / window�Լ�
-- ����Ŭ�� �ణ ������ ���...?
-- window�Լ��� ���� ����. �����ؼ��� �� ���� ���� ����...


-- ����� �μ��� �޿�(sal)�� ���� ���ϱ�
-- ���̰� �ú��ϱⰡ ����? ������ �߰��Ϸ���... ����....
SELECT ename, sal, deptno, level
FROM emp
START WITH sal IN (SELECT MAX(SAL) FROM EMP GROUP BY DEPTNO)
CONNECT BY sal < PRIOR sal and deptno = PRIOR deptno
ORDER SIBLINGS BY DEPTNO;
--ORDER SIBLINGS BY NVL(parent_seq, seq) DESC;

SELECT ename, sal, deptno (SELECT ROWNUM
                           FROM dual, emp
                           WHERE 
FROM emp
ORDER BY deptno, sal DESC;


-- 1. ���� 1���� 14���� ī�����ϴ� �÷��� �����
SELECT ROWNUM
FROM emp;
-- 2. �� �μ��� ��������� ������ �ϴ� �÷��� �� ����
SELECT COUNT(deptno)
FROM emp
GROUP BY deptno
ORDER BY deptno;
-- 3. �� �÷��� ī�׼� �����ϸ� 14���� �÷��� ��������...!
SELECT *
FROM (SELECT ROWNUM A
      FROM emp)
JOIN
     (SELECT COUNT(deptno) B
     FROM emp
     GROUP BY deptno
     ORDER BY deptno)
ON;

-- �� �ƴѰ�...
SELECT *
FROM (SELECT ROWNUM A
      FROM emp),
     (SELECT deptno, COUNT(deptno) B
     FROM emp
     GROUP BY deptno
     ORDER BY deptno)
WHERE a <= b
ORDER BY deptno, a; -- deptno�� �־�� ���⼭ order by�� �� �� �ִ�..


-- ���⿡ ROWNUM�� �������� EMP���̺�� ��ģ��...
SELECT *
FROM
   (SELECT ename, sal, deptno, ROWNUM j_rn
    FROM
        (SELECT ename, sal, deptno
        FROM emp
        ORDER BY deptno, sal DESC)) AA,
   (SELECT A, ROWNUM j_rn
    FROM
        (SELECT *
         FROM (SELECT ROWNUM A
               FROM emp),
              (SELECT deptno, COUNT(deptno) B
              FROM emp
              GROUP BY deptno
              ORDER BY deptno)
         WHERE a <= b
         ORDER BY deptno, a)) BB
WHERE AA.j_rn = BB.j_rn
;


-- ��ģ.. ���� ��ħ �Ѥ�

SELECT a.ename, a.sal, a.deptno, b.rn
FROM 
(SELECT ename, sal, deptno, ROWNUM j_rn
    FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC)) a,

(SELECT rn, ROWNUM j_rn
FROM
    (SELECT b.*, a.rn
    FROM 
    (SELECT ROWNUM rn
     FROM dual
     CONNECT BY level <= (SELECT COUNT(*) FROM emp)) a,
    
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) b
    WHERE b.cnt >= a.rn
    ORDER BY b.deptno, a.rn )) b
WHERE a.j_rn = b.j_rn;



-- ���� ���� �м��Լ��� �Ẹ��
SELECT ename, sal, deptno, 
        RANK() OVER (PARTITION BY deptno ORDER BY sal) rank
FROM emp;
-- ��Ƽ���� partition by null�� �Ǵ±���!



-- DENSE RANK, ROW NUM
-- RANK : ���� ���� ���� ���� �ο�. 1���� 2���� ��� �� ���� ���� 3
-- DENSE_RANK : ���� ���� ���� ���� �ο�, 1���� 2���� ��� �� ���� ���� 2
-- ROW_NUMBER :  ���� ���� ���� ���� �ο�
SELECT ename, sal, deptno, 
        RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) dense_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) row_rank
FROM emp;


-- �ǽ� ana1
-- ��� ��ü �޿�����, �ٸ� �޿��� �����ϸ� ����� ���� ����� �켱����
SELECT empno, ename, sal, deptno, 
       RANK() OVER (ORDER BY SAL desc, empno) sal_rank,
       DENSE_RANK() OVER (ORDER BY sal desc, empno) dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal desc, empno) row_rank
FROM emp;


-- �ǽ� no_ana2
-- ��� ����� ���� �����ȣ, ����̸�, �ش� ����� ���� �μ� ������� ��ȸ
-- �м��Լ� �� ����~
SELECT empno, ename, sal, deptno, 
       COUNT() OVER (PARTITION BY deptno) sal_rank
FROM emp;

-- 1. ī���� �ϴ� ������ ����� 
SELECT deptno, count(deptno)
FROM emp
GROUP BY deptno;
-- 2. �ο�����ŭ ������ ���ϱ�
SELECT empno, ename, a.deptno, cnt 
FROM (SELECT empno, ename, deptno
      FROM emp) a,
    (SELECT deptno, count(deptno) cnt
     FROM emp
     GROUP BY deptno) b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;
-- ���� ���̺� ���ϱ�.. �� �ʿ���� A���� �ΰ��÷� �߰�


-- �ٵ� �̰� ������ emp ���̺� cnt�� ���� �߰��ؼ� �����ϴ°Ŷ� �Ȱ��� ����?
-- �ζ��� �並 ���ֹ�����
SELECT empno, ename, a.deptno, cnt 
FROM emp a,
    (SELECT deptno, count(deptno) cnt
     FROM emp
     GROUP BY deptno) b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;


-- �����ȣ, ����̸�, �μ���ȣ, �μ��� ������
SELECT empno, ename, deptno, 
--      COUNT(*) OVER (PARTITION BY deptno) cnt --�Ʒ��� �������
        COUNT(deptno) OVER (PARTITION BY deptno) cnt
FROM emp;


-- ana2
-- window �Լ��� �̿��ؼ� ��� ����� �����ȣ, ����̸�, ���α޿�, �μ���ȣ,
-- �ش� ����� ���� �μ��� ���(����� �Ҽ� ��°����)
SELECT empno, ename, sal, deptno,
        ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg
FROM emp;


-- ana3
-- window �Լ��� �̿��ؼ� ��� ����� �����ȣ, ����̸�, ���α޿�, �μ���ȣ,
-- �ش� ����� ���� �μ��� ���� ���� �޿� ��ȸ
SELECT empno, ename, sal, deptno,
        MAX(sal) OVER (PARTITION BY deptno) MAX_SAL
FROM emp;


-- ana4
-- window �Լ��� �̿��ؼ� ��� ����� �����ȣ, ����̸�, ���α޿�, �μ���ȣ,
-- �ش� ����� ���� �μ��� ���� ���� �޿� ��ȸ
SELECT empno, ename, sal, deptno,
        MIN(sal) OVER (PARTITION BY deptno) MIN_SAL
FROM emp;


-- �ǽ� ana5
-- ��ü ����� ������� �޿������� �ڽź��� �Ѵܰ� ���� ����� �޿�
-- �޿��� �������� �Ի����ڰ� ���� ����� ���� ����
SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate; --�������� Ȯ��

SELECT empno, ename, hiredate, sal,
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate) l_sal
FROM emp;


-- �ǽ� 6
SELECT empno, ename, hiredate, job, sal,
        LAG(SAL) OVER (PARTITION BY job ORDER BY sal, hiredate) d
FROM emp;
-- ������... LAG�� LEAD ����� ������ ���� �ҰųĿ� ���� �޶�����. 
-- �� �����غ���!


-- �̰Թ��� no_ana3
SELECT SUM(b) c_sum
FROM (SELECT rownum rn, sal a FROM emp ORDER BY sal) a
     (SELECT rownum rn, sal b FROM emp ORDER BY sal) b
WHERE a.rn >= b.rn
GROUP BY a.rn
ORDER BY a.rn;


-- ���̰�... a.rn >= b.rn ... �� �ε�ȣ��!!!! �� ã�Ƽ�!!!!! �ФФФ�

SELECT empno, ename, sal, c_sum
FROM
    (SELECT AA.*, ROWNUM rnn FROM
        (SELECT empno, ename, sal
        FROM emp ORDER BY sal) aa) CC,
    (SELECT BB.*, ROWNUM rnn FROM
        (SELECT SUM(b) c_sum
        FROM (SELECT aa.*, ROWNUM rn FROM
             (SELECT sal a FROM emp ORDER BY sal) aa) a,
             (SELECT bb.*, ROWNUM rn FROM
             (SELECT sal b FROM emp ORDER BY sal) bb) b
        WHERE a.rn >= b.rn
        GROUP BY a.rn
        ORDER BY a.rn) bb) DD
WHERE cc.rnn = dd.rnn;


-- SUM�ϰ� ������������ �����̶� SUM�� �ѹ��� �ض�
SELECT empno, ename, b.a, SUM(c.b)
FROM
    (SELECT aa.*, ROWNUM rn FROM
        (SELECT empno, ename, sal FROM emp
         ORDER BY sal, empno) aa) a,
    (SELECT bb.*, ROWNUM rn FROM
         (SELECT sal a FROM emp 
          ORDER BY sal, empno) bb) b,
    (SELECT cc.*, ROWNUM rn FROM
         (SELECT sal b FROM emp 
          ORDER BY sal, empno) cc) c
WHERE b.rn >= c.rn AND a.rn = b.rn
GROUP BY b.rn, empno, ename, b.a
ORDER BY b.rn;


-- �����Ѱ�
SELECT DECODE(sal
FROM
(SELECT ROWNUM rn, sal
FROM emp
ORDER BY sal)
CONNECT BY level = (SELECT Count(empno) FROM emp);





