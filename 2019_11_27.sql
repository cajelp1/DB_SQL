---------------------------------- 복습 및 연습
SELECT TRIM('d' FROM 'HELLO, WORLD') --trim은 앞뒤밖에 못자르는구나...
FROM dual;



---------------------------------- condition 실습 cond2

-- 건강검진 대상자 조회 쿼리
-- 1. 올해가 짝수인지 홀수인지
-- 2. hiredate에서 입사년도가 짝수인지 홀수인지

---- **가급적이면 코드를 바꾸지 않아도 쓸 수 있는 형태로. SYSDATE를 쓰는 이유도 그것.**

SELECT empno, ename, hiredate
      ,CASE
            WHEN MOD(TO_CHAR(hiredate,'YY'),2)=
                 MOD(TO_CHAR(SYSDATE, 'YY'),2)
            THEN '건강검진 대상자'
            ELSE '건강검진 비대상자'
      END contact_to_doctor
FROM emp;


SELECT empno, ename, hiredate
      ,DECODE(MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YY')),2)
      ,MOD(TO_NUMBER(TO_CHAR(hiredate, 'YY')),2),'건강검진 대상자'
      ,'건강검진 비대상자') contact_to_doctor
FROM emp;


--내년도 거는? (2020년)

SELECT empno, ename, hiredate
      ,DECODE(MOD(TO_CHAR(SYSDATE, 'YY')+1,2)
      ,MOD(TO_CHAR(hiredate, 'YY'),2),'건강검진 대상자'
      ,'건강검진 비대상자') contact_to_doctor
FROM emp;

SELECT empno, ename, hiredate
      ,CASE
            WHEN MOD(TO_CHAR(hiredate,'YY'),2)=
                 MOD(TO_CHAR(SYSDATE, 'YY')+1,2)
            THEN '건강검진 대상자'
            ELSE '건강검진 비대상자'
      END contact_to_doctor
FROM emp;


---- REG_DT를 따라서 검진
DESC users;

SELECT userid, usernm, alias, reg_dt
      ,CASE
            WHEN MOD(TO_CHAR(reg_dt,'YY'),2)=
                 MOD(TO_CHAR(SYSDATE,'YY'),2)
            THEN '건강검진 대상자'
            ELSE '건강검진 비대상자'
      END contact_to_doctor
FROM users
ORDER BY userid;

------------ cond3

SELECT a.userid, a.usernm, a.alias,
       MOD(a.yyyy,2),
       DECODE(MOD(a.yyyy,2),mod(a.this_yyyy,2),'건강검진 대상자','건강검진 비대상자') con
FROM
    (SELECT userid, usernm, alias, TO_CHAR(reg_dt,'yyyy') yyyy,
            TO_CHAR(SYSDATE,'YYYY') THIS_yyyy
     FROM users) a;
------------- 왤케 복잡하게 혀...ㅋㅋㅋㅋ inline view를 이용.


-- 그룹함수. where절 도 올 수 있다는데... 으음. 어떤 형식으로 쓰지?

-- Group Function
-- 특정 컬럼이나 표현으로 여러 행의 값을 한 행의 결과로 생성
-- COUNT, SUM, AVG, MAX, MIN


-- 전체 직원을 대상으로 
-- 14건을 1개로 줄임

SELECT MAX(sal) max_s   --전 직원의 가장 높은 급여
      ,MIN(sal) min_s   --전 직원의 가장 낮은 급여
      ,ROUND(AVG(sal),2) avg_s  --전 직원의  급여 평균
      ,SUM(sal) sum_s   -- 전 직원의 급여 합계
      ,COUNT(sal) count_s   --전 직원의 급여 건수. null이 아닌 값이면 1건.
      ,COUNT(mgr) count_m   --전 직원의 직원의 관리자 건수. KING은 PRES라서 MGR이 없음.
      ,COUNT(*) count_row   --전 직원의 특정 컬럼의 건수가 아니라 행의 개수를 알고 싶을때
FROM emp;


-- 부서별 그룹 함수
SELECT deptno, MAX(sal) max_s   -- 부서별 가장 높은 급여
      ,MIN(sal) min_s   -- 부서별 가장 낮은 급여
      ,ROUND(AVG(sal),2) avg_s  -- 부서별 급여 평균
      ,SUM(sal) sum_s   -- 부서별 급여 합계
      ,COUNT(sal) count_sal   -- 부서별 급여 건수. null이 아닌 값이면 1건.
      ,COUNT(mgr) count_mgr   -- 부서별 직원의 관리자 건수. KING은 PRES라서 MGR이 없음.
      ,COUNT(*) count_row   -- 부서별 특정 컬럼의 건수가 아니라 행의 개수를 알고 싶을때
