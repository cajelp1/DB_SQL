

--MERGE

SELECT *
FROM emp_test
order by empno;

-- emp 테이블에 존재하는 데이터를 emp_test 테이블로 merge
-- 만약 empno에 동일한 데이터가 존재하면
-- ename update : ename ||'merge'
-- 만약 empno에 동일한 데이터가 존재하지 않을 경우
-- emp테이블의 empno, ename을 emp_test로 insert

-- emp_test 테이블 데이터 절반 삭제
DELETE emp_test
WHERE empno>= 7788;
commit;

-- emp 테이블에는 14건 데이터 존재
-- emp_test 테이블에는 사번이 7788보다 작은 7명의 데이터가 존재
-- emp테이블을 이용하여 emp_test테이블을 merge하게되면
-- emp테이블에만 존재하는 직원 (사번이 7788보다 크거나 같은) 7명
-- emp_test로 새롭게 insert되고
-- emp, emp_test에 사원번호가 동일하게 존재하는 7명은
-- ename||'modify'로 업데이트한다

/*
MERGE INTO 테이블명
USING 머지대상 테이블/뷰/서브쿼리
ON 테이블명과 머지대상의 연결관계
WHEN MATCHED THEN
    UPDATE ....
WHEN NOT MATCHED THEN
    INSERT ....
*/

MERGE INTO emp_test
USING emp
ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = ename||'_M' --modify 라고 쓰면 12자리를 넘어감
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);

SELECT *
FROM emp_test;


-- emp_test 테이블에 사번이 9999인 데이터가 존재하면
-- ename을 'brown'으로 update
-- 존재하지 않을 경우 empno, ename VALUE (9999,'brown')으로 insert
-- 위의 시나리오를 merge 구문을 활용하여 한번의 sql로 구현

MERGE INTO emp_test
USING dual
ON (emp_test.empno = :empno)
WHEN MATCHED THEN
    UPDATE SET ename = :ename || '_mod'
WHEN NOT MATCHED THEN
    INSERT VALUES (:empno, :ename);

/*
만약 merge 구문이 없다면
1. empno = 9999 인 데이터가 존재하는지 확인
2-1. 1번 사항에서 데이터가 존재하면 update
2-2. 1번 사항에서 데이터가 존재하지 않으면 insert
*/


-- GROUP_AD1
    SELECT deptno, SUM(sal) sal
    FROM emp
    GROUP BY deptno
UNION
    SELECT NULL, SUM(sal) sal
    FROM emp;


-- JOIN 방식으로?
-- emp 테이블의 14건의 데이터를 28건으로 생성
-- 구분자(1-14)(2-14)를 줘서 group by

SELECT DECODE(b.rn, 1, a.deptno, 2, NULL) deptno,
        SUM(a.sal) sal 
FROM emp a,
    (SELECT rownum rn
    FROM dept
    WHERE ROWNUM <=2) b
GROUP BY DECODE(b.rn, 1, a.deptno, 2, NULL)
ORDER BY DECODE(b.rn, 1, a.deptno, 2, NULL);

SELECT DECODE(b.rn, 1, a.deptno, 2, NULL) deptno,
        SUM(a.sal) sal 
FROM emp a,
    (SELECT 1 rn FROM dual UNION    --이부분 다르다
     SELECT 2 rn FROM dual) b       --이부분 다르다
GROUP BY DECODE(b.rn, 1, a.deptno, 2, NULL)
ORDER BY DECODE(b.rn, 1, a.deptno, 2, NULL);


SELECT DECODE(b.rn, 1, a.deptno, 2, NULL) deptno,
        SUM(a.sal) sal 
FROM emp a,
    (SELECT LEVEL rn FROM dual  --이부분 다르다
     CONNECT BY LEVEL <=2) b    --이부분 다르다
GROUP BY DECODE(b.rn, 1, a.deptno, 2, NULL)
ORDER BY DECODE(b.rn, 1, a.deptno, 2, NULL);


-- REPORT GROUP BY
-- ROLLUP
-- GROUP BY ROLLUP(coll....)
-- ROLLUP 절에 기술된 컬럼을 오른쪽에서부터 지원 결과로
-- SUB GROUP을 생성하여 여러개의 GROUP BY 절을 하나의 SQL에서
-- 실행되도록 한다.
GROUP BY ROLLUP (job, deptno)
-- GROUP BY job, deptno
-- GROUP BY job
-- GROUP BY ---> 전체 행을 대상으로 GROUP BY


-- emp 테이블을 이용하여 부서번호별, 전체직원별 급여합을 구하는 쿼리를
-- ROLLUP 기능을 이용하여 작성
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);

/*
emp 테이블을 이용하여 job, deptno 별 sal+comm 합계
                    job별 sal+comm 합계
                    전체직원의 sal+comm합계
rollup을 활용하여 작성
*/

SELECT job, deptno, SUM(sal+NVL(comm, 0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);
-- *** ROLLUP 은 컬럼순서가 조회 결과에 영향을 미친다.
-- GROUP BY job, deptno
-- GROUP BY job
-- GROUP BY ---> 전체 행을 대상으로 GROUP BY


-- GROUP_AD2

SELECT NVL(job, '총계'), deptno, SUM(sal+NVL(comm, 0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);

SELECT decode(grouping(job),0,job,1,'총계') job, --여길 더 간단히!
--     decode(grouping(job),1,'총계',job) --일케쓰면 됨
       deptno, SUM(sal+NVL(comm, 0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);


-- deptno null값을 바꾸려면?
select decode(grouping(job),1,'총계',job) job,
       decode(grouping(job)+grouping(deptno),2,'계',1,'소계',deptno) deptno,
        case
          when grouping(job)=1 then '계'
          when grouping(deptno)=1 then '소계'
          when grouping(deptno)=0 then to_char(deptno)
        end deptno,
        SUM(sal+NVL(comm, 0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);


-- 보기 싫으니까 다르게 바꾸면?
select  case
          when grouping(job)=1 then '총계'
          when grouping(deptno)=1 then '소계'
          when grouping(job)=0 then job
        end job, deptno,
        SUM(sal+NVL(comm, 0)) sal_sum
FROM emp
GROUP BY ROLLUP (job, deptno);


-- group_ad3

SELECT deptno, job, SUM(sal+NVL(comm, 0)) sal_sum
FROM emp
GROUP BY ROLLUP (deptno, job);


-- group_ad4

SELECT dname, job, SUM(sal+NVL(comm, 0)) sal_sum
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job)
ORDER BY dname, sal_sum desc;


-- group_ad5

SELECT DECODE(dname, null, '총합', dname) dname,
       job, SUM(sal+NVL(comm, 0)) sal_sum
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job)
ORDER BY dname, sal_sum desc;


-- 선생님의 group_ad4,5
SELECT NVL(dept.dname, '총계') dname, a.job, a.sal_sum
FROM
    (SELECT deptno, job, SUM(sal+NVL(comm, 0)) sal_sum
    FROM emp
    GROUP BY ROLLUP (deptno, job)) A, dept
WHERE a.deptno = dept.deptno(+);

