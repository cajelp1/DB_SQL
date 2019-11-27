---------------------------------- ���� �� ����
SELECT TRIM('d' FROM 'HELLO, WORLD') --trim�� �յڹۿ� ���ڸ��±���...
FROM dual;



---------------------------------- condition �ǽ� cond2

-- �ǰ����� ����� ��ȸ ����
-- 1. ���ذ� ¦������ Ȧ������
-- 2. hiredate���� �Ի�⵵�� ¦������ Ȧ������

---- **�������̸� �ڵ带 �ٲ��� �ʾƵ� �� �� �ִ� ���·�. SYSDATE�� ���� ������ �װ�.**

SELECT empno, ename, hiredate
      ,CASE
            WHEN MOD(TO_CHAR(hiredate,'YY'),2)=
                 MOD(TO_CHAR(SYSDATE, 'YY'),2)
            THEN '�ǰ����� �����'
            ELSE '�ǰ����� ������'
      END contact_to_doctor
FROM emp;


SELECT empno, ename, hiredate
      ,DECODE(MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YY')),2)
      ,MOD(TO_NUMBER(TO_CHAR(hiredate, 'YY')),2),'�ǰ����� �����'
      ,'�ǰ����� ������') contact_to_doctor
FROM emp;


--���⵵ �Ŵ�? (2020��)

SELECT empno, ename, hiredate
      ,DECODE(MOD(TO_CHAR(SYSDATE, 'YY')+1,2)
      ,MOD(TO_CHAR(hiredate, 'YY'),2),'�ǰ����� �����'
      ,'�ǰ����� ������') contact_to_doctor
FROM emp;

SELECT empno, ename, hiredate
      ,CASE
            WHEN MOD(TO_CHAR(hiredate,'YY'),2)=
                 MOD(TO_CHAR(SYSDATE, 'YY')+1,2)
            THEN '�ǰ����� �����'
            ELSE '�ǰ����� ������'
      END contact_to_doctor
FROM emp;


---- REG_DT�� ���� ����
DESC users;

SELECT userid, usernm, alias, reg_dt
      ,CASE
            WHEN MOD(TO_CHAR(reg_dt,'YY'),2)=
                 MOD(TO_CHAR(SYSDATE,'YY'),2)
            THEN '�ǰ����� �����'
            ELSE '�ǰ����� ������'
      END contact_to_doctor
FROM users
ORDER BY userid;

------------ cond3

SELECT a.userid, a.usernm, a.alias,
       MOD(a.yyyy,2),
       DECODE(MOD(a.yyyy,2),mod(a.this_yyyy,2),'�ǰ����� �����','�ǰ����� ������') con
FROM
    (SELECT userid, usernm, alias, TO_CHAR(reg_dt,'yyyy') yyyy,
            TO_CHAR(SYSDATE,'YYYY') THIS_yyyy
     FROM users) a;
------------- ���� �����ϰ� ��...�������� inline view�� �̿�.


-- �׷��Լ�. where�� �� �� �� �ִٴµ�... ����. � �������� ����?

-- Group Function
-- Ư�� �÷��̳� ǥ������ ���� ���� ���� �� ���� ����� ����
-- COUNT, SUM, AVG, MAX, MIN


-- ��ü ������ ������� 
-- 14���� 1���� ����

SELECT MAX(sal) max_s   --�� ������ ���� ���� �޿�
      ,MIN(sal) min_s   --�� ������ ���� ���� �޿�
      ,ROUND(AVG(sal),2) avg_s  --�� ������  �޿� ���
      ,SUM(sal) sum_s   -- �� ������ �޿� �հ�
      ,COUNT(sal) count_s   --�� ������ �޿� �Ǽ�. null�� �ƴ� ���̸� 1��.
      ,COUNT(mgr) count_m   --�� ������ ������ ������ �Ǽ�. KING�� PRES�� MGR�� ����.
      ,COUNT(*) count_row   --�� ������ Ư�� �÷��� �Ǽ��� �ƴ϶� ���� ������ �˰� ������
FROM emp;


-- �μ��� �׷� �Լ�
SELECT deptno, MAX(sal) max_s   -- �μ��� ���� ���� �޿�
      ,MIN(sal) min_s   -- �μ��� ���� ���� �޿�
      ,ROUND(AVG(sal),2) avg_s  -- �μ��� �޿� ���
      ,SUM(sal) sum_s   -- �μ��� �޿� �հ�
      ,COUNT(sal) count_sal   -- �μ��� �޿� �Ǽ�. null�� �ƴ� ���̸� 1��.
      ,COUNT(mgr) count_mgr   -- �μ��� ������ ������ �Ǽ�. KING�� PRES�� MGR�� ����.
      ,COUNT(*) count_row   -- �μ��� Ư�� �÷��� �Ǽ��� �ƴ϶� ���� ������ �˰� ������
FROM emp
GROUP BY deptno;
-- order by�� ���� ������ �տ� order by�� ���� �̸��� �־� �з��� �� �ִ�.


