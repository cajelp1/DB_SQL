
-- 제약조건 활성화 / 비활성화
-- ALTER TABLE 테이블명 ENABLE OR DISABLE CONSTRAINT 제약조건


SELECT *
FROM USER_TABLES;

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name='DEPT_TEST'; --테이블이름 대문자 주의

ALTER TABLE dept_test DISABLE CONSTRAINT SYS_C007102;

SELECT *
FROM dept_test;

-- dept_test 테이블의 deptno 컬럼에 적용된 primary key 제약조건을
-- 비활성화하여 동일한 부서번호를 갖는 데이터를 입력할 수 있다
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (99, 'DDIT', '대전');


-- dept_test 테이블의 primary key 제약조건 활성화
-- 이미 위에서 실행한 두개의 INSERT 구문에 의해
-- 같은 부서번호를 갖는 데이터가 존재하기 때문에 primary key 제약조건을
-- 활성화 할 수 없다. 활성화하려면 중복데이터를 삭제해야한다.

-- 제약조건 활성화
ALTER TABLE dept_test ENABLE CONSTRAINT SYS_C007102;

-- 중복 데이터 검색
-- 해당 데이터에 대해 수정 후 PRIMARY KEY 제약조건을 활성화 할 수 잇음
SELECT deptno, count(*)
FROM dept_test
GROUP BY deptno
HAVING COUNT(*) >=2;


-- 제약조건 확인
SELECT *
FROM user_constraints
WHERE table_name = 'BUYER';

SELECT *
FROM user_cons_columns --이게 무슨 의미지?
WHERE table_name='BUYER';

-- table_name, constraint_name, column name
-- postion asc
SELECT table_name, constraint_name, column_name
FROM user_cons_columns
WHERE table_name='BUYER'
ORDER BY POSITION;


-- 테이블에 대한 설명 (주석) VIEW
SELECT *
FROM user_tab_comments;

-- 테이블 주석
-- COMMENT ON TABLE 테이블명 IS '주석';
COMMENT ON TABLE dept IS '부서';

-- 컬럼 주석
-- COMMENT ON COLUMN 테이블명, 컬럼명 IS '주석';
COMMENT ON COLUMN dept.deptno IS '부서번호';
COMMENT ON COLUMN dept.dname IS '부서명';
COMMENT ON COLUMN dept.loc IS '부서위치지역';

SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'DEPT';


--------- comment 1
SELECT a.table_name, table_type, a.comments tab_comment, 
       b.column_name, b.comments col_comment
FROM user_tab_comments a, user_col_comments b
WHERE a.table_name = b.table_name --어차피 교집합이라 상관없는건가?
AND a.table_name IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY'); ---대문자아ㅏㅏ아아ㅏㅇ
-- ㅠㅠㅠ 엄청 헤맸네... 그래도 다음엔 더 빨리 할 수 있을거임! 연습할거임!!!!


SELECT *
FROM user_col_comments;
SELECT *
FROM user_tab_comments;


-- VIEW : QUERY 이다 (O)
-- 논리적 데이터 셋 = QUERY
-- 테이블처럼 데이터가 물리적으로 존재하는 것이 아니다.
-- VIEW : 테이블이다 (X) (가상테이블임)

-- VIEW 생성
-- CREATE OR REPLACE VIEW 뷰이름 [(컬럼별칭1, 컬럼별칭2...)] AS
-- SUBQUERY

-- empt 테이블에서 sal, comm 컬럼을 제외한 
-- 나머지 6개 컬럼만 조회가 되는 view
-- v_emp 이름으로 생성
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr hiredate, deptno
FROM emp;

-- 근데 안됨! 왜? insufficient privilage! 권한이 읎대!
-- SYSTEM 계정에서 VIEW는 작업함. 고로... 시스템 계정에 가서
-- 아래 쿼리를 작성
GRANT CREATE VIEW TO PC20;
-- 위의 v_emp 생성쿼리 다시 실행


-- view로 데이터 조회
SELECT *
FROM emp;

-- INLINE VIEW 형태로 쓰면
SELECT *
FROM (SELECT empno, ename, job, mgr hiredate, deptno
      FROM emp);
-- 얘는 쿼리를 가져가려면 다 복사해야하 함. 하지만 VIEW는 훨씬 활용이 간편


