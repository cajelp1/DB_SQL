
select *
from dept_test;


create or replace procedure UPDATEdept_test 
(d_deptno IN dept.deptno %TYPE
,d_dname IN dept.dname %TYPE
,d_loc IN dept.loc %TYPE) IS
BEGIN   UPDATE dept_test SET 
        deptno=d_deptno, dname=d_dname, loc=d_loc
        WHERE deptno=d_deptno;
-- 여기다 commit도 넣는다고? 왜?
END;
/

rollback;
exec UPDATEdept_test(99,'ddit_m', 'daejeon');


/*
- ROWTYPE
- 특정 테이블의 ROW정보를 담을 수 있는 참조 타입
-TYPE : 테이블명, 테이블컬럼명%TYPE
- ROWTYPE : 테이블명%ROWTYPE
*/


DECLARE     
--DEPT 테이블의 ROW 정보를 담을  수 있는 변수선언
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    DBMS_OUTPUT.PUT_LINE ( dept_row.dname||'++'||dept_row.loc);
END;
/
-- 아 왜 또 아먹혀...


SET SERVEROUTPUT on;


/*
- record type : 개발자가 컬럼을 직접 선언하여 
개발에 필요한 type을 생성
- TYPE 타입이름 IS RECORD(
        컬럼1 컬럼2TYPE,
        컬럼2 컬럼2TYPE
  );
- public class
*/
DECLARE
    -- 부서이름, loc 정보를 저장할 수 있는 record type 선언
    TYPE dept_row IS RECORD(
        dname dept.dname%type,
        loc dept.loc%type);
    --TYPE선언이 완료되어 typr을 갖고있는 변수를 생성
    -- java : class 생성 후 해당 class의 인덱스를 생성(new)
    -- plsql 변수 생성 : 변수이름, 변수타입, dname dept.dname%TYPE;
    dept_row_data dept_row;
BEGIN 
    select dname, loc
    into dept_row_data
    from dept
    where deptno = 10;
    DBMS_OUTPUT.PUT_LINE
    (dept_row_data.dname||', '||dept_row_data.loc);
END;
/


-- TABLE TYPE : 여러개의 ROWTYPE을 저장할 수 있는 TYPE
-- col --> row --> table
-- TYPE 테이블타입명 IS TABLE OF 
-- ROWTYPE/RECORD INDEX BY 인덱스타입(BINARY_INTEGER)
-- 숫자 뿐만 아니라 문자열 형태도 가능...
-- 그렇기에 index에 대한 타입을 명시한다.
-- 일반적으로 array(list) 형태인 경우라면 index by binary_integer
-- 을 주로 사용한다.
-- arr(1).name = 'brown'
-- arr('person').name = 'brown'

DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY binary_integer;
    v_dept dept_tab;
BEGIN
    -- 한 row의 값을 변수에 저장 : into
    -- 복수 row의 값을 변수에 저장 : bulk (여러건을 담는다는 의미) COLLECT INTO
    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    --CURSOR
    
    
    FOR i IN 1 .. v_dept.count LOOP --자바에서 for문과 같은 역할
        -- arr[1] --> arr(1)
        DBMS_OUTPUT.PUT_LINE(v_dept(i).deptno);
    END LOOP;
END;
/



/*
- 로직제어 IF
IF condition THEN 
    statement
ELSIF condition THEN 
    statement
ELSE 
    statement 
END IF;
*/

-- PL/SQL if실습
-- 변수 p(number)에 2라는 값을 할당하고
-- if 구문을 통해 p의 값이 1, 2, 그 밖의 값일 때 텍스트 출력
DECLARE
    p NUMBER := 2;  --변수 선언과 할당을 한 문장에서 진행
BEGIN
    -- P := 2;
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('P=1');
    ELSIF p = 2 THEN    -- 자바와 문법이 다르다! else가 아님 els
        DBMS_OUTPUT.PUT_LINE('P=2');
    ELSE 
        DBMS_OUTPUT.PUT_LINE (p);
    END IF;
END;
/



/*
FOR LOOP
- FOR 인덱스변수 IN [REVERSE] START..END LOOP
      반복실행문
- END LOOP;
- 0~5까지 루프 변수를 이요하여 반복문 실행
*/
DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/


-- 1~10 : 55
-- 1~10까지의 합을 loop를 이용하여 계산, 결과를 s_val이라는 변수에 담아
-- DBMS_OUTPUT.PUT_LINE 함수를 통해 화면에 출력

DECLARE
    p NUMBER := 0;  -- 초기화를 해야 아래의 산술연산이 가능함
BEGIN
    FOR i IN 1..10 LOOP
        p := p + i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(p);
END;
/


/*
WHILE
- WHILE contion LOOP
    statement
  END LOOP;
- 0부터 5까지 WHILE 문을 이용하여 출력
*/

DECLARE
    i NUMBER := 0;
BEGIN
    WHILE i<=5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1; -- 빠져나갈 수 있는 이 구문이 없으면 무한루프에 빠짐
    END LOOP;
END;
/


/*
LOOP

- LOOP
    statement;
    EXIT [WHEN condtion]
  END LOOP;
*/

DECLARE
    i NUMBER := 0;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1; 
        EXIT WHEN i>5;
    END LOOP;
END;
/


/*
CURSOR
- 본래는 툴에서 모두 해줘서 우리는 제어하지 않았으나
- PL/SQL에서는 제어 필요
- SQL 실행 절차 : 구분분석, 실제계획 -> 바인드변수 -> 실행 
...결국 FETCH를 컨트롤하는 역할? (50행이 인출되었습니다 라는 그거)

CURSOR : SQL을 개발자가 제어할 수 있는 객체.
(완벽한 사전적 정의라기보다는 이해하기 쉽게 정의하자면 그러함.)

묵시적 : 개발자가 별도의 커서명을 기술하지 않은 형태, ORACLE에서
        자동으로 OPEN, 실행, FETCH, CLOSE를 관리한다.
명시적 : 개발자가 이름을 붙인 커서. 개발자가 직접 제어하며 
        선언, OPEN, FETCH, CLOSE 단계가 존재

CURSOR 커서이름 IS     <커서 선언
    QUERY 
OPEN 커서이름          <커서 OPEN
FETCH 커서이름         <커서 FETCH(행 인출)
    INTO 변수1, 변수2 ... 
CLOSE 커서이름;        <커서 CLOSE
*/

-- 부서 테이블의 모든 행의 부서이름, 위치 지역 정보를 출력
SELECT dname, loc
FROM dept;
-- CURSOR를 이용
DECLARE
    --커서 선언
    CURSOR dept_cursor IS
        SELECT dname, loc
        FROM dept;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    --커서오픈
    OPEN dept_cursor;
    -- SQL%FOUND / SQL%NOTFOUND 로 루프조건을 걸 수 있지 않을까.
    LOOP
        FETCH dept_cursor INTO v_dname, v_loc;
        -- 종료조건 : FETCH할 데이터가 없을 때
        EXIT WHEN dept_cursor%NOTFOUND;
        dbms_output.put_line(v_dname||','||v_loc);
    END LOOP;
    CLOSE dept_cursor;
END;
/
-- 이 경우 커서는 변수 두개만 가져다가 하나씩 메모리에 올림
-- BULK COLLECT 의 경우 테이블 전체를 변수에 넣기 때문에 
-- 만약 테이블 데이터가 만건이면 만건 전체를 메모리에 올림









