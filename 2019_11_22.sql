
-- emp 테이블에서 부서가 10번이 아니고 입사가 1981년 6월1일 이후인 직원. 
-- IN, NOT IN 사용금지


SELECT *
FROM emp
WHERE deptno != 10
AND hiredate >= TO_DATE('19810601', 'yyyymmdd');

SELECT *
FROM emp
WHERE deptno NOT IN(10)
AND hiredate >= TO_DATE('19810601', 'yyyymmdd');


SELECT *
FROM emp
WHERE JOB LIKE 'SALESMAN'
OR hiredate >= TO_DATE('19810601', 'yyyymmdd');


SELECT *
FROM emp
WHERE JOB = 'SALESMAN'
OR empno >= 7800 AND empno <7900;

-- 전제조건... 1. EMPNO가 숫자여야 된다 / 2. 숫자가 네자리여야 한다.



-- 이름이 SMITH이거나 ALLEN 이면서 역할이 SALESMAN

SELECT *
FROM emp
WHERE (ename = 'SMITH'
OR ename ='ALLEN') 
AND job = 'SALESMAN';


SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%'
AND hiredate > TO_DATE('19810601', 'YYYYMMDD');


/*
    SELECT ~, ~, ....
    FROM 테이블명
    WHERE coll = '값'
    ORDER BY 정렬기준컬럼1 [ASC / DESC], 정렬기준컬럼2 ... [ASC / DESC]
*/


-- emp 테이블에서 정보를 직원 이름으로 오름차순 정렬

DESC emp;

SELECT *
FROM emp
ORDER BY ename DESC;


-- 부서번호로 오름차순, 부서번호가 같으면 sal 기준 내림차순
-- sal이 같으면 이름으로 오름차순

SELECT *
FROM emp
ORDER BY deptno, sal DESC, ename;


-- 정렬 컬럼을 ALIAS로 표현
SELECT deptno, sal, ename nm
FROM emp
ORDER BY nm;


-- 조회하는 컬럼의 위치 인덱스로 표현가능
SELECT deptno, sal, ename nm
FROM emp
ORDER BY 3; 
-- 추천하지 않음. 컬럼 순서가 추가되거나 삭제되면 정렬기준이 바뀜



-- DEPT 가 부서이름으로 오름차순, 부서위치로 내림차순

DESC dept;

SELECT *
FROM dept
ORDER BY dname, loc DESC;

SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm !=0
ORDER BY comm DESC, empno;


SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;


SELECT *
FROM emp
WHERE deptno IN(10, 30)
AND sal > 1500
ORDER BY ename DESC;



-- ROWNUM

SELECT ROWNUM, empno, ename
FROM emp;

--WHERE 절에서도 사용 가능하지만
--WHERE ROWNUM = 1      <<같다를 사용할 때는 1만 가능
--WHERE ROWNUM < n      <<2부터 사용가능
--WHERER ROWNUM <= n    <<1부터 순차적으로 조회하는 경우는 가능
--BETWEEN 1 AND 10      <<항상 1부터 시작


SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 2 AND 20;


-- SELECT절과 ORDER BY 구문의 실행순서
-- SELECT, 그 후 ORDER BY. 
-- SELECT 절에 ROWNUM을 넣었기 때문에 그 후에 ORDER BY 를 넣으면 ROWNUM은 바뀐다.
      
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;



-- INLINE VIEW를 통해 정렬 먼저 실행하고, 해당 결과에 ROWNUM을 적용
-- ()를 넣으면 이 녀석을 테이블로 인식함
-- * 를 표현하고 다른 컬럼 혹은 표현식을 썼을 경우,
-- * 앞에 테이블명이나 테이블의 별칭을 적용해야 함.
-- ()를 써서 만든 INLINE VIEW 뒤에 A를 붙이고, 맨 앞의 SELECT 절에 A.*


SELECT ROWNUM, e.*
FROM emp e;


SELECT ROWNUM RN, empno, ename
FROM emp
WHERE ROWNUM <=10;


SELECT a.*
FROM   (SELECT ROWNUM RN, empno, ename
        FROM emp) A
WHERE RN BETWEEN 11 AND 14;


-- ROW3
-- EMP 테이블 ename으로 정렬하고 11, 14만 조회해라

SELECT *
FROM
(SELECT ROWNUM RN, A.*
FROM   (SELECT empno, ename
        FROM emp
        ORDER BY ename)A)
WHERE RN BETWEEN 11 AND 14;