-- EMP 테이블을 수정하면 VIEW에 영향이 있을까?
-- KING의 부서번호가 현재 1-번
-- EMP 테이블의 KING 부서번호 데이터를 30번으로 수정 (COMMIT하지 말고)
-- v_emp 테이블에서 king의 부서번호 관찰

UPDATE emp SET deptno=30 WHERE ename='KING';
SELECT * FROM emp WHERE ename = 'KING';
ROLLBACK;

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- emp 테이블에서 king 데이터 삭제 (commit 하지 말 것)
DELETE emp WHERE ename='KING';
SELECT * FROM EMP WHERE ENAME='KING';

-- emp 테이블에서 KING 데이터 삭제 후 v_emp_view의 조회 결과 확인
SELECT *
FROM v_emp_dept;


ROLLBACK;


-- emp 테이블의 empno 컬럼을 eno로 컬럼이름 변경
ALTER TABLE emp RENAME COLUMN empno TO eno;
ALTER TABLE emp RENAME COLUMN eno TO empno;

SELECT *
FROM v_emp_dept; -- 원본 테이블의 컬럼에 변화가 생기면 뷰는 깨진다


-- view 삭제
-- v_emp 삭제
DROP VIEW v_emp;


-- 부서별 직원의 급여 합계
-- 를 뷰로 만들어보자
CREATE OR REPLACE VIEW v_emp_sal AS
SELECT deptno, SUM(sal) sum_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM v_emp_sal
WHERE deptno=20;



-- SEQUENCE
-- 오라클 객체로 중복되지 않는 정수 값을 리턴해주는 객체
-- CREATE SEQUENCE 시퀀스명
-- [옵션...]

CREATE SEQUENCE seq_board; -- 왜 replace는 안돼죠?
-- order?

-- 시퀀스 사용방법 : 시퀀스명.nextval
SELECT seq_board.nextval
FROM dual; --절대 중복되는 값을 리턴하지 않음. 
-- isolation level과 상관없이? 싱기하네. 메모리랑 디스크 막 얘기하셨는지 뭔지 모르겟다 ㅋ

SELECT seq_board.currval
FROM dual; 


ALTER SEQUENCE seq_board CACHE 10; 
--> 시퀀스 번호는 못 바꿈. 다른 옵션들만 바꾸는거...


--- index
SELECT ROWID, ROWNUM, EMP.*
FROM emp;


-- emp 테이블 empno 컬럼으로 primary key 제약생성 : pk_emp
-- dept 테이블 deptno 컬럼으로 primary key 제약생성 : pk_dept
-- emp 테이블의 deptno 컬럼이 dept 테이블의 deptno 컬럼을 참조하도록
-- FOREGITN KEY 제약추가 : fk_dept_deptno

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT fk_dept_deptno FOREIGN KEY (deptno)
                                REFERENCES dept (deptno);

DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT *
FROM emp_test;

-- emp_test 테이블에는 인데스가 없는 상태
-- 원하는 데이터를 찾기 위해서는 테이블의 데이터를 모두 읽어봐야 한다
EXPLAIN PLAN FOR
SELECT *
FROM emp_test
WHERE empno=7369;

SELECT *
FROM table(dbms_xplan.display);

------------------------------------------------------------------------------
| Id  | Operation         | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |          |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP_TEST |     1 |    87 |     3   (0)| 00:00:01 |
------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)



-- 실행계획을 통해 7369 사번을 갖는 직원정보 조회 하기위해 
-- 테이블의 모든 데이터를 읽은 후 7369인 데이터만 선택하여
-- 사용자에게 반환
-- 13건의 데이터를 불필요하게 조회 후 버림

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7369;

SELECT *
FROM table(dbms_xplan.display);


-- 실행계획을 통해 분석을 하면
-- empno가 7369인 직원을 index를 통해 매우 빠르게 접근
-- 같이 저장되어 있는 rowid 값을 통해 table에 접근한다.
-- table에서 읽은 데이터는 7369사번 데이터 한건만 조회하고
-- 나머지 13건에 대해서는 읽지 않고 처리

Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    87 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    87 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7369) -- access는 접속. 위의 filter는 전부 보고 골라낸거.


--rowid를 알면...
SELECT *
FROM emp
WHERE rowid = '상당히 긴 문자열';
-- 실행계획을 보면 바로 rowid를 찾아감















