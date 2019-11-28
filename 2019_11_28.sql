

-- emp 테이블, dept 테이블 조인
EXPLAIN PLAN FOR
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno=10;

SELECT *
FROM TABLE (dbms_xplan.display);

Plan hash value: 615168685
 
---------------------------------------------------------------------------
| Id  | Operation          | Name | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |      |    14 |   588 |     7  (15)| 00:00:01 |
|*  1 |  HASH JOIN         |      |    14 |   588 |     7  (15)| 00:00:01 |
|   2 |   TABLE ACCESS FULL| DEPT |     4 |    88 |     3   (0)| 00:00:01 |
|   3 |   TABLE ACCESS FULL| EMP  |    14 |   280 |     3   (0)| 00:00:01 |
---------------------------------------------------------------------------
--읽는 순서는 2-3-1-0
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
 
Note
-----
   - dynamic sampling used for this statement (level=2)



select ename, deptno
from emp;

SELECT deptno, dname
FROM dept;


--natural join : 조인 테이블간 같은 타입, 같은 이름의 컬럼으로
--               같은 값을 가질 경우 조인


DESC emp;
DESC dept;


-- ALTER TABLE emp DROP COLUMN dname;
-- dept와 emp에 같은 이름의 컬럼이 두개 존재하기에 일단 하나를 지움


-- ANSI SQL
SELECT deptno, emp.empno, ename
FROM emp NATURAL JOIN dept;

SELECT deptno, a.empno, ename
FROM emp a NATURAL JOIN dept; --테이블에 별칭 가능

-- Oracle문법
SELECT deptno, emp.empno, ename
FROM emp, dept;
WHERE emp.deptno = dept.deptno;

SELECT a.deptno, a.empno, ename
FROM emp a, dept b
WHERE a.deptno = b.deptno; --여기서도 테이블에 별칭 가능


-- JOIN USING
-- join하려고 하는 테이블 간 동일한 이름의 컬럼이 두개 이상일 때
-- join 컬럼을 하나만 사용하고 싶을 때

-- ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno); -- 조인 된 컬럼이 먼저 표시된다

-- Oracle SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno; --여기서는 deptno는 두번 표시된다.

SELECT *
FROM emp, dept; --카테션?
-- WHERE 1=1; --무슨 뜻이람
--이렇게 되면 4개의 행 x 14개의 행을 곱해서 모든 경우의 수를 출력한다.



-- ANSI JOIN with ON
-- 조인 하고자 하는 테이블의 컬럼 이름이 다를 때
-- 개발자가 조인 조건을 직접 제어할 때



SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);


-- oracle
SELECT *
FROM emp, dept
WHERE emp.dptno = dept.deptno;


-- SELF JOIN : 같은 테이블간 조인
-- emp 테이블간 조인 할만한 사항 : 직원의 관리자 정보 조회
-- 계층구조... 상위나 하위에 해당하는걸 한 테이블에서 관리하는 것.?
SELECT *
FROM emp;



-- 직원의 관리자 정보를 조회
-- 직원이름, 관리자이름
-- mgr 컬럼과 empno를 합칠 수 있을까?
--ANSI
-- 직원 이름, 직원의 상급자 이름, 직원의 상급자의 상급자 이름?
SELECT e.ename, m.ename p, m.empno pp
FROM emp e JOIN emp m ON (e.mgr = m.empno);
-- 이퀄(=) 연산에 부합되지 않는 데이터는 사라짐. King을 제외한 13행만 조회
-- 그럼 NULL은 왜 쓰는거야? ㅡㅡ


SELECT *
FROM emp;


--ORACLE
SELECT o, p, r.ename
FROM 
(SELECT e.ename o, m.ename p, m.mgr pp
FROM emp e, emp m
WHERE e.mgr = m.empno), emp r
WHERE pp = r.empno;


-- 직원이름, 직원의 관리자 이름, 직원의 관리자의 관리자 이름, 관리자의 관리자의 관리자 이름
SELECT e.ename, m.ename, r.ename, p.ename
FROM emp e, emp m, emp r, emp p
WHERE e.mgr = m.empno
AND m.mgr = r.empno
AND r.mgr = p.empno;


-- 여러 테이블을 ANSI JOIN을 이용한 JOIN
SELECT e.ename, m.ename, r.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
           JOIN emp r ON(m.mgr = r.empno);



-- 직원의 이름과, 해당 직원의 관리자 이름을 조회한다
-- 단, 직원의 사번이 7369~7698인 직원을 대상으로 조회

SELECT o.empno, o.ename, t.ename
FROM emp o, emp t
WHERE o.mgr = t.empno
AND o.empno BETWEEN 7369 AND 7698;


-- ANSI
SELECT s.ename, m.ename
FROM emp s JOIN emp m ON(s.mgr = m.empno)
WHERE s.empno BETWEEN 7369 AND 7698;



-- NON-EQUIL JOIN : 조인 조건이 =(equal이 아닌 
-- != , BETWEEN AND

SELECT *
FROM salgrade;


SELECT empno, ename, sal /* 급여 grade */
FROM emp;


SELECT empno, ename, sal, grade, losal, hisal
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;
-- 이퀄 조인이 아니더라도 조인할 수 있는 방법인 것. 

--ANSI로
SELECT empno, ename, sal, grade, losal, hisal
FROM emp JOIN salgrade ON( sal BETWEEN losal AND hisal);




------------------- 실습 join0

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY emp.deptno;

SELECT empno, ename, emp.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno);



----------------------- 실습 JOIN0_1

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno 
AND emp.deptno IN(10,30);


SELECT empno, ename, emp.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
AND emp.deptno IN (10,30);



----------------------- 실습 JOIN0_2
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno 
AND sal > 2500
ORDER BY emp.deptno;


SELECT empno, ename, sal, emp.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
AND sal > 2500;



------------------------------ 실습 0_3
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno 
AND sal > 2500
AND empno>7600
ORDER BY emp.deptno;





---------------------------- 실습 0_4
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno 
AND sal > 2500
AND empno>7600
AND dname = 'RESEARCH';





-------------------------------- 실습 JOIN1
SELECT prod_lgu
FROM prod;
SELECT lprod_gu
FROM lprod;

DESC prod;
DESC lprod;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM lprod, prod
WHERE lprod_gu = prod_lgu;



--------------------------------------------- 실습 join2
DESC buyer;
DESC prod;

SELECT buyer_id
FROM buyer;
SELECT prod_buyer
FROM prod;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE buyer_id = prod_buyer;





----------------------------------------- 실습 join3






