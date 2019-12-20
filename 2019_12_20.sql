

-- 어제 한 과제
SELECT empno, ename, b.a, SUM(c.b)
FROM
--    (SELECT aa.*, ROWNUM rn FROM
--        (SELECT empno, ename, sal FROM emp
--         ORDER BY sal, empno) aa) a,          
-- 여기 있는 컬럼을 아래 b에서 다 읽으면 됨
    (SELECT bb.*, ROWNUM rn FROM
         (SELECT sal a, empno, ename FROM emp 
          ORDER BY sal, empno) bb) b,
    (SELECT cc.*, ROWNUM rn FROM
         (SELECT sal b FROM emp 
          ORDER BY sal, empno) cc) c
WHERE b.rn >= c.rn AND a.rn = b.rn
GROUP BY b.rn, empno, ename, b.a
ORDER BY b.rn;



-- hash join
SELECT *
FROM dept, emp
WHERE dept.deptno = emp.deptno;
-- DEPT 먼저 읽는 형태
-- join 컬럼을 hash 함수로 돌려서 해당 해시 함수에 해당하는 bucket에 넣음
-- 10 --> aaabbaa (hashvalue 해시값을? 임의로? 왜????)


-- emp 테이블에 대해 위의 진행을 동일하게 진행함
-- 10 -->c ccc1122 (hashvalue)

-- 대체 해시함수라는게 뭐야....



-- ppt 진행
-- 사원번호, 사원이름, 부서번호, 급여, 부서원의 전체 급여합
SELECT empno, ename, deptno, sal, 
       SUM(sal) OVER() c_sum
FROM emp;

