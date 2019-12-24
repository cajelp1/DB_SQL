

-- FOR LOOP���� ����� Ŀ�� ����ϱ�
-- �μ����̺��� ��� ���� �μ��̸�, ��ġ���� ������ ��� (CURSOR�̿�)
SET SERVEROUTPUT ON;

DECLARE
    --Ŀ�� ����
    CURSOR dept_cursor IS
        SELECT dname, loc
        FROM dept;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    FOR record_row IN dept_cursor LOOP --�ٸ� ������ for��
        DBMS_OUTPUT.PUT_LINE(record_row.dname||record_row.loc);
    END LOOP;
END;
/



-- Ŀ���� ���ڰ� ���� ���
DECLARE
    --Ŀ�� ����
    CURSOR dept_cursor(p_deptno dept.deptno%TYPE) IS
        SELECT dname, loc
        FROM dept
        WHERE deptno = p_deptno; 
        --������ ���ڸ� �����ؼ� ������������ ���� ��밡��
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    FOR record_row IN dept_cursor(10) LOOP --���⼭ ���� ���� �ִ´�
        DBMS_OUTPUT.PUT_LINE(record_row.dname||record_row.loc);
    END LOOP;
END;
/


-- FOR LOOP �ζ��� Ŀ��
-- FOR LOOP �������� Ŀ���� ���� ����!?

BEGIN
    FOR record_row IN (SELECT dname, loc FROM dept) LOOP 
    -- IN�ȿ� ���� Ŀ����?
    -- �� ��� declare������ �ʿ����
        DBMS_OUTPUT.PUT_LINE(record_row.dname||record_row.loc);
    END LOOP;
END;
/



--- �ǽ� pro3
SELECT *
FROM dt;
-- ��¥ ������ ����� ���غ���
/*
- �ڹٷ� �ѹ� �����ϸ�?
- ����Ʈ�� �� ����ִٸ�... for loop���� ������ �ش� ��+1�� �ִ�
  ���� �ش� �� ���� ���� �� ���� �� ��Ƽ� �÷��� �Ѵ�. 
  �׸��� ������-1 �� ������ ���!
*/


-- �ȴ��̤�����;;; �ٵ� �Ʒ��� procedure�� �ƴѵ���;;;;;;;;
-- ���� �°ŵ�... �̸��� ���� ��...
-- �� procedure �̸� ����
CREATE OR REPLACE PROCEDURE avgdt IS

    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY binary_integer;
    v_dt dt_tab; --���̺� �ο��� ���� �� ��� Ÿ���� ����� ������ �ְ�
    p number :=0;
    a number :=0;
BEGIN
    -- �� row�� ���� ������ ���� : into
    -- ���� row�� ���� ������ ���� : bulk (�������� ��´ٴ� �ǹ�) COLLECT INTO
    SELECT *
    BULK COLLECT INTO v_dt
    FROM dt;

    FOR i IN 2..v_dt.count LOOP
        a := v_dt(i-1).dt - v_dt(i).dt;
        p := p + a;
    END LOOP;
    p := p/(v_dt.count-1); --���� ������ ����� ���Ѵ�
    DBMS_OUTPUT.PUT_LINE(p);
END;
/


exec avgdt;


--- PL/SQL ���� �ٸ� ������δ�?
-- 1. ROWNUM���� �����ϱ� (1=2)
-- 2. �м��Լ�
SELECT LEAD(dt) OVER (ORDER BY DT) - dt
FROM dt;
-- �̷��� �� ���ߴٰ� ������ �Ǵµ� ������ �Լ� �� �Ŵ� �׷��Լ� �ȵǴϱ�
-- �ζ������� �ѹ� ��������
SELECT avg(sum_avg)
FROM
(SELECT LEAD(dt) OVER (ORDER BY DT) - dt sum_avg
FROM dt);

-- 3. �׸��� �ٸ� ����° �����? ����? ��������? �̰͵� ROWNUM�� ����ϳ�...
-- ��Ʈ.. ����...? ������.... 
-- �������� max�� min ���� count�� ��������������



-- �ǽ� pro4
-- cid, pid, dt, cnt
/*
������� 1�� ���� 100�� ��ǰ�� �����ϸ��� �Դ´ٸ�
 1, 100, 2, 1 --> 1, 100, 20191202, 1
              --> 1, 100, 20191209, 1
              --> 1, 100, 20191216, 1
              --> 1, 100, 20191223, 1
              --> 1, 100, 20191230, 1
*/

SELECT *
FROM daily; --�� ���̺� ���� ���� ������. 

-- �ϴ� �޷� �����?
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + LEVEL - 1
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD');
-- �Ф����� �� �� �ȵȴ�.. �� �˾Ѵ� �Ѥ� TO_CHAR... 
-- �ϴ� �������� �Ͻ� ��� ���� �غ���...

desc daily;


-- ���� �� �ش� ���� DAILY �����Ͱ� ������ �����϶�.. 
SELECT *
FROM daily
WHERE dt LIKE :YYYYMM||'%'; --��¥�� ������ Ÿ���̱� ������.


-- PRO 4
-- ���ͽ��� ���� �� �޷� �� ������� ���ͽ���
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) DT
      ,TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM')+(LEVEL-1), 'D') DAY
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD');



CREATE OR REPLACE PROCEDURE create_daily_sales(v_yyyymm IN VARCHAR2) is
    TYPE cal_row_type IS RECORD (dt VARCHAR2(8), day NUMBER);    -- ���̺� �ο�Ÿ��
    TYPE cal_tab IS TABLE OF cal_row_type INDEX BY BINARY_INTEGER; --���̺� Ÿ��
    v_cal_tab cal_tab;
BEGIN
    -- �����ϱ� �� �ش� ����� ������ ����
    DELETE daily
    WHERE dt LIKE v_yyyymm||'%';
    
    -- ���� Ŀ���� �޷� �ȿ� ������ ����Ŭ�� �ִ� ������ŭ ����ȴ�.. 
    -- �׷��� �ѹ��� �޷��� ����� �װ� �޸𸮿� �ø��� ������ ����...
    SELECT TO_CHAR(TO_DATE(v_yyyymm, 'YYYYMM') + (LEVEL-1),'YYYYMMDD') DT --DT�� ���ڷ� ����
      ,TO_NUMBER(TO_CHAR(TO_DATE(v_yyyymm, 'YYYYMM')+(LEVEL-1), 'D')) DAY --DAY�� ���ڷ� ����
    BULK COLLECT INTO v_cal_tab
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(v_yyyymm, 'YYYYMM')), 'DD');
    
    -- �����ֱ� ������ �д´�
    FOR daily IN (SELECT * FROM CYCLE) LOOP
        -- 12�� ���� �޷� : CYCLE ROW �Ǽ���ŭ �ݺ���...
        FOR i IN 1..v_cal_tab.count LOOP
            IF daily.day = v_cal_tab(i).day THEN
                --CID, PID, ����, ����
                INSERT INTO daily VALUES
                (daily.cid, daily.pid, v_cal_tab(i).dt, daily.cnt);
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(daily.cid||', '||daily.day);
    END LOOP;
    COMMIT;
END;
/

exec create_daily_sales('201911');



-- ������ ���� ȿ���� �׾߸��� �־�!!!!!!!!
-- �������� �ذ��غ���

SELECT cycle.cid, cycle.pid, cal.dt, cycle.cnt
FROM cycle, 
     (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL-1) dt
      ,TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM')+(LEVEL-1), 'D') day 
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))cal
WHERE cycle.day = cal.day
ORDER BY cid, pid, dt;








