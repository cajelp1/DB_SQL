-- 복습

SELECT *
FROM (SELECT ROWNUM rn, A.*
      FROM   (SELECT empno, ename
              FROM emp
              ORDER BY ename) A)
WHERE RN BETWEEN 11 AND 20;



-- heLlO, wOrLd!
-- dual 테이블 : sys  계정에 있으며 누구나 사용가능
-- 데이터는 한 행만 존재하고 컬럼도 하나. 컬럼 이름은 x.

SELECT *
FROM dual;



-- SINGLE ROW FUNCTION 행당 한번의 FUNCTION 실행
-- 1개의 행 INPUT -> 1개의 행 OUTPUT

SELECT LOWER('heLlO, wOrLd!'), UPPER('heLlO, wOrLd!'), 
INITCAP('heLlO, wOrLd!')
FROM dual;


--DUAL 테이블에는 데이터가 하나만 존재한다. 데이터도 하나의 행으로 나온다. 
--emp 테이블에는 14개의 데이터가 존재. (14개의 행).
--      고로 아래 결과도 14개의 행으로 나옴
SELECT emp.*, LOWER('heLlO, wOrLd!') low, 
        UPPER('heLlO, wOrLd!') upp, 
        INITCAP('heLlO, wOrLd!')
FROM emp;


-- lower, upper, initcap은 모두 쿼리에 출력할 때만 대소문자로 바꿔보이기에
-- WHERE 이나 LIKE 절을 쓸 때는 입력된 데이터 그대로를 쳐야한다.
SELECT empno, INITCAP(ename)
FROM emp
WHERE LOWER(ename) = 'smith'; --명령할때도 적용 가능함.


SELECT CONCAT(CONCAT('HELLO',', '),'WORLD') CCAT,
        'HELLO'||', '||'WORLD' ASDF,
        SUBSTR('HELLO, WORLD', 1, 4) SUB, -- SUBSTR(문자열, 시작인덱스, 종료인덱스)
-- 시작인덱스는 1부터, 종료인덱스 문자열까지 포함한다.


-- INSTR : 문자열에서 특정 문자열이 존재하는지, 존재할 경우 문자의 인덱스를 리턴
        INSTR('HELLO, WORLD', 'O') i1, -- 5, 9
        INSTR('HELLO, WORLD', 'O', 6) i2, -- 문자열의 특정 인덱스 이후부터 검색하도록 옵션
        INSTR('HELLO, WORLD', 'O', INSTR('HELLO, WORLD', 'O')+1) i3, -- 9번째를 찾을 수 있는 다른 옵션
        
        LPAD('HELLO, WORLD', 15, '*')L1,
        LPAD('HELLO, WORLD', 15 )L1, -- DEFAULT 채움문자는 공백
        RPAD('HELLO, WORLD', 15, '*')R1,

-- L/RPAD 특정 문자열의 왼/오른 쪽에 설정한 문자열 길이보다 부족한만큼 문자열을 채워넣는다.

-- REPLACE(대상문자열, 검색문자열, 변경할문자열)
-- 대상문자열에서 검색 문자열을 변경할 문자열로 치환
        REPLACE ('HELLO, WORLD', 'HELLO', 'hello') rep1,
        
-- 문자열 앞 뒤 공백 제거
        '    hello world    ' before_trim1,
        TRIM ('    hello world    ') after_trim1,
--        LTRIM ('hello world', 'h') after_trim2
        TRIM ('h' from '    hello, world     ') after_trim2 -- 이 경우 공백은 사라지지 않음

FROM dual;


-- 숫자 조작함수
-- ROUND : 반올림  ROUND(숫자, 반올림자리)
-- TRUNC : 절삭   TRUNC(숫자, 절삭자리)
-- MOD : 나머지 연산 MOD(피제수, 제수) // MOD(5,2) : 1


SELECT --반올림 결과가 소수점 1자리까지 나옴. 소수점 둘째자리에서 반올림.
        ROUND(105.54, 1) r1,
        ROUND(105.55, 1) r2,
        ROUND(105.55, 0) r3,
        ROUND(105.55, -1) r4