-- 우리가 구하려는건 본인 포함,
-- 본인 급여보다 작은 급여를 받는 사람의 누적 합이다
SELECT empno, ename, deptno, sal, 
       SUM(sal) OVER(ORDER BY sal 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum 
       --가장 처음부터 현재행까지
FROM emp;

-- 근데 안 쓰고도 그냥 오더바이 하면 되는데....?
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER(ORDER BY sal) c_sum
FROM emp;

-- 만약 오더바이 없이 unbounded preceding 만 하면?
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;
-- 오라클이 에러내네... 오더바이랑 함께 쓰이는구나. 
-- 다른거 해보쟈
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER(UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;
-- 이것두 문법오류넹


-- 만약 나랑 내 바로 전 행과의 급여합을 알고싶다면?
-- n PRECEDING, n FOLLOWING
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER(ORDER BY sal
       ROWS BETWEEN 1PRECEDING AND CURRENT ROW) c_sum
FROM emp;
-- 다른 문법 적용 가능?
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER(ORDER BY sal
       ROWS 1PRECEDING) c_sum
FROM emp;
-- 음... BETWEEN 이랑 AND 이후의 부분은 생략 가능하네...


-- ana7
SELECT empno, ename, deptno, sal
        ,SUM(sal) OVER (PARTITION BY deptno ORDER BY sal) c_sum
FROM emp;
-- 움.. 함수 연습이니까 WINDOW함수 추가도 해쥬쟈...
SELECT empno, ename, deptno, sal
        ,SUM(sal) OVER (PARTITION BY deptno ORDER BY sal
         ROWS UNBOUNDED PRECEDING) c_sum
FROM emp;


-- rows와 range 차이
SELECT empno, ename, deptno, sal
    ,SUM(sal) OVER (ORDER BY sal) s_sum     
    -- 아항.. 아무것도 안쓰면 rows가 아니라 range가 적용되네
    ,SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum
    ,SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum
    ,SUM(sal) OVER (ORDER BY sal RANGE 
    BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) bt_range
    --RANGE는 between 을 써도 그냥 그렇네... 이유눈?
FROM emp;
-- range는 걍 무조건 같은 값을 하나로 보기 때문...!!!!!


/*
-------------PL/SQL--------------
기본구조 :
    DECLARE : 선언부, 변수를 선언하는 부분
    BEGIN : PL/SQL의 로직이 들어가는 부분
    EXCEPTION : 예외처리부
*/

-- 1. DBMS_OUTPUT.PUT_LINE 함수가 출력하는 결과를
--    화면에 보여주도록 활성화
SET SERVEROUTPUT ON ;


DECLARE --선언부
    -- java : 타입 변수명;
    -- pl/sql : 변수명 타입;
    v_dname VARCHAR2(14);
    v_loc VARCHAR2(13);
BEGIN -- 내용시작
    -- DEPT 테이블에서 10번 부서의 부서이름, LOC정보를 조회
    SELECT dname, loc
    INTO v_dname, v_loc
    FROM dept
    WHERE deptno = 10;
    
    -- System.out.println(a+b) ..자바 문자열 결합은 +
    -- pl/sql은 ||을 사용
    DBMS_OUTPUT.PUT_LINE(v_dname || v_loc);

END;
/ 
--요 슬래시는 PL/SQL 블록을 실행하라는 명령어. 옆에 주석이 붙으면
--          컴파일 에러가 뜸...
--처리부는 생략

-- 현재 우리가 만든건 Anonymous block.


-- 기존 컬럼의 타입이 바뀔 수 있다. 그럴 때를 위해 레퍼런스 타입으로 선언
SET SERVEROUTPUT ON ;

DECLARE 
    v_dname dept.dname %TYPE;
    v_loc dept.loc %TYPE;
BEGIN 
    SELECT dname, loc
    INTO v_dname, v_loc
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dname || v_loc);
END;
/ 


-- anonymous 블록 말고 procedure 블록을 만들어보쟈
PROCEDURE name IS 
(IN param OUT param IN OUT param);

-- 10번 부서의 부서이름, 위치지역을 조회해서 변수에 담고
-- 변수를 DBMS_OUTPUT.PUT_LINE 함수로 콘솔에 출력
CREATE OR REPLACE PROCEDURE printdept IS
    -- 선언부
    dname dept.dname %TYPE;
    loc dept.loc %TYPE;
    -- 실행부
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = 10;
    DBMS_OUTPUT.PUT_LINE (dname||' '||loc);
    -- 예외처리부(옵션)
END;
/


exec printdept;


-- 현재까지 쿼리는 10이라는 값이 고정되어 있는데 얘를 PARAM으로 받으면?

CREATE OR REPLACE PROCEDURE printdept 
-- 파라미터명 IN/OUT 타입
-- p_
(p_deptno IN dept.deptno%TYPE)
IS
    dname dept.dname %TYPE;
    loc dept.loc %TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;    -- 이 부분이 바뀜
    DBMS_OUTPUT.PUT_LINE (dname||' '||loc);
END;
/

exec printdept(50);

select *
from emp;


-- 실습 pro_1
CREATE OR REPLACE PROCEDURE printemp
(e_empno IN emp.empno%TYPE) IS
    ename emp.ename%TYPE;
    dname dept.dname%TYPE;
BEGIN SELECT e.ename, d.dname
      INTO ename, dname
      FROM emp e, dept d
      WHERE e.deptno = d.deptno
      AND e.empno = e_empno;    --돌겟네 ㅡㅡ 이 변수 이름 왜 바꿔야함?
      DBMS_OUTPUT.PUT_LINE(ename||'   '||dname);
END;
/
exec printemp(7788);



SELECT *
FROM dept_test;

-- insert 구문을 pl/sql로 넣는다. 근데 commit도 같이 넣어줘야함
CREATE OR REPLACE PROCEDURE registdept_test
(d_deptno IN dept_test.deptno%TYPE,
 d_dname IN dept_test.dname%TYPE,
 d_loc IN dept_test.loc%TYPE) IS
BEGIN   INSERT INTO dept_test 
        VALUES (d_deptno, d_dname, d_loc);
        COMMIT;
END;
/

exec registdept_test(99, 'ddit', 'daejeon');
SELECT *
FROM dept_test;

INSERT INTO dept_test VALUES (1, 'ASDF', 'ASDFASDF);
-- insert를 해도 commit을 안 하면 표시가 안된댜에요... ㅠㅠ






