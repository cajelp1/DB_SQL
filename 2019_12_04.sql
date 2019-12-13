

-- 버거지수 + 인당근로소득 

select f.rank, e.sido, e.sigungu, 도시발전지수, f.sido, f.sigungu, 인당근로소득
from
    (SELECT ROWNUM rank, c.*
    FROM
        (SELECT b.sido sido, b.sigungu sigungu, NVL(round(a.cnt_1/b.cnt_2,1),0) 도시발전지수
        FROM
            (SELECT sido, sigungu, count(sigungu) cnt_1
            FROM fastfood
            WHERE gb IN('버거킹','맥도날드','KFC')
            GROUP BY sido, sigungu) a
        RIGHT OUTER JOIN
            (SELECT sido, sigungu, count(sigungu) cnt_2
            FROM fastfood
            WHERE gb='롯데리아'
            GROUP BY sido, sigungu) b
        ON( a.sigungu=b.sigungu and a.sido=b.sido)
        ORDER BY 도시발전지수 DESC) c) e
right outer JOIN
    (SELECT ROWNUM RANK, d.*
    FROM
        (SELECT sido, sigungu, round(sal/people,1) 인당근로소득
        FROM tax
        ORDER BY (sal/people) DESC, sido) d) f
ON(f.rank = e.rank)
ORDER BY f.rank;



UPDATE tax SET people = 70391
WHERE sido='대전광역시'
AND sigungu = '동구';
COMMIT;



-- 도시발전지수 시도, 시군구와 연말정산 납입금액의 시도, 시군구가 같은 지역끼리 조인?
-- 정렬 순서는 TAX 테이블의 ID 컬럼으로 정렬

select *
from
    (SELECT b.sido sido, b.sigungu sigungu, NVL(round(a.cnt_1/b.cnt_2,1),0) 도시발전지수
    FROM
        (SELECT sido, sigungu, count(sigungu) cnt_1
        FROM fastfood
        WHERE gb IN('버거킹','맥도날드','KFC')
        GROUP BY sido, sigungu) a
    RIGHT OUTER JOIN
        (SELECT sido, sigungu, count(sigungu) cnt_2
        FROM fastfood
        WHERE gb='롯데리아'
        GROUP BY sido, sigungu) b
    ON(a.sigungu=b.sigungu and a.sido=b.sido)) c
RIGHT OUTER JOIN
    (SELECT id, sido, TRIM(sigungu) sigungu, round(sal/people,1) 인당근로소득
    FROM tax) d
ON(d.sido = c.sido AND d.sigungu = c.sigungu)
ORDER BY D.id;



-- SMITH가 속한 부서 찾기 --> 20
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
               FROM emp
               WHERE ename = 'SMITH');

SELECT empno, ename, deptno,
      (SELECT dname FROM dept WHERE dept.deptno=emp.deptno) dname
FROM emp;



-- SCALAR SUBQUERY
-- SELECT 절에 표현된 서브쿼리
-- 한 행, 한 COLUMN을 조회해야 한다.
SELECT empno, ename, deptno,
      (SELECT dname FROM dept WHERE dept.deptno=emp.deptno) dname
FROM emp;
-- 완전 1:1 대응...


SELECT empno, ename, deptno,
      (SELECT dname FROM dept) dname
FROM emp;


-- INLINE VEIW
-- FROM절에 사용되는 서브쿼리

-- SUBQUERY
-- WHERE절에 사용되는 서브쿼리


-- 평균 급여보다 높은 급여를 받는 직원 수를 조회하라 SUB1
SELECT COUNT(sal)
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp);


-- 평균 급여보다 높은 급여를 받는 직원정보를 조회하라 SUB2
SELECT *
FROM emp
where sal > (SELECT AVG(sal) FROM emp);


-- SUB3
-- 1. SMITH, WARD가 속한 부서 조회
-- 2. 1번에 나온 결과값을 이용하여 해당 부서번호에 속하는 직원 조회

