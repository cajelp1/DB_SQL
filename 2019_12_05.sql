

-- sub4

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

-- 직원이 속하지 않는 부서를 조회하는 쿼리를 작성하라

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno 
                     FROM emp );

SELECT *
FROM dept, emp
WHERE dept.deptno = emp.deptno(+)
AND emp.ename IS NULL;


-- SUB5
SELECT *
FROM product p
WHERE p.pid NOT IN (SELECT cycle.pid
                    FROM cycle, customer
                    WHERE cycle.cid = customer.cid 
                    AND cycle.cid =1);

SELECT *
FROM product p
WHERE p.pid NOT IN (SELECT pid
                    FROM cycle
                    WHERE cid =1);


-- SUB6
-- cid=2인 고객이 애음하는 제품 중 (cid=1인 고객이 애음하는 제품의) 애음정보 조회
select*
from
    (SELECT *
    FROM cycle
    WHERE cid=1)a
,
    (SELECT distinct pid
    FROM cycle
    WHERE cid =2)b
WHERE a.pid=b.pid;
-- 이건 왜 두번씩 나와????
-- cross join 하고 거기서 교집합 찾는거라서!


SELECT *
FROM cycle c
WHERE cid=1 AND pid=(SELECT pid
                    FROM cycle cy
                    WHERE cy.cid=2 and c.pid = cy.pid);
-- 아뉘이 어떠케 참조를 넣지???


SELECT *
FROM cycle
WHERE cid=1 
AND pid in (SELECT pid
            FROM cycle
            WHERE cid =2);
-- 와 망할... in 을 쓰면 되는거였ㅇ어.....



-- sub7
SELECT *
FROM customer, product, cycle
WHERE cycle.cid = customer.cid
AND cycle.pid = product.pid
AND cycle.cid=1
AND cycle.pid in (SELECT pid
                  FROM cycle
                  WHERE cid =2);


--매니저가 존재하는 직원 정보 조회
SELECT *
FROM emp e
WHERE EXISTS (SELECT 1 FROM emp m WHERE m.empno = e.mgr);


-- SUB8
-- null 쓰기
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- 조인해서 null인 애는 없애기
SELECT e.*
FROM emp e, emp m
WHERE e.mgr = m.empno;


--SUB9,10
SELECT *
FROM product
WHERE NOT EXISTS (SELECT pid FROM cycle 
                  WHERE (cid=1 and cycle.pid=product.pid));

SELECT *
FROM product
WHERE EXISTS (SELECT pid FROM cycle where cid=1 );


-- 집합연산
-- UNION : 합집합. 두 집합의 중복건은 제거한다
-- 담당업무가 SALESMAN인 직원의 직원번호, 직원이름 조회
-- 위아래 결과셋이 동일하기 때문에 합집합 연산을 하게 될 경우
-- 중복되는 데이터는 한번만 표현한다.

SELECT empno, ename
FROM emp
WHERE job='SALESMAN'

UNION

SELECT empno, ename
FROM emp
WHERE job='CLERK';


-- UNION ALL
-- 합집합 연산시 중복 제거를 하지 않는다
-- 위아래 결과 셋을 붙여 주기만 한다.

SELECT empno, ename
FROM emp
WHERE job='SALESMAN'

UNION ALL

SELECT empno, ename
FROM emp
WHERE job='SALESMAN';


-- 집합연산시 집합셋의 컬럼이 동일 해야한다.
SELECT empno, ename, null
FROM emp
WHERE job='SALESMAN'

UNION

SELECT empno, ename, job
FROM emp
WHERE job='CLERK';


-- INTERSECT : 교집합
-- 공통된 데이터만 조회
SELECT empno, job --집합 후 결과물은 위 테이블의 컬럼명이 붙는다
FROM emp
WHERE job='SALESMAN'

INTERSECT

SELECT empno, ename
FROM emp
WHERE job='SALESMAN';


-- MINUS
-- 차집합 : 위, 아래 집합의 교집합을 위 집합에서 제거한 집합을 조회
-- 차집합의 경우 합집합, 교집합과 다르게 
-- 집합의 선언 순서가 결과 집합에 영향을 준다.


SELECT empno, ename
FROM
    (SELECT empno, ename
    FROM emp
    WHERE job IN('SALESMAN','CLERK')
    ORDER BY JOB)

UNION

SELECT empno, ename
FROM emp
WHERE job='CLERK'
ORDER BY 2; -- 왜 컬럼명을 기재하면 오더바이가 안 먹히지??


-- OUTER JOIN과 집합


-- DML
-- INSERT : 테이블에 새로운 데이터 입력


DELETE dept
WHERE deptno=99;

SELECT *
FROM dept;
commit;

-- INSERT 시 컬럼을 나열한 경우
-- 나열한 컬럼에 맞춰 입력할 값을 동일한 순서로 기술한다
-- INSERT INTO 테이블명 (컬럽1, 컬럼2...)
--             VALUES (값1, 값2...._
-- dept 테이블에 99번 부서번호, ddit 조직명, daejeon 지역명을 갖는 데이터 입력
INSERT INTO dept (deptno, dname, loc)
                VALUES (99, 'ddit', 'daejeon');

-- 컬럼을 기술할 경우 테이블의 컬럼 정의 순서와 다르게 나열해도 상관이 없다
-- dept 테이블의 컬럼 순서 : deptno, dname, location
INSERT INTO dept (loc, deptno, dname)
                VALUES ('daejeon', 99, 'ddit');
                
-- 컬럼을 기술하지 않은 경우, 테이블의 컬럼 정의 순서에 맞춰 값을 기술한다
DESC dept;
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

rollback;

SELECT *
FROM dept;



-- 날짜 값 입력하기
-- 1. SYSDATE
-- 2. 사용자로부터 받은 문자열을 DATE타입으로 변경하여 입력
DESC emp;
INSERT INTO emp VALUES (9998, 'sally', 'SALESMAN', 
                        NULL, SYSDATE, 500, NULL, NULL);

SELECT *
FROM emp;

-- 2019년 12월 2일 입사
INSERT INTO emp VALUES (9997, 'james', 'CLERK', 
NULL, TO_DATE(20191202, 'YYYYMMDD'), 500, NULL, NULL);

ROLLBACK;


-- 여러 건의 데이터를 한번에 입력
-- SELECT 결과를 테이블에 입력 할 수 있다.
INSERT INTO emp
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 500, NULL, NULL
FROM dual
UNION ALL
SELECT 9997, 'james', 'CLERK', NULL, TO_DATE(20191202, 'YYYYMMDD')
,500, NULL, NULL
FROM dual;


