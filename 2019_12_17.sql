
--WITH
--WITH ��� �̸� AS (
--   ��������
--)
--SELECT *
--FROM ����̸�

--deptno, avg(sal) avg_sal
--�ش� �μ��� �޿������ ���� ������ ��պ��� ���� �μ��� ���� ��ȸ
SELECT deptno, avg(sal) avg_sal
FROM emp
GROUP BY deptno
HAVING avg(sal)> (SELECT avg(sal) FROM emp); 
--AVG(sal) �� ���ϱ� ���� having���� �����....


-- WITH���� ����Ͽ� ���� ������ �ڼ�

WITH dept_sal_avg AS(
        SELECT deptno, avg(sal) avg_sal
        FROM emp
        GROUP BY deptno),
    emp_sal_avg AS(
        SELECT AVG(sal) avg_sal FROM emp)
SELECT *
FROM dept_sal_avg
WHERE avg.avg_sal > (SELECT avg_sal FROM emp_sal_avg);


WITH test AS(
    SELECT 1, 'TEST' FROM DUAL UNION ALL
    SELECT 2, 'TEST2' FROM DUAL UNION ALL
    SELECT 3, 'TEST3' FROM DUAL)
SELECT *
FROM test;


/*
��������(�޷¸����)

- connect by level <= n

- ���̺��� row �Ǽ��� n��ŭ �ݺ��Ѵ�
- connect by level ���� ����� ����������
- select ������ level�̶�� Ư���� �÷��� ����� �� �ִ�.
- ������ ǥ���ϴ� Ư�� �÷����� 1���� �����ϸ� rownum�� ����
- ���� ���� �� START WITH, CONNECT BY ������ �ٸ� ���� ������

*/

-- 2019�� 11���� 30�ϱ��� ������
-- ���� + ���� = ������ŭ �̷��� ����
-- �ش����� ��¥�� ���ϱ��� �����ϴ°�? ��� �� �� ����?
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + LEVEL -1 DT --LEVEL�� ���� ROWNUM���� ���ڰ� ����� �ϳ�...
FROM dual
CONNECT BY LEVEL <= 30;


-- ��¥�� ���������� �̾Ƴ��� ����
SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD') L_DAY
--        SYSDATE ADD_MONTHS
FROM DUAL;


-- ��ġ��
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1) DT
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD');


-- ���� ���� D�� �������
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1) DT,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1), 'd') D
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD');


-- �ζ��κ� + ��¥�� �����غ���
SELECT /*�Ͽ����̸� ��¥, ȭ�����̸鳯¥, ... ������̸鳯¥*/
        D,
        DECODE(d, 1, dt), DECODE(d, 2, dt), DECODE(d, 3, dt), 
        DECODE(d, 4, dt), DECODE(d, 5, dt), DECODE(d, 6, dt), 
        DECODE(d, 7, dt)
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1) DT,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1), 'd') D
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(
                        TO_DATE(:YYYYMM, 'YYYYMM')),'DD'))
;


-- ��¥�� ���غ���. 7���� ���� �ϳ��� ������ ���𰡰� �ʿ��ϴ�.
-- ����.. IW ! �ζ��κ信 �߰�������
-- ���� �׷�Į������ ��������. ��� ���ڵ忡 max�� �������ָ�!
SELECT /*dt, d,*/ IW,
        MAX(DECODE(d, 1, dt)) SUN, MAX(DECODE(d, 2, dt)) MON, 
        MAX(DECODE(d, 3, dt)) TUE, MAX(DECODE(d, 4, dt)) WED, 
        MAX(DECODE(d, 5, dt)) THU, MAX(DECODE(d, 6, dt)) FRI, 
        MAX(DECODE(d, 7, dt)) SAT 
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1) DT,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1), 'd') D,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1),'iw') IW
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(
                        TO_DATE(:YYYYMM, 'YYYYMM')),'DD'))
GROUP BY IW
ORDER BY IW
;


-- �ٵ� �غ��� �Ͽ����� �зȴ�.. IW�� �� �� �����Ϻ��� �����ؼ�.
-- �Ͽ��Ͽ� �ϳ��� �߰����ָ� �ȴ�. 
-- DEOCDE�� IW�� ������
-- �ƴϸ� �ζ��κ��� ������ �ٲٸ�? IW�� ������ -1 �ߴµ�
-- ���� ����� �Ϸ綯�ܼ� �ٸ� ��¥�� �������� ���°ɷ�! -1�� ������!
SELECT /*dt, d,*/ IW,
        MAX(DECODE(d, 1, dt)) SUN, MAX(DECODE(d, 2, dt)) MON, 
        MAX(DECODE(d, 3, dt)) TUE, MAX(DECODE(d, 4, dt)) WED, 
        MAX(DECODE(d, 5, dt)) THU, MAX(DECODE(d, 6, dt)) FRI, 
        MAX(DECODE(d, 7, dt)) SAT 
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1) DT,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1), 'd') D,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL),'iw') IW
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(
                        TO_DATE(:YYYYMM, 'YYYYMM')),'DD'))
