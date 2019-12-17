
--WITH
--WITH 블록 이름 AS (
--   서브쿼리
--)
--SELECT *
--FROM 블록이름

--deptno, avg(sal) avg_sal
--해당 부서의 급여평균이 전제 직원의 평균보다 놓은 부서에 한해 조회
SELECT deptno, avg(sal) avg_sal
FROM emp
GROUP BY deptno
HAVING avg(sal)> (SELECT avg(sal) FROM emp); 
--AVG(sal) 을 비교하기 위해 having절을 사용함....


-- WITH절을 사용하여 위의 쿼리를 자성

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
계층쿼리(달력만들기)

- connect by level <= n

- 테이블의 row 건수를 n만큼 반복한다
- connect by level 절을 사용한 쿼리에서는
- select 절에서 level이라는 특수한 컬럼을 사용할 수 있다.
- 계층을 표현하는 특수 컬럼으로 1부터 증가하며 rownum과 유사
- 추후 배우게 될 START WITH, CONNECT BY 절에서 다른 점을 배울것임

*/

-- 2019년 11월은 30일까지 존재함
-- 일자 + 정수 = 정수만큼 미래의 일자
-- 해당년월의 날짜가 몇일까지 존재하는가? 어떻게 알 수 있지?
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + LEVEL -1 DT --LEVEL을 쓰면 ROWNUM같은 숫자가 생기긴 하네...
FROM dual
CONNECT BY LEVEL <= 30;


-- 날짜의 마지막날을 뽑아내는 연산
SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD') L_DAY
--        SYSDATE ADD_MONTHS
FROM DUAL;


-- 합치자
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1) DT
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD');


-- 요일 포맷 D를 사용하자
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1) DT,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL -1), 'd') D
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD');


-- 인라인뷰 + 날짜를 생각해보자
SELECT /*일요일이면 날짜, 화요일이면날짜, ... 토요일이면날짜*/
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


-- 날짜로 비교해보자. 7개의 행을 하나로 묶어줄 무언가가 필요하다.
-- 주차.. IW ! 인라인뷰에 추가해주자
-- 이후 그룹칼럼으로 묶어주자. 모든 디코드에 max를 적용해주면!
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


-- 근데 해보면 일요일이 밀렸다.. IW를 셀 때 월요일부터 시작해서.
-- 일요일에 하나를 추가해주면 된다. 
-- DEOCDE를 IW에 해주자
-- 아니면 인라인뷰의 포맷을 바꾸면? IW에 레벨을 -1 했는데
-- 주차 계산을 하루땡겨서 다른 날짜를 기준으로 쓰는걸로! -1을 없애자!
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


-- 12월은 어쩌지? 목요일을 기준으로 IW를 세기 때문에
-- 마지막 주는 01로 나오고 정렬했을 때 맨 위에 나온다.
-- DECODE 쓰기? 으음.. 안된다. 오더가 안 먹힌다.
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
-- 미친... 이거 생각한놈 누구냐......
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
-- 정렬을 토요일을 기준으로..



-- 만약 앞뒤 월의 날짜를 모두 나오게 하고싶다면?
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
--2026년 2월은? 2020년 5월은???

SELECT dd - mod7 D
FROM
(SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'D') dd,
        MOD(TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD'),7) mod7
FROM dual);
-- 미쳐따데스네
-- (마지막 날의 요일번호 - 달력일수%7)만큼을 시작할 때 빼주면 항상 일요일부터 달력이 시작된다!
-- 근데 마이너스 나오는 달은 우야?


--- 달력만들기 복습
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
START WITH deptcd = 'dept0' -- 시작점은 DEPTCD = DEPT0.. 즉 XX회사
CONNECT BY PRIOR deptcd = p_deptcd
;
/*
    dept0(XX회사)
        dept0_00(디자인부)
            dept0_00_0(디자인팀)
        dept0_01(정보기획부)
            dept0_01_0(기획팀)
                dept0_01_0_0(기획파트)
        dept0_02(정보시스템부)
            dept0_02_0(개발1팀)
            dept0_02_1(개발2팀)





