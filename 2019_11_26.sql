






SELECT SYSDATE, LAST_DAY(SYSDATE)
FROM dual;


------ DATE �ǽ� FN3

SELECT '201912' PARAM --����� �����Ͱ� ���ڿ��� �÷�... �ٵ� ���̴� ���µ�?
      ,TO_CHAR(
       LAST_DAY(
       TO_DATE('201912','YYYYMM')),'DD')
       DT
FROM dual;

-- '201912' --> DATEŸ������ �����ϱ�
-- �ش� ��¥�� ��������¥�� �̵�
-- ���� �ʵ常 �����ϱ� <-- �̰� ���� �ع����� LAST_DAY ��ɾ ��¥�� �ν����� ����.


SELECT :YYYYMM PARAM --���ε� ����
      ,TO_CHAR(
       LAST_DAY(
       TO_DATE(:YYYYMM,'YYYYMM')),'DD')
       DT
FROM dual;

-- SYSDATE�� ���˺�ȯ
-- �ٽ� ��¥�� ��ȯ
SELECT TO_CHAR(
       TO_DATE(
       TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD'), 'YYYY-MM-DD HH24:MI:SS')
FROM DUAL;

-------------------------------- ���� �� ����
SELECT LENGTH('*')
FROM DUAL;

SELECT ROUND(TO_DATE('20190215','YYYYMMDD'),'MM')--?
FROM DUAL;
--------------------------------


-- EMPNO�� 7369�� ���� ���� ��ȸ �ϱ�
SELECT *
FROM emp
WHERE empno = TO_NUMBER('7369'); -- ���ڸ� ���ڷ�? �ƴ� ���ڸ� ���ڷ�?


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';


SELECT *
FROM TABLE(dbms_xplan.display);
-- �ڽĺ��� �д´�. ��.. ���� �Ҹ�����
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)
 
Note
-----
   - dynamic sampling used for this statement (level=2)


------------------------------------------

-- �̹��� ������ �÷��� ���ڿ��� �ٲ㼭 
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';


-- ���ϱ� ������ ������?
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300+'69';

SELECT *
FROM TABLE(dbms_xplan.display);

   1 - filter("EMPNO"=7369) --�����̶� ����ϰ� ��.


-------------------------------------

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/6/01','YYYY/MM/DD');

SELECT *
FROM emp
WHERE hiredate >= '81/6/01'; --�ڵ����� ����ȯ�� �Ǳ� ��..�µ�..

-- DATE Ÿ���� ������ ����ȯ�� ����� ������ ����. ���� �޶����� ǥ���� �޶���.



---------------------RR TEST
SELECT TO_DATE('50/05/05','RR/MM/DD')
      ,TO_DATE('49/05/05','RR/MM/DD')
      ,TO_DATE('50/05/05','YY/MM/DD')
      ,TO_DATE('49/05/05','YY/MM/DD')
FROM DUAL;



-- ���� --> ���ڿ�
-- ���ڿ� --> ����
--���� 1000000 --> 1,000,000.00 (�ѱ�)
--���� 1000000 --> 1.000.000,00 (����)
-- ��¥ ���� : YYYY
-- ���� ���� : ����ǥ�� : 9, �ڸ������� ���� 0ǥ�� : 0, ȭ����� : L
--            1000 �ڸ� ���� : , , �Ҽ��� : .
-- ���� -> ���ڿ� TO_CHAR(����, '����')


SELECT empno, ename, sal, TO_CHAR(sal,'9,999') fm_sal
FROM emp;

SELECT empno, ename, sal, TO_CHAR(sal,'009,999') fm_sal
FROM emp;

SELECT empno, ename, sal, TO_CHAR(sal,'L009,999') fm_sal
FROM emp;

-- ���� ������ ����� ���, �ڸ����� ����� ǥ�����־�� ��.
SELECT TO_CHAR(1000000, '9.999')
FROM dual; --������
SELECT TO_CHAR(1000000, '999,999,999.999')
FROM dual; --ǥ���


-- NULL ó���Լ� : NVL, NVL2, NULLIF, COALESCE

-- NVL(expr1, expr2) : �Լ� ���� �ΰ�
-- expr1�� NULL �̸� expr2�� ��ȯ
-- expr1�� NULL�� �ƴϸ� expr1�� ��ȯ
SELECT empno, ename, comm, NVL(comm, -1) nvl_comm
FROM emp;


-- NVL2(expr1, expr2, expr3)
-- expr1 IS NOT NULL --expr2 ����
-- expr1 IS NULL     --expr3 ����
SELECT empno, ename, comm, NVL2(comm, 1000, -500) nvl_comm
FROM emp;

SELECT empno, ename, comm, NVL2(comm, comm, -500) nvl_comm --NVL�� ������ ���
FROM emp;


-- NULLIF(expr1, expr2) <--NULL�� �ִ� �Լ�
-- expr1 = expr2    NULL�� ����
-- expr1 != expr2   expr1�� ����
SELECT empno, ename, comm, NULLIF(comm, comm+500) nullif_comm
FROM emp;
-- comm�� NULL�� �� comm+500 =NULL
--      NULLIF(NULL, NULL) : NULL
-- COMM�� NULL�� �ƴ� �� comm+500 = comm+500
--      NULLIF(COMM, COMM+500) : comm



-- COALESCE(expr1, expr2, expr3 ....)
-- ���� �߿� ù��°�� �����ϴ� NULL �� �ƴ� exprN�� ����
-- expr1 IS NOT NULL : expr1�� ����
-- expr1 IS NULL : COALESCE(expr2, expr3 ...)
SELECT empno, ename, sal, comm, COALESCE(comm, sal) coal_sal
FROM emp;


----------- NULL fn4
SELECT empno, ename, mgr
      ,NVL(mgr,9999) mgr_n
      ,NVL2(mgr, mgr, 9999) mgr_n_1
      ,COALESCE(mgr, 9999) mgr_n_2
FROM emp;

SELECT empno, mgr, comm, NVL(COALESCE(comm, mgr),0)
FROM emp;


-------------NULL fn5
SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) n_ger_dt
FROM users
WHERE userid NOT IN ('brown');




-- condition
-- case
-- emp.job �÷��� ��������
-- 'SALESMAN' �̸� sal * 1.05�� ������ �� ����
-- 'MANAGER' �̸� sal * 1.10 ����
-- 'PRESIDENT' �̸� SAL * 1.20 ����
-- �� ������ ������ �ƴ� ��� sal ����
-- empno, ename, job, sal, ���� ������ �޿� AS bonus
SELECT empno, ename, job, sal
      ,CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal
       END bonus
       ,comm,
--     comm�� NULL �� ��� -10�� �����ϵ��� ����
       CASE
            WHEN comm IS NULL THEN -10
            ELSE comm
       END case_null
FROM emp;



-- DECODE
SELECT empno, ename, job, sal,
      DECODE(job, 'SALESMAN',   sal*1.05,
                  'MANAGER',    sal*1.1,
                  'PRESIDENT',  sal*1.2,
                                sal) bonus
FROM emp;


-------------------------------------condition cond1, cond2

SELECT empno, ename 
      ,CASE
            WHEN deptno=10 THEN 'ACCOUNTING'
            WHEN deptno=20 THEN 'RESEARCH'
            WHEN deptno=30 THEN 'SALES'
            WHEN deptno=40 THEN 'OPERATIONS'
            ELSE 'DDIT'
      END DNAME 
FROM emp;