GROUP BY IW
ORDER BY IW
;


-- 12���� ��¼��? ������� �������� IW�� ���� ������
-- ������ �ִ� 01�� ������ �������� �� �� ���� ���´�.
-- DECODE ����? ����.. �ȵȴ�. ������ �� ������.
SELECT  D, DD,
        DECODE(d, 1, dt), DECODE(d, 2, dt), DECODE(d, 3, dt), 
        DECODE(d, 4, dt), DECODE(d, 5, dt), DECODE(d, 6, dt), 
        DECODE(d, 7, dt)
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1) DT,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1), 'd') D,
           TRUNC(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1), 'D') DD
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(
                        TO_DATE(:YYYYMM, 'YYYYMM')),'DD'))
;
-- ��ģ... �̰� �����ѳ� ������......
SELECT /*dt, d,*/ 
        MIN(DECODE(d, 1, dt)) SUN, MIN(DECODE(d, 2, dt)) MON, 
        MIN(DECODE(d, 3, dt)) TUE, MIN(DECODE(d, 4, dt)) WED, 
        MIN(DECODE(d, 5, dt)) THU, MIN(DECODE(d, 6, dt)) FRI, 
        MIN(DECODE(d, 7, dt)) SAT 
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1) DT,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1), 'd') D,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL),'iw') IW
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(
                        TO_DATE(:YYYYMM, 'YYYYMM')),'DD'))
GROUP BY DT-(D-1)
ORDER BY DT-(D-1)
;
-- DT-(D-1)
-- ������ ������� ��������..



-- ���� �յ� ���� ��¥�� ��� ������ �ϰ�ʹٸ�?
SELECT /*dt, d,*/ 
        MIN(DECODE(d, 1, dt)) SUN, MIN(DECODE(d, 2, dt)) MON, 
        MIN(DECODE(d, 3, dt)) TUE, MIN(DECODE(d, 4, dt)) WED, 
        MIN(DECODE(d, 5, dt)) THU, MIN(DECODE(d, 6, dt)) FRI, 
        MIN(DECODE(d, 7, dt)) SAT 
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1 -
            (TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'D')-
            MOD(TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD'),7))
            ) DT,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1 -
           (TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'D')-
            MOD(TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD'),7))
           ), 'd') D
    FROM dual
    CONNECT BY LEVEL <= DECODE(TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD'),28,28,35)
                        )
GROUP BY DT-(D-1)
ORDER BY DT-(D-1)
;
--2026�� 2����? 2020�� 5����???

SELECT dd - mod7 D
FROM
(SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'D') dd,
        MOD(TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD'),7) mod7
FROM dual);
-- ���ĵ�������
-- (������ ���� ���Ϲ�ȣ - �޷��ϼ�%7)��ŭ�� ������ �� ���ָ� �׻� �Ͽ��Ϻ��� �޷��� ���۵ȴ�!
-- �ٵ� ���̳ʽ� ������ ���� ���?


--- �޷¸���� ����
SELECT 
       NVL(MIN(DECODE(MON, '01', SUM)),0) JAN
      ,NVL(MIN(DECODE(MON, '02', SUM)),0) FAB
      ,NVL(MIN(DECODE(MON, '03', SUM)),0) MAR
      ,NVL(MIN(DECODE(MON, '04', SUM)),0) APR
      ,NVL(MIN(DECODE(MON, '05', SUM)),0) MAY
      ,NVL(MIN(DECODE(MON, '06', SUM)),0) JUN
FROM 
    (SELECT SUM(SALES) SUM, TO_CHAR(DT,'MM') MON
    FROM sales
    GROUP BY TO_CHAR(DT,'MM')
    ORDER BY TO_CHAR(DT,'MM'));


SELECT dept_h.*, level
FROM DEPT_H
START WITH deptcd = 'dept0' -- �������� DEPTCD = DEPT0.. �� XXȸ��
CONNECT BY PRIOR deptcd = p_deptcd
;
/*
    dept0(XXȸ��)
        dept0_00(�����κ�)
            dept0_00_0(��������)
        dept0_01(������ȹ��)
            dept0_01_0(��ȹ��)
                dept0_01_0_0(��ȹ��Ʈ)
        dept0_02(�����ý��ۺ�)
            dept0_02_0(����1��)
            dept0_02_1(����2��)





