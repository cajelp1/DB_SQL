






SELECT SYSDATE, LAST_DAY(SYSDATE)
FROM dual;


------ DATE 실습 FN3

SELECT '201912' PARAM --여기는 데이터가 문자열인 컬럼... 근데 차이는 없는데?
      ,TO_CHAR(
       LAST_DAY(
       TO_DATE('201912','YYYYMM')),'DD')
       DT
FROM dual;

-- '201912' --> DATE타입으로 변경하기
-- 해당 날짜의 마지막날짜로 이동
-- 일자 필드만 추출하기 <-- 이걸 먼저 해버리면 LAST_DAY 명령어가 날짜를 인식하지 못함.


SELECT :YYYYMM PARAM --바인드 변수
      ,TO_CHAR(
       LAST_DAY(
       TO_DATE(:YYYYMM,'YYYYMM')),'DD')
       DT
FROM dual;

-- SYSDATE를 포맷변환
-- 다시 날짜로 변환
SELECT TO_CHAR(
       TO_DATE(
       TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD'), 'YYYY-MM-DD HH24:MI:SS')
FROM DUAL;

-------------------------------- 복습 겸 연습
SELECT LENGTH('*')
FROM DUAL;

SELECT ROUND(TO_DATE('20190215','YYYYMMDD'),'MM')--?
FROM DUAL;
--------------------------------


-- EMPNO가 7369인 직원 정보 조회 하기
SELECT *
FROM emp
WHERE empno = TO_NUMBER('7369'); -- 문자를 숫자로? 아님 숫자를 문자로?


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';


SELECT *
FROM TABLE(dbms_xplan.display);
-- 자식부터 읽는다. 음.. 무슨 소리지이
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

-- 이번엔 데이터 컬럼을 문자열로 바꿔서 
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';


-- 더하기 연산이 들어갈때는?
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300+'69';

SELECT *
FROM TABLE(dbms_xplan.display);

   1 - filter("EMPNO"=7369) --생각이랑 비슷하게 됨.


-------------------------------------

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/6/01','YYYY/MM/DD');

SELECT *
FROM emp
WHERE hiredate >= '81/6/01'; --자동으로 형변환이 되긴 했..는데..

-- DATE 타입의 묵시적 형변환은 사용을 권하지 않음. 나라가 달라지면 표현이 달라짐.



---------------------RR TEST
SELECT TO_DATE('50/05/05','RR/MM/DD')
      ,TO_DATE('49/05/05','RR/MM/DD')
      ,TO_DATE('50/05/05','YY/MM/DD')
      ,TO_DATE('49/05/05','YY/MM/DD')
FROM DUAL;



-- 숫자 --> 문자열
-- 문자열 --> 숫자
--숫자 1000000 --> 1,000,000.00 (한국)
--숫자 1000000 --> 1.000.000,00 (독일)
-- 날짜 포맷 : YYYY
-- 숫자 포맷 : 숫자표현 : 9, 자리맞춤을 위한 0표시 : 0, 화폐단위 : L
--            1000 자리 구분 : , , 소수점 : .
-- 숫자 -> 문자열 TO_CHAR(숫자, '포맷')


SELECT empno, ename, sal, TO_CHAR(sal,'9,999') fm_sal
FROM emp;

SELECT empno, ename, sal, TO_CHAR(sal,'009,999') fm_sal
FROM emp;

SELECT empno, ename, sal, TO_CHAR(sal,'L009,999') fm_sal
FROM emp;

-- 숫자 포맷이 길어질 경우, 자리수를 충분히 표현해주어야 함.
SELECT TO_CHAR(1000000, '9.999')
FROM dual; --에러남
SELECT TO_CHAR(1000000, '999,999,999.999')
FROM dual; --표기됨


-- NULL 처리함수 : NVL, NVL2, NULLIF, COALESCE

-- NVL(expr1, expr2) : 함수 인자 두개
-- expr1이 NULL 이면 expr2를 반환
-- expr1이 NULL이 아니면 expr1을 반환
SELECT empno, ename, comm, NVL(comm, -1) nvl_comm
FROM emp;


-- NVL2(expr1, expr2, expr3)
-- expr1 IS NOT NULL --expr2 리턴
-- expr1 IS NULL     --expr3 리턴
SELECT empno, ename, comm, NVL2(comm, 1000, -500) nvl_comm
FROM emp;

SELECT empno, ename, comm, NVL2(comm, comm, -500) nvl_comm --NVL과 동일한 결과
FROM emp;


-- NULLIF(expr1, expr2) <--NULL을 넣는 함수
-- expr1 = expr2    NULL을 리턴
-- expr1 != expr2   expr1을 리턴
SELECT empno, ename, comm, NULLIF(comm, comm+500) nullif_comm
FROM emp;
-- comm이 NULL일 때 comm+500 =NULL
--      NULLIF(NULL, NULL) : NULL
-- COMM이 NULL이 아닐 때 comm+500 = comm+500
--      NULLIF(COMM, COMM+500) : comm



-- COALESCE(expr1, expr2, expr3 ....)
-- 인자 중에 첫번째로 등장하는 NULL 이 아닌 exprN을 리턴
-- expr1 IS NOT NULL : expr1을 리턴
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
-- emp.job 컬럼을 기준으로
-- 'SALESMAN' 이면 sal * 1.05를 적용한 값 리턴
-- 'MANAGER' 이면 sal * 1.10 리턴
-- 'PRESIDENT' 이면 SAL * 1.20 리턴
-- 위 세가지 직분이 아닐 경우 sal 리턴
-- empno, ename, job, sal, 요율 적용한 급여 AS bonus
SELECT empno, ename, job, sal
      ,CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal
       END bonus
       ,comm,
--     comm이 NULL 일 경우 -10을 리턴하도록 구성
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





