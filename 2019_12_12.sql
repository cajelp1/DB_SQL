

-- 별칭 : 테이블, 컬럼을 다른 이름으로 저장
--   [AS] 별칭명
-- SELECT empno [AS] eno
-- FROM emp e

-- SYNONYM (동의어)
-- 오라클 객체를 다른 이름으로 부를 수 있도록 하는 것
-- 만약에 emp 테이블을 e 라고 하는 syononym



-- 권한이 읎다... system에 가쟈....
-- PC20에 생성권한 부여
GRANT CREATE SYNONYM TO PC20;



-- emp 테이블의 synonym e 생성
-- CREATE SYONOYM 이름 FOR 오라클객체
CREATE SYNONYM e FOR emp;


-- emp라는 테이블 명 대신에 e라고 하는 synonym을 사용하여 쿼리를 작성
SELECT *
FROM e;


-- pc20 계정의 fastfood 테이블을 hr 계정에서도 볼 수 있도록
-- 테이블 조회 권한을 부여

GRANT SELECT ON fastfood TO hr;

/*
- grant.. ppt 122는 자주 씀. 비밀번호 변경

- 오라클은 스키마와 사용자계정이 붙어있다는 느낌
- grant 권한명 to 사용자명
- revoke 권한명 from 사용자명

- pt 127.. 옵션. 권한옵션이라던가. 
*/

SELECT *
FROM user_views;



-- 동일한 SQL의 개념에 따르면 아래 SQL들은 다르다
SELECT /* 201911_205 */ * FROM emp;
SELECT /* 201911_205 */ * FROM EMP;
SELECt /* 201911_205 */ * FROM EMP;

SELECT * FROM emp WHERE empno=7788;
SELECT * FROM emp WHERE empno=7869; --둘은 다른 쿼리로 데이터에 저장됨
SELECT * FROM emp WHERE empno=:empno; --이러면 같은 쿼리로 저장한다
-- 운영은 운영, 개발은 개발. 개발은 편하게 해도 된다
-- 하지만 개발할 때 쓰던 쿼리가 운영으로 오면 안 좋을 수 있음


-- multiple insert
DROP TABLE emp_test;


-- emp 테이블의 empno, ename 컬럼으로 emp_test, emp_test2
-- 테이블을 생성 (CTAS)
CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp;


-- unconditional insert
-- 여러테이블에 데이터를 동시 입력
-- brown, cony 데이터를 emp_test, emp_test2 테이블에 동시 입력
INSERT ALL 
    INTO emp_test
    INTO emp_test2
SELECT 9999, 'brown' FROM dual UNION ALL
SELECT 9998, 'cony' FROM dual;


SELECT *
FROM emp_test2
WHERE empno >9990;

ROLLBACK;


-- 테이블 별 입력되는 데이터의 컬럼을 제어 가능
INSERT ALL 
    INTO emp_test (empno, ename) VALUES (eno, enm)
    INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 9998, 'cony' FROM dual;

ROLLBACK;


-- CONDITIONAL INSERT
-- 조건에 따라 테이블에 데이터를 입력

INSERT ALL
    WHEN eno>9000 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 8998, 'cony' FROM dual;

rollback;


INSERT ALL
    WHEN eno>9000 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    WHEN eno>9500 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 8998, 'cony' FROM dual;
-- 이러면 행이 세번 추가된다. 

rollback;

INSERT FIRST
    WHEN eno>9000 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    WHEN eno>9500 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 8998, 'cony' FROM dual;
-- 이러면 조건에 맞는데가 나오면 끝내고 다음 데이터가 들어갈 곳을 찾는다. 

SELECT *
FROM emp_test2
WHERE empno > 8000;








