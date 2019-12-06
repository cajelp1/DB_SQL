
SELECT *
FROM dept;

-- dept 테이블에 부서번호 99, 부서명 ddit, 위치 daejeon

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;


-- UPDATE : 테이블에 저장된 컬럼의 값을 변경
-- UPDATE 테이블명 SET 컬럼명1 = 적용하려고 하는 값1, 컬럼명2=적용값2...
-- [WHERE row 조회 조건]


-- 부서번호가 99번인 부서의 부서명을 대덕IT로, 지역을 영민빌딩으로 변경
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99;

-- 업데이트 전에 업데이트 하려고 하는 테이블을 WHERE절에 기술한 조건으로
-- SELECT 를 하여 업데이트 대상 ROW를 확인해보자
SELECT *
FROM dept
WHERE deptno = 99;


-- 다음 QUERY를 실행하면 WHERE 절에 ROW 제한 조건이 없기 때문에 
-- dept 테이블의 모든 행에 대해 부서명, 위치 정보를 수정한다. 
UPDATE dept SET dname = '대덕IT', LOC = '영민빌딩';



-- SUBQUERY 를 이용한 UPDATE
-- emp 테이블에 신규 데이터 입력
-- 사원번호 9999, 사원이름 BROWN, 업무 NULL
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');
SELECT *
FROM emp;
commit;


-- 사원번호가 9999인 사원의 소속 부서와 담당업무를 SMITH 사원의 부서, 업무로 업데이트
UPDATE emp SET deptno=(SELECT deptno FROM emp WHERE ename='SMITH'),
               job=(SELECT job FROM emp WHERE ename='SMITH')
WHERE empno=9999;
rollback;

SELECT *
FROM emp
WHERE empno = 9999;


-- DELETE : 조건에 해당하는 ROW를 삭제
-- 컬럼의 값을 삭제? NULL로 변경? --> UPDATE를 사용하라.
-- DELETE의 중요한 점은 ROW!!!!!!!!!!!!!! 를 삭제한다는 것.

-- DELETE 테이블명 [WHERE 조건]

-- UPDATE쿼리와 마찬가지로 DELETE 쿼리 실행전에는 
-- 해당 테이블을 WHERE조건을 동일하게 하여 SELECT를 실행.
-- 삭제될 ROW를 먼저 확인해보자.

-- emp 테이블에 존재하는 사원번호 9999인 사원을 삭제 
DELETE emp
WHERE empno=9999;
COMMIT;

SELECT *
FROM emp
WHERE empno = 9999;


-- 매니저가 7698 empno 인 사원 모두 삭제
SELECT *
FROM emp
WHERE mgr = 7698;

--DELETE *
--WHERE mgr = 7698;?

DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);
ROLLBACK;


-- 읽기 일관성 (ISOLATION LEVEL)
-- LOCK과 관련.
-- DML문이 다른 사용자에게 어떻게 영향을 미치는지 정의한 레벨(0~3)

-- LV0
-- COMMIT 안 한 데이터도 다른 트랜젝션에서 읽음
-- ORACLE에는 없는 기능

-- LV1
-- COMMIT 한 데이터를 다른 트랜젝션에서 읽음

-- LV2
-- 읽은 데이터 LOCK. 
-- 다른 트랜젝션에서 수정을 못하기 때문에 한 트랜젝션에서 해당 ROW는
-- 항상 동일한 결과값으로 조회 할 수 있다.
-- (근데 INSERT는 되네....)
-- ORACLE에서 지원하지 않지만 FOR UPDATE 구문을 통해 같은? 효과를 낼 수 있다.

-- LV3
-- SERIALIZABLE READ
-- 트랜젝션의 데이터 조회 기준이 트랜젝션 시작 시점으로 맞춰진다. 
-- 후행 트랜젝션에서 데이터를 신규 입력, 수정, 삭제 후 COMMIT해도
-- 선행 트랜젝션에서는 해당 데이터를 보지 않는다. 


-- 트랜젝션 레벨 수정 (serializable read)
-- SET TRANSACTION isolation LEVEL serializable;


-- DML? DDL? DCL? TCL?


-- DDL : TABLE 생성
-- CREATE TABLE [사용자명.] 테이블명(
--        컬럼명1 컬럼타입1, 
--        컬럼명2 컬럼타입2, ...
--        컬럼명N 컬럼타입N);

-- 테이블 생성 DDL : Data Defination Language (데이터 정의어)
-- DDL 은 rollback이 없다. (자동커밋 되므로 rollback을 쓸 수 없다.)
CREATE TABLE ranger(
    ranger_no NUMBER,               --레인저 번호
    ranger_nm VARCHAR2(50),         --레인저 이름
    reg_dt DATE default SYSDATE     --레인저 등록일자
);


SELECT *
FROM user_tables
WHERE table_name = 'RANGER'; 
-- 오라클에서는 객체 생성시 소문자로 생성하더라도
-- 내부적으로는 대문자로 관리한다



INSERT INTO ranger VALUES(1,'brown', sysdate);
SELECT *
FROM ranger;

-- DML문은 DDL과 다르게 ROLLBACK이 가능하다


DESC emp;


-- DATE 타입에서 필드 추출하지
-- EXTRACT (필드명 FROM 컬럼/expression)
SELECT TO_CHAR(sysdate,'YYYY')      -- 얘는 문자열
      ,EXTRACT(year FROM SYSDATE)   -- 얘는 숫자
FROM dual;


-- 제약조건
-- NOT NULL, UNIQUE(NULL값 여러개 기재 가능), PRIMARY KEY...


CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

SELECT *
FROM dept_test;
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);


-- dept_test 테이블의 deptno 컬럼에 PRIMARY KEY 제약조건이 있기 때문에
-- deptno가 동일한 데이터를 입력하거나 수정할 수 없다. 
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon'); --입력성공
INSERT INTO dept_test VALUES(99, '대덕', '대전'); --입력실패. 99가 이미 있음.
-- ORA-00001: unique constraint (PC20.SYS_C007092) violated
-- SYS_C007092 라는 이름은 알아보기 힘들기 때문에 
-- 제약조건에 코읻룰을 따른 이름을 붙이는게 유지보수에 편함.


-- 테이블 삭제 후 제약조건 재 생성
-- PRIMARY KEY : pk_테이블명
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(99, '대덕', '대전');
-- ORA-00001: unique constraint (PC20.PK_DEPT_TEST) violated
-- 제약조건의 이름이 달라짐








