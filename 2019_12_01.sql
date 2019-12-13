

-- OUTER join : join 연결에 실패하더라도 기준이 되는 테이블의 데이터는 나오도록?
-- LEFT OUTER JOIN : 테이블1 LEFT OUTER JOIN 테이블2
-- 테이블1과 테이블2를 조인할 때 조인에 실패하더라도 테이블1 쪽의 데이터는 조회 되도록.

-- 조인에 실패한 행ROW에서 테이블2의 컬럼값은 존재하지 않으므로 NULL로 표시된다.


-- ANSI
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
     ON (e.mgr = m.empno AND m.deptno=10);

SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
     ON (e.mgr = m.empno)
WHERE m.depno=10;


-- ORACLE outer join syntax
-- 일반 조인과 차이점은 컬럼명에 (+) 표시.
-- 데이터가 존재하지 않는데 나와야하는 컬럼에 (+) 표시.
-- 직원 LEFT OUTER JOIN 매니저
-- ON (직원.매니저번호 = 매니저.직원번호)


-- ORACLE OUTER
-- WHERE 직원.매니저번호 = 매니저.직원번호(+) -- 매니저쪽 데이터가 존재하지 않음.
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e , emp m
WHERE e.mgr = m.empno(+);


--매니저 부서번호 제한
-- ANSI SQL WHERE 절에 기술한 형태
-- --> OUTER JOIN이 적용되지 않은 상황
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e , emp m
WHERE e.mgr = m.empno(+) 
AND m.deptno=10;


-- 아우터 조인이 적용되어야 하는 테이블의 모든 컬럼에 (+)가 붙어야 한다.
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e , emp m
WHERE e.mgr = m.empno(+) 
AND m.deptno(+)=10;


EXPLAIN PLAN FOR
-- emp 테이블에는 14명의 직원이 있고 10,20,30 부서 중 한 부서에 속한다.
-- 하지만 dept테이블에는 10, 20, 30, 40 이 존재
-- 부서번호, 부서명, 해당부서에 속한 직원수가 나오도록 쿼리를 작성
SELECT dept.deptno, dept.dname, COUNT(emp.deptno)--왜 NULL은 0으로 바꿔?
FROM dept LEFT OUTER JOIN emp ON (dept.deptno = emp.deptno)
GROUP BY dept.deptno, dept.dname
ORDER BY dept.deptno;

SELECT *
FROM TABLE (dbms_xplan.display);



-- ORACLE로 작성
SELECT dept.deptno, dept.dname, COUNT(emp.deptno) --여기는 + 안 붙여도 되네? 짲응
FROM dept, emp
WHERE dept.deptno = emp.deptno(+)
GROUP BY dept.deptno, dept.dname
ORDER BY dept.deptno;


-- 선생님과 함께 실습
SELECT dept.deptno, dname, NVL(cnt,0)
FROM dept,
    (SELECT deptno, count(*) cnt
     FROM emp
     GROUP BY deptno)emp_cnt
WHERE dept.deptno = emp_cnt.deptno(+);

SELECT dept.deptno, dname, NVL(cnt,0)
FROM dept LEFT OUTER JOIN 
    (SELECT deptno, count(*) cnt
     FROM emp
     GROUP BY deptno)emp_cnt
ON (dept.deptno = emp_cnt.deptno);


-- RIGHT OUTER JOIN
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m
     ON (e.mgr = m.empno);


-- FULL OUTER : LEFT OUTER + RIGHT OUTER - 중복데이터 한 건만 남기기
SELECT *
FROM BUYPROD
WHERE buy_date=TO_DATE('050125','YYMMDD');


-- OUTERJOIN 1
SELECT buy_date, buy_prod, prod.prod_id, prod_name, buy_qty
FROM PROD LEFT OUTER JOIN BUYPROD 
     ON (prod.prod_id = buyprod.buy_prod AND buy_date=TO_DATE('050125','YYMMDD'));


-- OUTERJOIN 2
SELECT NVL(buy_date,TO_DATE('050125','YYMMDD')) buy_date
     , buy_prod, prod.prod_id, prod_name, buy_qty
FROM PROD LEFT OUTER JOIN BUYPROD 
     ON (prod.prod_id = buyprod.buy_prod AND buy_date=TO_DATE('050125','YYMMDD'));


-- OUTERJOIN 3
SELECT NVL(buy_date,TO_DATE('050125','YYMMDD')) buy_date
     , buy_prod, prod.prod_id, prod_name
     , NVL(buy_qty,0)
FROM PROD LEFT OUTER JOIN BUYPROD 
     ON (prod.prod_id = buyprod.buy_prod AND buy_date=TO_DATE('050125','YYMMDD'));


-- OUTERJOIN 4
SELECT *
FROM cycle;
SELECT *
FROM product;

SELECT product.pid, pnm
     , NVL(cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt 
FROM product LEFT OUTER JOIN
    (SELECT *
     FROM cycle
     WHERE CID = 1) one ON (product.pid = one.pid);


-- OUTERJOIN 5
SELECT product.pid, pnm
     , NVL(cid,1) cid, NVL(cnm, 'brown') cnm
     , NVL(day,0) day, NVL(cnt,0) cnt 
FROM product LEFT OUTER JOIN
(SELECT cycle.cid, cnm, pid, day, cnt
FROM cycle, customer
WHERE cycle.cid = customer.cid AND cycle.cid = 1) one
ON (product.pid = one.pid)
ORDER BY pid DESC, day DESC;


-- nvl(brown) 없이?
SELECT two.pid, pnm, customer.cid, cnm, day, cnt
FROM customer join 
    (SELECT product.pid, pnm
     , NVL(cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt 
     FROM product LEFT OUTER JOIN
        (SELECT *
         FROM cycle
         WHERE CID = 1) one ON (product.pid = one.pid)) two
     ON (two.cid = customer.cid)
ORDER BY pid DESC, day DESC;


---- 김경운씨 카테션 조인. 크로스 조인
SELECT p.pid pid ,p.PNM pnm,NVL(c.cid,1) cid ,cu.CNM CNM,NVL(c.day,0) day ,NVL(c.cnt,0) cnt
FROM     CUSTOMER cu,CYCLE c RIGHT OUTER JOIN PRODUCT p
ON  (c.PID=p.PID AND c.CID=1)
WHERE cu.CNM='brown';