desc fastfood;
SELECT *
FROM EMP;

SELECT *
FROM EMP
WHERE DEPTNO IN (SELECT deptno 
                 FROM emp
                 WHERE ename IN('SMITH', 'WARD'));


-- SMITH나 WARD보다 급여가 작은 직원
SELECT *
FROM emp
WHERE sal < any(SELECT sal 
                FROM emp 
                WHERE ename in ('SMITH', 'WARD'));


-- 관리자 역할을 하지 않는 사원 정보 조회
SELECT *
FROM emp -- 사원 정보를 조회 --> 관리자인 사원 조회
WHERE empno IN (SELECT mgr FROM emp);


-- NOT IN NULL 주의사항
SELECT *
FROM emp -- 사원 정보를 조회 --> 관리자가 아닌 사원 조회
WHERE empno NOT IN (SELECT mgr FROM emp);
-- 아무것도 안 나옴....
-- NOT IN의 경우 NULL이 컬럼에 없어야만 제대로 된 결과값이 나온다. 

-- 방법1.
SELECT *
FROM emp -- 사원 정보를 조회 --> 관리자가 아닌 사원 조회
WHERE empno NOT IN (SELECT NVL(mgr,-1) -- MGR 값에 안 올 것 같은 값을 넣어줌
                    FROM emp);

-- 방법2.
SELECT *
FROM emp -- 사원 정보를 조회 --> 관리자가 아닌 사원 조회
WHERE empno NOT IN (SELECT mgr FROM emp WHERE mgr IS NOT NULL); -- NULL 값을 빼버림


-- PAIRWISE 여러 컬럼의 값을 동시에 만족해야하는 경우
-- ALLEN, CLARK의 매니저와 부서번호가 동시에 같은 사원 정보 조회
-- (7698, 30)
-- (7839, 10)

SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));


-- 위의 쿼리를 나눠쓰면?
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN (7499, 7782))
AND deptno IN (SELECT deptno
               FROM emp
               WHERE empno IN (7499, 7782));
-- 결과값이 다름. 



-- 비상호 연관 서브쿼리 non correlated subquery. 
-- 메인쿼리의 컬럼을 서브쿼리에서 사용하지 않는 형태의 서브 쿼리

-- 비상호 연관 서브쿼리의 경우 메인쿼리에서 사용하는 테이블,
-- 서브쿼리 조회 순서를 성능적으로 유리한 쪽으로 판단하여 순서를 결정한다.
-- 메인쿼리의 emp 테이블을 먼저 읽을 수도 있고, 서브쿼리의 emp 테이블을
-- 먼저 읽을 수도 있다. 

-- 비상호 연관 서브쿼리에서 서브쿼리쪽 테이블을 먼저 읽을 때는
-- 서브쿼리가 제공자 역할을 했다 라고 모 도서에서 표현... 
-- 비상호 연관 서브쿼리에서 서브쿼리쪽 테이블을 나중에 읽을 때는
-- 서브쿼리가 확인자 역할을 했다 라고 모 도서에서 표현... 

-- 직원의 급여 평균보다 높은 급여를 받는 직원 정보 조회
-- 직원의 급여 평균

SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp);




-- 상호연관 서브쿼리
-- 속한 부서의 급여평균보다 높은 급여를 받는 직원 조회

SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
             FROM emp
             WHERE deptno = m.deptno); --아니 왜 알리아스를 다르게 하면;;
-- 이 경우엔 서브쿼리를 먼저 읽어서 그런가보눼.. 상호연관은 항상 서브를 먼저 읽나?
-- 놉. 여기서는 메인쿼리와 서브쿼리가 어떤 식으로 연결되어 있는지를 알려야함.
-- 서브쿼리에 있는 애들만 묶으면 아래 WHERE절이 없는 거랑 똑같은 결과 출력.



-- 10번 부서의 급여 평균
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;



--------------------------------------------------------

SELECT NEXT_DAY(SYSDATE, '수요일')
FROM dual;






