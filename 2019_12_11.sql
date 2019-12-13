
-- INDEX만 조회하여 사용자의 요구사항에 만족하는 
-- 데이터를 만들어 낼 수 있는 경우

EXPLAIN PLAN FOR 
SELECT *
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE (dbms_xplan.display);



-- empno 컬럼만 조회하면?
EXPLAIN PLAN FOR 
SELECT empno
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE (dbms_xplan.display);


-- 기존 인덱스 제거
-- pk_emp 제약조건 삭제 -> unique삭제 -> pk_emp 인덱스 삭제
ALTER TABLE emp DROP CONSTRAINT pk_emp;

-- INDEX 종류 (컬럼중복여부)
-- UNIQUE INDEX : 인덱스 컬럼의 값이 중복될 수 없는 인덱스
-- e.g.(emp.empno, dept.deptno)
-- NON-UNIQUE INDEX(dafault) : 인덱스 컬럼 값이 중복될 수 있는 인덱스 
-- e.g.(emp.job)


-- CREATE UNIQUE INDEX idx_n_emp_01 ON emp (empno); 이럼 중복안됨
CREATE INDEX idx_n_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7782;

SELECT*
FROM TABLE(dbms_xplan.display);
-- 인덱스가 바뀌며 INDEX RANGE SCAN 이라고 설명문이 바뀜


--7782가 추가되면?
INSERT INTO emp (empno, ename) VALUES (7782, 'brown');
COMMIT;


-- emp 테이블에 job컬럼으로 non-unique 인덱스 생성
-- 인덱스명 : idx_n_emp_02
CREATE INDEX idx_n_emp_02 ON emp (job);

SELECT job, rowid
FROM emp
ORDER BY job;


-- emp 테이블에는 인덱스가 2개 존재함
-- 1. empno
-- 2. job
-- 접근방법은 대략 5가지...? 흠. 그냥 컬럼을 조회하면 인덱스만 들어가고 끝난다?

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

-- **PPT84 predicate!!!

-- 사원이름에 c 들어가느냐 조건 추가
SELECT *
FROM emp
WHERE job='MANAGER'
AND ename LIKE 'C%'; --> 이것도 대소문자 가린다


-- idx_n_emp_03
-- emp 테이블의 job, ename 컬럼으로 non-unique 인덱스 생성
CREATE INDEX idx_n_emp_03 ON emp (job, ename);
                   --여기서 (job, ename)이랑 (ename, job) 다르다 


-- idx_n_emp_04
CREATE INDEX idx_n_emp_04 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER'
AND ename LIKE 'J%';

SELECT *
FROM TABLE(dbms_xplan.display);


-- JOIN 쿼리에서의 인덱스
-- emp 테이블은 empno 컬럼으로 primary key 제약조건이 존재
-- dept 테이블은 deptno 컬럼으로 primary key 제약조건이 존재
-- emp 테이블은 primary key 제약을 삭제한 상태이므로 재생성
-DELETE emp
WHERE ename = 'brown';
COMMIT;

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
SELECT *
FROM emp;

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);


Plan hash value: 3070176698

----------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |     1 |    63 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |              |       |       |            |          |
|   2 |   NESTED LOOPS                |              |     1 |    63 |     2   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    33 |     1   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     0   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN          | PK_DEPT      |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT         |   409 | 12270 |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")


DROP TABLE dept_test;

-- IDX1
CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1=1;

CREATE UNIQUE INDEX u_deptno ON dept_test (deptno);
CREATE INDEX un_dname ON dept_test(dname);
CREATE INDEX un_deptno_dname ON dept_test (deptno, dname);

DROP INDEX u_deptno;
DROP INDEX un_dname;
DROP INDEX un_deptno_dname;


-- idx3
CREATE INDEX u_emp_deptno ON emp (deptno);

-- idx4
-- emp.deptno
-- dept.deptno









