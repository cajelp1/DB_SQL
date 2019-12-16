

-- GROUPING SETS (col1, col2)
-- 다음과 결과가 동일
-- 개발자가 GROUP BY 의 기준을 직접 명시한다
-- ROLLUP과 달리 방향성을 갖지 않는다
-- GROUPING SETS(col1, col2) = GROUPING SETS (col2, col1)

-- GROUP BY COL1
-- UNION ALL
-- GROUP BY COL2

-- emp 테이블에서 직원의 job별 급여(sal)+상여(comm)합,
--                 deptno별 급여(sal)+상여(comm)합 구하기
-- 기존방식(GROUPING FUNCTION) : 2번의 SQL 작성 필요 (union, union all)

SELECT job, NULL, SUM(sal+NVL(comm,0))
FROM emp
GROUP BY job
    UNION ALL
SELECT NULL, deptno, SUM(sal+NVL(comm,0))
FROM emp
GROUP BY deptno;


-- GROUPING SETS 구문을 이용하여 위의 SQL을 집합연산을 사용하지 않고
-- 테이블을 한번 읽어서 처리
SELECT job, deptno, SUM(sal+NVL(comm, 0)) SAL
FROM emp
GROUP BY GROUPING SETS (job, deptno);

SELECT job, deptno, SUM(sal+NVL(comm,0)) sal
FROM emp
GROUP BY grouping sets (deptno, job);


-- job, deptno를 그룹으로 한 sal+comm 합
-- mgr을 그룹으로 한 sal+comm 합
-- GROUP BY job, deptno
-- UNION ALL
-- GROUP BY mgr
-- --> GROUPING SETS ((job, deptno), mgr)

SELECT job, deptno, mgr, SUM(sal+NVL(comm,0)) SAL,
        GROUPING(job), GROUPING(deptno), GROUPING(mgr)
FROM emp
GROUP BY GROUPING SETS ((job, deptno), mgr);

-- 엥.. KING은 그냥 null로 나오네


/*
CUBE (col1, col2...)
- 나열된 컬럼의 모든 가능한 조합으로 GROUP BY subset을 만든다
- CUBE에 나열된 컬럼이 2개인 경우 가능한 조합 4개
- CUBE에 나열된 컬럼이 3개인 경우 가능한 조합 8개
- CUBE에 나열된 컬럼수를 2의 제곱승 한 결과가 가능한 조회 개수임
- 컬럼이 조금만 많아져도 가능한 조합이 기하급수적으로 늘어나기 때문에
  많이 사용하지는 않는다
*/

-- job, deptno 에 cube 적용
SELECT job, deptno, SUM(sal+NVL(comm,0)) sal
FROM emp
GROUP BY CUBE(job, deptno);
-- 1,1 GROUP BY job, deptno
-- 1,0 GROUP BY job
-- 0,1 GROUP BY deptno
-- 0,0 GROUP BY emp... 모든 행에 대해 GROUP BY

-- GROUP BY 응용
-- GROUP BY ROLLUP, CUBE를 섞어 사용하기
-- 가능한 조합을 생각해보면 결과를 예측할 수 있다
-- GROUP BY job, rollup(deptno), cube(mgr)

SELECT job, deptno, mgr, SUM(sal+NVL(comm, 0)) SAL
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

-- 으에에ㅔ에ㅔ
SELECT job, sum(sal)
FROM emp
GROUP BY job, job; --중복은 무시하넹


-- sub_a1
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER);

UPDATE dept_test SET empcnt=(
    SELECT count(*)
    FROM emp
    WHERE emp.deptno = dept_test.deptno
); --이러면 NULL 값이 나오나? 안나오는데

UPDATE dept_test SET empcnt=(
    SELECT count(deptno)
    FROM emp
    WHERE emp.deptno = dept_test.deptno
); -- 이러면 0이 나오네

SELECT *
FROM dept_test;


/*
COMMIT;
ROLLBACK;

DELETE FROM dept WHERE deptno=99;
SELECT *
FROM dept
WHERE deptno=99;
*/


-- sub_a2
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

INSERT INTO dept_test VALUES (99,'it1','daejeon');
INSERT INTO dept_test VALUES (98,'it2','daejeon');

SELECT *
FROM dept_test;
SELECT deptno
FROM emp
GROUP BY deptno;


DELETE FROM dept_test WHERE deptno NOT IN (
    SELECT deptno
    FROM emp
--    WHERE dept_test.deptno = emp.deptno
--    GROUP BY deptno
);


-- sub_a3
DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT *
FROM emp;
SELECT deptno, AVG(sal)
FROM emp
GROUP BY deptno;


UPDATE emp_test SET sal= sal+200
WHERE sal<(SELECT avg(sal)
           FROM emp
           WHERE deptno = emp_test.deptno);
--           GROUP BY deptno); 그룹바이 안써도 되는거 헷갈려...

SELECT *
FROM emp_test;

/* 여기부터는 선생님이 힌트 주기 전에 삽질... ㅠㅠ
UPDATE emp_test SET sal(
    SELECT sal+200
    FROM emp
    WHERE emp_test.sal < (SELECT avg(sal)
                          FROM emp
                          WHERE emp.deptno=emp_test.deptno
                          GROUP BY deptno)
);*/



ROLLBACK;

-- MERGE 구문을 이용한 업데이트
MERGE INTO emp_test a
USING (SELECT deptno, AVG(sal) sal FROM emp GROUP BY deptno) b
ON (a.deptno = b.deptno)
--    AND a.sal < b.sal) -- 에러가 뜬다. 왜냐면 on절에 쓰인건 업데이트 할 수 없음
WHEN MATCHED THEN 
    UPDATE SET sal = sal+200
WHERE a.sal < b.sal -- 그래서 where절을 추가로 써준다
;-- 아뉘이 왜 on절 관련된건 안 알려줘여어어어어ㅓ어 ㅡㅡ


-- case 절로 쓰는건?
MERGE INTO emp_test a
USING (SELECT deptno, AVG(sal) sal FROM emp GROUP BY deptno) b
ON (a.deptno = b.deptno)
WHEN MATCHED THEN 
    UPDATE SET sal = case
                        WHEN a.sal < b.sal THEN sal+200
                        ELSE sal
                     END;

SELECT *
FROM emp_test;