FROM dual;


SELECT --절삭 결과가 소수점 1자리까지 나옴. 소수점 둘째자리에서 반올림.
        TRUNC(105.54, 1) t1,
        TRUNC(105.55, 1) t2,
        TRUNC(105.55, 0) t3,
        TRUNC(105.55, -1) t4
FROM dual;


-- MOD : 피제수를 제수로 나눈 나머지 값
-- MOD(M, 2)의 결과 종류 : 0, 1(0~제수1-) 
SELECT MOD(5, 2) 
FROM dual;


-- emp 테이블의 sal 컬럼을 1000으로 나눴을 때 사원별 나머지 값
--을 조회하는 sql 작성. 
-- ename, sla, sal/1000의 몫, sal/1000의 나머지
SELECT ename, sal, 
        TRUNC(sal/1000) "SAL/1000", --정수만 나타내고 싶을때는 생략가능
        MOD(SAL, 1000) REMAINDER,
        TRUNC(sal/1000)*1000 + MOD(SAL, 1000) SAL2
FROM emp;



SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS')
FROM emp;


-- SYSDATE : 현재 날짜, 시간정보를 DATE 타입으로 반환
-- SYSDATE : 서버의 현재 DATE를 리턴하는 내장함수, 특별한 인자가 없다.
-- DATE 연산 : DATE + 정수 : N일만큼 더한다
-- DATE 연산에서 정수는 일자.
-- 하루는 24시간이기에 시간을 더할 수도 있다. 1시간 = 1/24

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS  ') DATEs,
        TO_CHAR(SYSDATE + 5/24/60, 'YYYY-MM-DD HH:MI:SS  ') hours
FROM dual;


SELECT TO_CHAR(TO_DATE('2019-12-31', 'YYYY-MM-DD  '), 'YYYY-MM-DD') LASTDAY,
        TO_DATE('2019-12-31', 'YYYY-MM-DD  ')-5 LASTDAY_BEFORE,
        TO_CHAR(SYSDATE, 'YYYY-MM-DD  ') NOW,
        TO_CHAR(SYSDATE -3, 'YYYY-MM-DD  ') NEW_BEFORE3
FROM dual;


-- YYYY MM DD D(요일을 숫자로. 일요일이 1, 토요일이 7)
-- IW(주차. 몇번째 주인지 표기. 1~53), HH, MI, SS

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



-- DATE 타입의 ROUND, TRUNC 적용
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now
      --MM에서 반올림 (11월 -> 1년)
      ,TO_CHAR(ROUND(SYSDATE, 'YYYY'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY
      --MM에서 반올림 (11월 -> 1년)
      ,TO_CHAR(ROUND(SYSDATE, 'MM'), 'YYYY-MM-DD hh24:mi:ss') now_MM
      --DD에서 반올림 (25일 -> 1개월)
      ,TO_CHAR(ROUND(SYSDATE, 'DD'), 'YYYY-MM-DD hh24:mi:ss') now_DD
      --HH에서 반올림 (12시 -> 12시 기준으로 표기되네.)
      ,TO_CHAR(ROUND(SYSDATE, 'HH'), 'YYYY-MM-DD hh24:mi:ss') now_HH
FROM dual;



-- 날짜 조작 함수
-- MONTHS_BETWEEN(DATE 1, DATE 2) : DATE 1 과 DATE 2 사이의 개월 수
-- ADD MONTHS(DATE, 가감할 개월수) : DATE에서 특정 개월수를 더하거나 뺌
-- NEXT_DAY(DATE, weekday(1~7)) : DATE이후 첫번째 weekday 날짜
-- LAST_DAY(DATE) : DATE가 속한 월의 마지막 날짜


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
SELECT NEXT_DAY(SYSDATE, 1) --오늘 날짜(11/25)이후 등장하는 첫 토요일
FROM dual;





