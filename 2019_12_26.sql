/*
Exception
- 에러 발생시 프로그램을 종료시키지 않고
- 해당 예외에 대해 다른 로직을 실행시킬 수 있게끔 처리한다

- 예외가 발생했는데 예외처리가 없는 경우 : PL/SQL 블록이 에러와 함께 종료된다
- 여러건의 SELECT 결과가 존재하는 상황에서 스칼라 변수에 값을 넣는 상황
*/


-- EMP테이블에서 사원이름 조회
SET serveroutput ON;
DECLARE
    --사원 이름을 저장할 수 있는 변수
    v_ename emp.ename%TYPE;
BEGIN
    -- WHERE 절이 없어서 스칼라 값이 아니라 여러건이 리턴
    SELECT ename
    INTO v_ename
    FROM emp;
EXCEPTION 
    WHEN too_many_rows THEN
        DBMS_OUTPUT.PUT_LINE('여러건의 select 결과가 존재');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('WHEN OTHERS'); --오라클에서 EXCEPTION을 모두 포함하는 클래스
END;
/



/*
사용자 정의 예외
- 오라클에서 사전에 정의한 예외 이외에도 개발자가 해당 사이트에서 비지니스 로직으로
  정의한 예외를 생성, 사용할 수 있다.
- 예를들어 SELECT 결과가 없는 상황에서 오라클에서는 NO_DATA_FOUND 예외를 던지면
  해당 예외를 잡아 NO_EMP라는 개발자가 정의한 예외로 재정의해 예외를 던질 수 있다.

*/


DECLARE
    -- EMP 테이블의 조회 결과가 없을 때 사용할 사용자 정의 예외
    no_emp EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    -- no_data_found 예외의 경우
    BEGIN -- BEGIN안에도 BEGIN이 올 수 있다
        SELECT ename
        INTO v_ename
        FROM emp
        WHERE empno = 8888;
        EXCEPTION
    WHEN no_data_found THEN 
            -- JAVA에서는 THROW라고 하지만 오라클은 RAISE
            RAISE no_emp;
    END;
EXCEPTION
    WHEN no_emp THEN    --여기서 NO_EMP가 예외를 어떻게 처리할지 재정의
        DBMS_OUTPUT.PUT_LINE('NO_EMP');
END;
/

/*
함수 : 정해진 작업을 수행 후 결과를 돌려주는 이름있는 PL/SQL BLOCK
*/

-- 사번을 입력받아서 해당 직원의 이름을 리턴하는 함수
-- getEmpName(7369) --> SMITH

CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE)
RETURN VARCHAR2 IS 
-- 선언부
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename
    FROM emp
    WHERE empno = p_empno;
    
    return v_ename;
END;
/


SELECT getempname(7369)
FROM dual;

SELECT getempname(empno)
FROM emp;


-- function1
-- 부서번호를 입력하면 해당 부서이름을 리턴

CREATE OR REPLACE FUNCTION getdeptname (d_deptno dept.deptno%TYPE)
RETURN VARCHAR2 IS
    v_dname dept.dname%TYPE;
BEGIN
    SELECT dname
    INTO v_dname
    FROM dept
    WHERE deptno = d_deptno;
    
    return v_dname;
END;
/

SELECT getdeptname(10) --deptno가 정해져 있을때는 dual을 써서 값을 넣고
FROM dual;

SELECT getdeptname(deptno) -- deptno값이 정해지지 않은 상태로
FROM dept;                 -- 테이블을 지정해서 값을 다 볼 수도 있다... 흠

SELECT getdeptname (10)
FROM dept; --엥 accounting만 4번 나오네? 왜 그래? 
-- 테이블에 있는 행만큼 바꿔서 표기하는거?


-- 함수를 쓰는게 조인보다 빠른가? 상황에 따라 다름...
-- cache : 20
-- 데이터 분포도 : 
-- deptno (중복 가능) : 분포도가 좋지 못하다
-- empno (중복이 없다) : 분포도가 좋다

-- emp 테이블의 데이터가 100만건인 경우
-- 100건 중에서 deptno의 종류는 4건(10~40)
SELECT getdeptname(deptno), -- 4가지
       getempname(empno)    -- row 수만큼 데이터가 존재
FROM emp;



--- function2
-- LPAD(' ',(level-1)*4, ' ') 라는 부분을 함수로 만들 수 없을까?
SELECT deptcd, LPAD(' ',(level-1)*4, ' ')||deptnm deptnm
FROM dept_h
START WITH p_deptcd IS NULL
connect by prior deptcd = p_deptcd;


CREATE OR REPLACE FUNCTION indent (INT NUMBER) RETURN
VARCHAR2 IS
    i_level VARCHAR2(100);
BEGIN
    SELECT LPAD(' ',(INT-1)*4,' ')||deptnm
    INTO i_level
    FROM dept_h;
    RETURN i_level;
END;
/
-- 아.. deptnm 이름이 바뀌기 때문에 deptnm을 받아야하나?


CREATE OR REPLACE FUNCTION indent(p_lv NUMBER, p_deptnm VARCHAR2)
RETURN VARCHAR2 IS
    v_dname VARCHAR2(200);
BEGIN
    SELECT LPAD(' ', (p_lv -1 ) * 4, ' ') || p_deptnm
    INTO v_dname
    FROM dual;
    
    RETURN v_dname;
END;
/


SELECT *
FROM dept_h;


SELECT deptcd, indent(level) deptnm
FROM dept_h
START WITH p_deptcd IS NULL
connect by prior deptcd = p_deptcd;



-- package... interface와 비슷한듯 아닌듯한 그런거. 자바 패키지랑 비슷..?



-- trigger

-- users 테이블의 비밀번호 칼럼에 변경이 생겼을 때
-- 기존에 사용하던 비밀번호 컬럼 이력을 관리하기 위한 테이블
CREATE TABLE users_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE
);

CREATE OR REPLACE TRIGGER make_history
    --timing
    BEFORE UPDATE ON users
    FOR EACH ROW -- 행 트리거, 행의 변경이 있을 때마다 실행한다
    -- 현재 데이터 참조 : OLD
    -- 갱신 데이터 참조 : NEW
    BEGIN
        -- users 테이블의 pass 컬럼을 변경할 때 trigger 실행
        IF (:OLD.pass != :NEW.pass) THEN
        INSERT INTO users_history
            VALUES (:OLD.userid, :OLD.pass, SYSDATE);
        END IF;
        -- 다른 컬럼에 대해서는 무시한다
    END;
/


-- USERS 테이블의 PASS 컬럼을 변경했을 때
-- TRIGGER에 의해서 users_history 테이블에 이력이 생성되는지 확인
SELECT *
FROM users_history;
UPDATE users SET pass = '1234'
WHERE userid= 'brown';








