-- ����

SELECT *
FROM (SELECT ROWNUM rn, A.*
      FROM   (SELECT empno, ename
              FROM emp
              ORDER BY ename) A)
WHERE RN BETWEEN 11 AND 20;



-- heLlO, wOrLd!
-- dual ���̺� : sys  ������ ������ ������ ��밡��
-- �����ʹ� �� �ุ �����ϰ� �÷��� �ϳ�. �÷� �̸��� x.

SELECT *
FROM dual;



-- SINGLE ROW FUNCTION ��� �ѹ��� FUNCTION ����
-- 1���� �� INPUT -> 1���� �� OUTPUT

SELECT LOWER('heLlO, wOrLd!'), UPPER('heLlO, wOrLd!'), 
INITCAP('heLlO, wOrLd!')
FROM dual;


--DUAL ���̺��� �����Ͱ� �ϳ��� �����Ѵ�. �����͵� �ϳ��� ������ ���´�. 
--emp ���̺��� 14���� �����Ͱ� ����. (14���� ��).
--      ��� �Ʒ� ����� 14���� ������ ����
SELECT emp.*, LOWER('heLlO, wOrLd!') low, 
        UPPER('heLlO, wOrLd!') upp, 
        INITCAP('heLlO, wOrLd!')
FROM emp;


-- lower, upper, initcap�� ��� ������ ����� ���� ��ҹ��ڷ� �ٲ㺸�̱⿡
-- WHERE �̳� LIKE ���� �� ���� �Էµ� ������ �״�θ� �ľ��Ѵ�.
SELECT empno, INITCAP(ename)
FROM emp
WHERE LOWER(ename) = 'smith'; --����Ҷ��� ���� ������.


SELECT CONCAT(CONCAT('HELLO',', '),'WORLD') CCAT,
        'HELLO'||', '||'WORLD' ASDF,
        SUBSTR('HELLO, WORLD', 1, 4) SUB, -- SUBSTR(���ڿ�, �����ε���, �����ε���)
-- �����ε����� 1����, �����ε��� ���ڿ����� �����Ѵ�.


-- INSTR : ���ڿ����� Ư�� ���ڿ��� �����ϴ���, ������ ��� ������ �ε����� ����
        INSTR('HELLO, WORLD', 'O') i1, -- 5, 9
        INSTR('HELLO, WORLD', 'O', 6) i2, -- ���ڿ��� Ư�� �ε��� ���ĺ��� �˻��ϵ��� �ɼ�
        INSTR('HELLO, WORLD', 'O', INSTR('HELLO, WORLD', 'O')+1) i3, -- 9��°�� ã�� �� �ִ� �ٸ� �ɼ�
        
        LPAD('HELLO, WORLD', 15, '*')L1,
        LPAD('HELLO, WORLD', 15 )L1, -- DEFAULT ä���ڴ� ����
        RPAD('HELLO, WORLD', 15, '*')R1,

-- L/RPAD Ư�� ���ڿ��� ��/���� �ʿ� ������ ���ڿ� ���̺��� �����Ѹ�ŭ ���ڿ��� ä���ִ´�.

-- REPLACE(����ڿ�, �˻����ڿ�, �����ҹ��ڿ�)
-- ����ڿ����� �˻� ���ڿ��� ������ ���ڿ��� ġȯ
        REPLACE ('HELLO, WORLD', 'HELLO', 'hello') rep1,
        
-- ���ڿ� �� �� ���� ����
        '    hello world    ' before_trim1,
        TRIM ('    hello world    ') after_trim1,
--        LTRIM ('hello world', 'h') after_trim2
        TRIM ('h' from '    hello, world     ') after_trim2 -- �� ��� ������ ������� ����

FROM dual;


-- ���� �����Լ�
-- ROUND : �ݿø�  ROUND(����, �ݿø��ڸ�)
-- TRUNC : ����   TRUNC(����, �����ڸ�)
-- MOD : ������ ���� MOD(������, ����) // MOD(5,2) : 1


SELECT --�ݿø� ����� �Ҽ��� 1�ڸ����� ����. �Ҽ��� ��°�ڸ����� �ݿø�.
        ROUND(105.54, 1) r1,
        ROUND(105.55, 1) r2,
        ROUND(105.55, 0) r3,
        ROUND(105.55, -1) r4
FROM dual;


SELECT --���� ����� �Ҽ��� 1�ڸ����� ����. �Ҽ��� ��°�ڸ����� �ݿø�.
        TRUNC(105.54, 1) t1,
        TRUNC(105.55, 1) t2,
        TRUNC(105.55, 0) t3,
        TRUNC(105.55, -1) t4
FROM dual;


-- MOD : �������� ������ ���� ������ ��
-- MOD(M, 2)�� ��� ���� : 0, 1(0~����1-) 
SELECT MOD(5, 2) 
FROM dual;