FROM emp
GROUP BY deptno;
-- order by가 끝에 붙으면 앞에 order by를 넣은 이름을 넣어 분류할 수 있다.


SELECT deptno, MAX(sal) max_s   -- 부서별 가장 높은 급여
      ,MIN(sal) min_s   -- 부서별 가장 낮은 급여
      ,ROUND(AVG(sal),2) avg_s  -- 부서별 급여 평균
      ,SUM(sal) sum_s   -- 부서별 급여 합계
      ,COUNT(sal) count_sal   -- 부서별 급여 건수. null이 아닌 값이면 1건.
      ,COUNT(mgr) count_mgr   -- 부서별 직원의 관리자 건수. KING은 PRES라서 MGR이 없음.
      ,COUNT(*) count_row   -- 부서별 특정 컬럼의 건수가 아니라 행의 개수를 알고 싶을때
FROM emp
GROUP BY deptno, ename;
-- ename은 중복되는 항목이 없기때문에 14개의 항이 모두 그대로 나옴


-- SELECT 절에는 GROUP BY 절에 표현된 컬럼 이외의 컬럼이 올 수 없다.
-- 논리적으로 성립이 되지 않음. (여러명의 직원 정보로 한 건의 데이터로 그루핑)
-- 단 예외적으로 상수값들은 SELECT절에 표현이 가능

SELECT deptno, '문자열', SYSDATE
      ,MAX(sal) max_s   -- 부서별 가장 높은 급여
      ,MIN(sal) min_s   -- 부서별 가장 낮은 급여
      ,ROUND(AVG(sal),2) avg_s  -- 부서별 급여 평균
      ,SUM(sal) sum_s   -- 부서별 급여 합계
      ,COUNT(sal) count_sal   -- 부서별 급여 건수. null이 아닌 값이면 1건.
      ,COUNT(mgr) count_mgr   -- 부서별 직원의 관리자 건수. KING은 PRES라서 MGR이 없음.
      ,COUNT(*) count_row   -- 부서별 특정 컬럼의 건수가 아니라 행의 개수를 알고 싶을때
FROM emp
GROUP BY deptno;



-- 그룹함수에서 NULL 컬럼은 계산에서 제외된다. 고로 자료칸이 따로 생성되지도 않는다.
-- emp 테이블에서 comm컬럼이 NULL이 아닌 데이터는 4건이 존재. 9건은 NULL.

SELECT COUNT(comm) count_comm
      ,SUM(comm) sum_comm
      ,SUM(sal+comm) tot_sal_sum -- 괄호 안에 있는 걸 먼저 계산하는데 null이 들어있기에 null처리함
      ,SUM(sal+ NVL(comm,0)) tot_sal_sum2
      ,SUM(sal)+SUM(comm) tot_sal_sum3
FROM emp;


-- WHERE 절에는 GROUP 함수를 표현 할 수 없다.
-- 부서별 최대 급여 구하기
-- deptno, 최대급여

SELECT deptno, MAX(sal) m_sal
FROM emp
--WHERE MAX(sal)>3000 --ORA-00934오류. WHERE 절에는 GROUP 함수가 올 수 없다.
HAVING MAX(sal)>=3000
GROUP BY deptno
ORDER BY m_sal desc;


-------------------- 실습 grp1,2
SELECT 
      MAX(sal) max_sal   -- 부서별 가장 높은 급여
      ,MIN(sal) min_sal   -- 부서별 가장 낮은 급여
      ,ROUND(AVG(sal),2) avg_sal  -- 부서별 급여 평균
      ,SUM(sal) sum_sal   -- 부서별 급여 합계
      ,COUNT(sal) count_sal   -- 부서별 급여 건수. null이 아닌 값이면 1건.
      ,COUNT(mgr) count_mgr   -- 부서별 직원의 관리자 건수. KING은 PRES라서 MGR이 없음.
      ,COUNT(*) count_all   -- 부서별 특정 컬럼의 건수가 아니라 행의 개수를 알고 싶을때
FROM emp;


--------------------------- 실습 grp3
SELECT CASE
       WHEN deptno=10 then 'ACCOUNTING'
       WHEN deptno=20 then 'RESEARCH'
       WHEN deptno=30 then 'SALES'
       END dname
       , max_sal, min_sal, avg_sal, count_sal, count_mgr, count_all