SELECT deptno, MAX(sal) max_s   -- �μ��� ���� ���� �޿�
      ,MIN(sal) min_s   -- �μ��� ���� ���� �޿�
      ,ROUND(AVG(sal),2) avg_s  -- �μ��� �޿� ���
      ,SUM(sal) sum_s   -- �μ��� �޿� �հ�
      ,COUNT(sal) count_sal   -- �μ��� �޿� �Ǽ�. null�� �ƴ� ���̸� 1��.
      ,COUNT(mgr) count_mgr   -- �μ��� ������ ������ �Ǽ�. KING�� PRES�� MGR�� ����.
      ,COUNT(*) count_row   -- �μ��� Ư�� �÷��� �Ǽ��� �ƴ϶� ���� ������ �˰� ������
FROM emp
GROUP BY deptno, ename;
-- ename�� �ߺ��Ǵ� �׸��� ���⶧���� 14���� ���� ��� �״�� ����


-- SELECT ������ GROUP BY ���� ǥ���� �÷� �̿��� �÷��� �� �� ����.
-- �������� ������ ���� ����. (�������� ���� ������ �� ���� �����ͷ� �׷���)
-- �� ���������� ��������� SELECT���� ǥ���� ����

SELECT deptno, '���ڿ�', SYSDATE
      ,MAX(sal) max_s   -- �μ��� ���� ���� �޿�
      ,MIN(sal) min_s   -- �μ��� ���� ���� �޿�
      ,ROUND(AVG(sal),2) avg_s  -- �μ��� �޿� ���
      ,SUM(sal) sum_s   -- �μ��� �޿� �հ�
      ,COUNT(sal) count_sal   -- �μ��� �޿� �Ǽ�. null�� �ƴ� ���̸� 1��.
      ,COUNT(mgr) count_mgr   -- �μ��� ������ ������ �Ǽ�. KING�� PRES�� MGR�� ����.
      ,COUNT(*) count_row   -- �μ��� Ư�� �÷��� �Ǽ��� �ƴ϶� ���� ������ �˰� ������
FROM emp
GROUP BY deptno;



-- �׷��Լ����� NULL �÷��� ��꿡�� ���ܵȴ�. ��� �ڷ�ĭ�� ���� ���������� �ʴ´�.
-- emp ���̺��� comm�÷��� NULL�� �ƴ� �����ʹ� 4���� ����. 9���� NULL.

SELECT COUNT(comm) count_comm
      ,SUM(comm) sum_comm
      ,SUM(sal+comm) tot_sal_sum -- ��ȣ �ȿ� �ִ� �� ���� ����ϴµ� null�� ����ֱ⿡ nulló����
      ,SUM(sal+ NVL(comm,0)) tot_sal_sum2
      ,SUM(sal)+SUM(comm) tot_sal_sum3
FROM emp;


-- WHERE ������ GROUP �Լ��� ǥ�� �� �� ����.
-- �μ��� �ִ� �޿� ���ϱ�
-- deptno, �ִ�޿�

SELECT deptno, MAX(sal) m_sal
FROM emp
--WHERE MAX(sal)>3000 --ORA-00934����. WHERE ������ GROUP �Լ��� �� �� ����.
HAVING MAX(sal)>=3000
GROUP BY deptno
ORDER BY m_sal desc;


-------------------- �ǽ� grp1,2
SELECT 
      MAX(sal) max_sal   -- �μ��� ���� ���� �޿�
      ,MIN(sal) min_sal   -- �μ��� ���� ���� �޿�
      ,ROUND(AVG(sal),2) avg_sal  -- �μ��� �޿� ���
      ,SUM(sal) sum_sal   -- �μ��� �޿� �հ�
      ,COUNT(sal) count_sal   -- �μ��� �޿� �Ǽ�. null�� �ƴ� ���̸� 1��.
      ,COUNT(mgr) count_mgr   -- �μ��� ������ ������ �Ǽ�. KING�� PRES�� MGR�� ����.
      ,COUNT(*) count_all   -- �μ��� Ư�� �÷��� �Ǽ��� �ƴ϶� ���� ������ �˰� ������
FROM emp;


--------------------------- �ǽ� grp3
SELECT CASE
       WHEN deptno=10 then 'ACCOUNTING'
       WHEN deptno=20 then 'RESEARCH'
       WHEN deptno=30 then 'SALES'
       END dname
       , max_sal, min_sal, avg_sal, count_sal, count_mgr, count_all