-- emp ���̺��� sal �÷��� 1000���� ������ �� ����� ������ ��
--�� ��ȸ�ϴ� sql �ۼ�. 
-- ename, sla, sal/1000�� ��, sal/1000�� ������
SELECT ename, sal, 
        TRUNC(sal/1000) "SAL/1000", --������ ��Ÿ���� �������� ��������
        MOD(SAL, 1000) REMAINDER,
        TRUNC(sal/1000)*1000 + MOD(SAL, 1000) SAL2
FROM emp;



SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS')
FROM emp;


-- SYSDATE : ���� ��¥, �ð������� DATE Ÿ������ ��ȯ
-- SYSDATE : ������ ���� DATE�� �����ϴ� �����Լ�, Ư���� ���ڰ� ����.
-- DATE ���� : DATE + ���� : N�ϸ�ŭ ���Ѵ�
-- DATE ���꿡�� ������ ����.
-- �Ϸ�� 24�ð��̱⿡ �ð��� ���� ���� �ִ�. 1�ð� = 1/24

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS  ') DATEs,
        TO_CHAR(SYSDATE + 5/24/60, 'YYYY-MM-DD HH:MI:SS  ') hours
FROM dual;


SELECT TO_CHAR(TO_DATE('2019-12-31', 'YYYY-MM-DD  '), 'YYYY-MM-DD') LASTDAY,
        TO_DATE('2019-12-31', 'YYYY-MM-DD  ')-5 LASTDAY_BEFORE,
        TO_CHAR(SYSDATE, 'YYYY-MM-DD  ') NOW,
        TO_CHAR(SYSDATE -3, 'YYYY-MM-DD  ') NEW_BEFORE3
FROM dual;


-- YYYY MM DD D(������ ���ڷ�. �Ͽ����� 1, ������� 7)
-- IW(����. ���° ������ ǥ��. 1~53), HH, MI, SS

SELECT TO_CHAR(SYSDATE, 'YYYY') YYYY
      ,TO_CHAR(SYSDATE, 'MM') MM
      ,TO_CHAR(SYSDATE, 'DD') DD
      ,TO_CHAR(SYSDATE, 'D') D
      ,TO_CHAR(SYSDATE, 'IW') IW
      ,TO_CHAR(TO_DATE('20191231', 'YYYYMMDD'), 'IW') R
FROM dual;


SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD ') DT_DASH
      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS ') DT_DAS_WIDTH_TIME
      ,TO_CHAR(SYSDATE, 'DD-MM-YYYY ')DT_DD_MM_YYYY
FROM dual;



-- DATE Ÿ���� ROUND, TRUNC ����
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now
      --MM���� �ݿø� (11�� -> 1��)
      ,TO_CHAR(ROUND(SYSDATE, 'YYYY'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY
      --MM���� �ݿø� (11�� -> 1��)
      ,TO_CHAR(ROUND(SYSDATE, 'MM'), 'YYYY-MM-DD hh24:mi:ss') now_MM
      --DD���� �ݿø� (25�� -> 1����)
      ,TO_CHAR(ROUND(SYSDATE, 'DD'), 'YYYY-MM-DD hh24:mi:ss') now_DD
      --HH���� �ݿø� (12�� -> 12�� �������� ǥ��ǳ�.)
      ,TO_CHAR(ROUND(SYSDATE, 'HH'), 'YYYY-MM-DD hh24:mi:ss') now_HH
FROM dual;



-- ��¥ ���� �Լ�
-- MONTHS_BETWEEN(DATE 1, DATE 2) : DATE 1 �� DATE 2 ������ ���� ��
-- ADD MONTHS(DATE, ������ ������) : DATE���� Ư�� �������� ���ϰų� ��
-- NEXT_DAY(DATE, weekday(1~7)) : DATE���� ù��° weekday ��¥
-- LAST_DAY(DATE) : DATE�� ���� ���� ������ ��¥


-- MONTHS_BETWEEN
SELECT MONTHS_BETWEEN(TO_DATE('20191125', 'YYYYMMDD'),
                     TO_DATE('20200331', 'YYYYMMDD')) m,
       TO_DATE('20191125', 'YYYYMMDD')-
       TO_DATE('20200331', 'YYYYMMDD') N                     
FROM dual;


-- ADD_MONTHS(DATE, NUMBER(+,-))
SELECT ADD_MONTHS(TO_DATE('20191125', 'YYYYMMDD'), 5) NEW_5M
      ,ADD_MONTHS(TO_DATE('20191125', 'YYYYMMDD'), -5) NEW_5M
FROM dual;


-- NEXT_DAYS
SELECT NEXT_DAY(SYSDATE, 1) --���� ��¥(11/25)���� �����ϴ� ù �����
FROM dual;