FROM(
SELECT deptno 
      ,MAX(sal) max_sal   -- 부서별 가장 높은 급여
      ,MIN(sal) min_sal   -- 부서별 가장 낮은 급여
      ,ROUND(AVG(sal),2) avg_sal  -- 부서별 급여 평균
      ,SUM(sal) sum_sal   -- 부서별 급여 합계
      ,COUNT(sal) count_sal   -- 부서별 급여 건수. null이 아닌 값이면 1건.
      ,COUNT(mgr) count_mgr   -- 부서별 직원의 관리자 건수. KING은 PRES라서 MGR이 없음.
      ,COUNT(*) count_all   -- 부서별 특정 컬럼의 건수가 아니라 행의 개수를 알고 싶을때
FROM emp
GROUP BY deptno )a
ORDER BY max_sal desc;


----------------------- 더 간단히!

SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') DNAME
      ,MAX(sal) max_sal   -- 부서별 가장 높은 급여
      ,MIN(sal) min_sal   -- 부서별 가장 낮은 급여
      ,ROUND(AVG(sal),2) avg_sal  -- 부서별 급여 평균
      ,SUM(sal) sum_sal   -- 부서별 급여 합계
      ,COUNT(sal) count_sal   -- 부서별 급여 건수. null이 아닌 값이면 1건.
      ,COUNT(mgr) count_mgr   -- 부서별 직원의 관리자 건수. KING은 PRES라서 MGR이 없음.
      ,COUNT(*) count_all   -- 부서별 특정 컬럼의 건수가 아니라 행의 개수를 알고 싶을때
FROM emp
GROUP BY deptno 
ORDER BY deptno;

--아니면 case를 써서?
SELECT case
       when deptno=10 then 'ACCOUNTING'
       when deptno=20 then 'RESEARCH'
       when deptno=30 then 'SALES'
       end DNAME
      ,MAX(sal) max_sal   -- 부서별 가장 높은 급여
      ,MIN(sal) min_sal   -- 부서별 가장 낮은 급여
      ,ROUND(AVG(sal),2) avg_sal  -- 부서별 급여 평균
      ,SUM(sal) sum_sal   -- 부서별 급여 합계
      ,COUNT(sal) count_sal   -- 부서별 급여 건수. null이 아닌 값이면 1건.
      ,COUNT(mgr) count_mgr   -- 부서별 직원의 관리자 건수. KING은 PRES라서 MGR이 없음.
      ,COUNT(*) count_all   -- 부서별 특정 컬럼의 건수가 아니라 행의 개수를 알고 싶을때
FROM emp
GROUP BY deptno 
ORDER BY deptno;



--------------- 입사년도별로 몇명이 입사했는지 조회하는 쿼리

SELECT TO_CHAR(hiredate, 'yyyymm') hiredate_yyyymm
      ,COUNT(TO_CHAR(hiredate, 'yyyymm')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm'); --그룹으로 묶는게 alias가 아니라 그냥 그대로 복붙에서 넣으면 가능하구나...

-- 그룹핑은 컬럼이 아니라 값으로도 할 수 있다!!!!


---------------------------- 실습 grp5

SELECT TO_CHAR(hiredate, 'yyyy') hiredate_yyyy
      ,COUNT(TO_CHAR(hiredate, 'yyyy')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyy');

SELECT *
FROM dept;

SELECT COUNT(*) cnt
FROM dept; 
--아 뭐야아아ㅏ아ㅏㅇ emp안 써두 돼ㅣ자나ㅏ아ㅏㅏㅏ앙



---------------------------- grp7

SELECT COUNT(*) cnt
FROM 
(SELECT deptno
FROM emp
GROUP BY deptno);

-- 간단히!
SELECT COUNT(COUNT(deptno)) cnt
FROM emp
GROUP BY deptno;


-- 약간 다른 명령어.. distinct. 구별하라. 중복을 제외하는 것.
SELECT COUNT(DISTINCT deptno) cnt
FROM emp;


-- join
-- 1. 테이블 구조 변경 (컬럼 추가)
-- 2. 추가된 컬럼에 값을 update
-- emp 테이블에 dename을 추가

DESC emp;
DESC dept;

-- 구조변경.. 컬럼 추가. (dname, VARCHAR2 (14))
ALTER TABLE emp ADD (dname VARCHAR2(14));
-- ALTER TABLE emp DROP COLUMN dname;

UPDATE emp SET dname = CASE
                        WHEN deptno=10 then 'ACCOUNTING'
                        WHEN deptno=20 then 'RESEARCH'
                        WHEN deptno=30 then 'SALES'
                       END;

--WHERE 을 아래 추가해서 행을 지정할 수 있음 

COMMIT;

SELECT*
FROM emp;


-- SALES --> MARKET SALES
-- 총 6건의 데이터 변경이 필요하다
-- 값의 중복이 있는 형태 (반 정규형)
UPDATE emp SET dname = 'MARKET SALES'
WHERE dname = 'SALES'; --참고만 하세요.. 바꾸지 마세요...ㅋㅋㅋ



-- emp 테이블, dept 테이블 조인
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;