FROM(
SELECT deptno 
      ,MAX(sal) max_sal   -- �μ��� ���� ���� �޿�
      ,MIN(sal) min_sal   -- �μ��� ���� ���� �޿�
      ,ROUND(AVG(sal),2) avg_sal  -- �μ��� �޿� ���
      ,SUM(sal) sum_sal   -- �μ��� �޿� �հ�
      ,COUNT(sal) count_sal   -- �μ��� �޿� �Ǽ�. null�� �ƴ� ���̸� 1��.
      ,COUNT(mgr) count_mgr   -- �μ��� ������ ������ �Ǽ�. KING�� PRES�� MGR�� ����.
      ,COUNT(*) count_all   -- �μ��� Ư�� �÷��� �Ǽ��� �ƴ϶� ���� ������ �˰� ������
FROM emp
GROUP BY deptno )a
ORDER BY max_sal desc;


----------------------- �� ������!

SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') DNAME
      ,MAX(sal) max_sal   -- �μ��� ���� ���� �޿�
      ,MIN(sal) min_sal   -- �μ��� ���� ���� �޿�
      ,ROUND(AVG(sal),2) avg_sal  -- �μ��� �޿� ���
      ,SUM(sal) sum_sal   -- �μ��� �޿� �հ�
      ,COUNT(sal) count_sal   -- �μ��� �޿� �Ǽ�. null�� �ƴ� ���̸� 1��.
      ,COUNT(mgr) count_mgr   -- �μ��� ������ ������ �Ǽ�. KING�� PRES�� MGR�� ����.
      ,COUNT(*) count_all   -- �μ��� Ư�� �÷��� �Ǽ��� �ƴ϶� ���� ������ �˰� ������
FROM emp
GROUP BY deptno 
ORDER BY deptno;

--�ƴϸ� case�� �Ἥ?
SELECT case
       when deptno=10 then 'ACCOUNTING'
       when deptno=20 then 'RESEARCH'
       when deptno=30 then 'SALES'
       end DNAME
      ,MAX(sal) max_sal   -- �μ��� ���� ���� �޿�
      ,MIN(sal) min_sal   -- �μ��� ���� ���� �޿�
      ,ROUND(AVG(sal),2) avg_sal  -- �μ��� �޿� ���
      ,SUM(sal) sum_sal   -- �μ��� �޿� �հ�
      ,COUNT(sal) count_sal   -- �μ��� �޿� �Ǽ�. null�� �ƴ� ���̸� 1��.
      ,COUNT(mgr) count_mgr   -- �μ��� ������ ������ �Ǽ�. KING�� PRES�� MGR�� ����.
      ,COUNT(*) count_all   -- �μ��� Ư�� �÷��� �Ǽ��� �ƴ϶� ���� ������ �˰� ������
FROM emp
GROUP BY deptno 
ORDER BY deptno;



--------------- �Ի�⵵���� ����� �Ի��ߴ��� ��ȸ�ϴ� ����

SELECT TO_CHAR(hiredate, 'yyyymm') hiredate_yyyymm
      ,COUNT(TO_CHAR(hiredate, 'yyyymm')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm'); --�׷����� ���°� alias�� �ƴ϶� �׳� �״�� ���ٿ��� ������ �����ϱ���...

-- �׷����� �÷��� �ƴ϶� �����ε� �� �� �ִ�!!!!


---------------------------- �ǽ� grp5

SELECT TO_CHAR(hiredate, 'yyyy') hiredate_yyyy
      ,COUNT(TO_CHAR(hiredate, 'yyyy')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyy');

SELECT *
FROM dept;

SELECT COUNT(*) cnt
FROM dept; 
--�� ���߾ƾƤ��Ƥ��� emp�� ��� �Ť��ڳ����Ƥ�������



---------------------------- grp7

SELECT COUNT(*) cnt
FROM 
(SELECT deptno
FROM emp
GROUP BY deptno);

-- ������!
SELECT COUNT(COUNT(deptno)) cnt
FROM emp
GROUP BY deptno;


-- �ణ �ٸ� ��ɾ�.. distinct. �����϶�. �ߺ��� �����ϴ� ��.
SELECT COUNT(DISTINCT deptno) cnt
FROM emp;


-- join
-- 1. ���̺� ���� ���� (�÷� �߰�)
-- 2. �߰��� �÷��� ���� update
-- emp ���̺� dename�� �߰�

DESC emp;
DESC dept;

-- ��������.. �÷� �߰�. (dname, VARCHAR2 (14))
ALTER TABLE emp ADD (dname VARCHAR2(14));
-- ALTER TABLE emp DROP COLUMN dname;

UPDATE emp SET dname = CASE
                        WHEN deptno=10 then 'ACCOUNTING'
                        WHEN deptno=20 then 'RESEARCH'
                        WHEN deptno=30 then 'SALES'
                       END;

--WHERE �� �Ʒ� �߰��ؼ� ���� ������ �� ���� 

COMMIT;

SELECT*
FROM emp;


-- SALES --> MARKET SALES
-- �� 6���� ������ ������ �ʿ��ϴ�
-- ���� �ߺ��� �ִ� ���� (�� ������)
UPDATE emp SET dname = 'MARKET SALES'
WHERE dname = 'SALES'; --���� �ϼ���.. �ٲ��� ������...������



-- emp ���̺�, dept ���̺� ����
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;





