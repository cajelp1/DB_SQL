

-- FOR LOOP에서 명시적 커서 사용하기
-- 부서테이블의 모든 행의 부서이름, 위치지역 정보를 출력 (CURSOR이용)
SET SERVEROUTPUT ON;

DECLARE
    --커서 선언
    CURSOR dept_cursor IS
        SELECT dname, loc
        FROM dept;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    FOR record_row IN dept_cursor LOOP --다른 형태의 for문
        DBMS_OUTPUT.PUT_LINE(record_row.dname||record_row.loc);
    END LOOP;
END;
/



-- 커서에 인자가 들어가는 경우
DECLARE
    --커서 선언
    CURSOR dept_cursor(p_deptno dept.deptno%TYPE) IS
        SELECT dname, loc
        FROM dept
        WHERE deptno = p_deptno; 
        --위에서 인자를 선언해서 서브쿼리에서 인자 사용가능
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    FOR record_row IN dept_cursor(10) LOOP --여기서 인자 값을 넣는다
        DBMS_OUTPUT.PUT_LINE(record_row.dname||record_row.loc);
    END LOOP;
END;
/


-- FOR LOOP 인라인 커서
-- FOR LOOP 구문에서 커서를 직접 선언!?

BEGIN
    FOR record_row IN (SELECT dname, loc FROM dept) LOOP 
    -- IN안에 들어간게 커서다?
    -- 이 경우 declare구문도 필요없음
        DBMS_OUTPUT.PUT_LINE(record_row.dname||record_row.loc);
    END LOOP;
END;
/



--- 실습 pro3
SELECT *
FROM dt;
-- 날짜 사이의 평균을 구해봐라
/*
- 자바로 한번 구현하면?
- 리스트에 다 담겨있다면... for loop문을 돌려서 해당 행+1에 있는
  값에 해당 행 값을 빼고 그 값을 다 모아서 플러스 한다. 
  그리구 사이즈-1 로 나누면 평균!
*/


-- 안뉘이ㅣ이이;;; 근데 아래건 procedure가 아닌데요;;;;;;;;
-- 뭐래 맞거등... 이름이 없을 뿐...
-- 얼른 procedure 이름 넣쟈
CREATE OR REPLACE PROCEDURE avgdt IS

    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY binary_integer;
    v_dt dt_tab; --테이블 로우의 값을 다 담는 타입을 만들어 변수에 넣고
    p number :=0;
    a number :=0;
BEGIN
    -- 한 row의 값을 변수에 저장 : into
    -- 복수 row의 값을 변수에 저장 : bulk (여러건을 담는다는 의미) COLLECT INTO
    SELECT *
    BULK COLLECT INTO v_dt
    FROM dt;

    FOR i IN 2..v_dt.count LOOP
        a := v_dt(i-1).dt - v_dt(i).dt;
        p := p + a;
    END LOOP;
    p := p/(v_dt.count-1); --합을 나눠서 평균을 구한다
    DBMS_OUTPUT.PUT_LINE(p);
END;
/


exec avgdt;


--- PL/SQL 말고 다른 방법으로는?
-- 1. ROWNUM으로 조인하기 (1=2)
-- 2. 분석함수
SELECT LEAD(dt) OVER (ORDER BY DT) - dt
FROM dt;
-- 이러고 다 더했다가 나누면 되는데 윈도우 함수 쓴 거는 그룹함수 안되니까
-- 인라인으로 한번 감싸주쟈
SELECT avg(sum_avg)
FROM
(SELECT LEAD(dt) OVER (ORDER BY DT) - dt sum_avg
FROM dt);

-- 3. 그리고 다른 세번째 방법은? 뭘까? 서브쿼리? 이것도 ROWNUM을 써야하네...
-- 힌트.. 집합...? 우우우우움.... 
-- ㅋㅋㅋㅋ max랑 min 빼고 count로 나눔ㅋㅋㅋㅋㅋ



-- 실습 pro4
-- cid, pid, dt, cnt
/*
예를들어 1번 고객이 100번 제품을 월요일마다 먹는다면
 1, 100, 2, 1 --> 1, 100, 20191202, 1
              --> 1, 100, 20191209, 1
              --> 1, 100, 20191216, 1
              --> 1, 100, 20191223, 1
              --> 1, 100, 20191230, 1
*/

SELECT *
FROM daily; --이 테이블에 위와 같이 나오게. 

-- 일단 달력 만들기?
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + LEVEL - 1
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD');
-- ㅠㅠ힝구 왜 또 안된담.. 아 알앗다 ㅡㅡ TO_CHAR... 
-- 일단 선생님이 하신 방법 따라 해보기...

desc daily;


-- 생성 전 해당 년의 DAILY 데이터가 있으면 삭제하라.. 
SELECT *
FROM daily
WHERE dt LIKE :YYYYMM||'%'; --날짜가 문자형 타입이기 때문에.


-- PRO 4
-- 쉬익쉬익 나는 왜 달력 안 만들어짐 쉬익쉬익
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) DT
      ,TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM')+(LEVEL-1), 'D') DAY
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD');



CREATE OR REPLACE PROCEDURE create_daily_sales(v_yyyymm IN VARCHAR2) is
    TYPE cal_row_type IS RECORD (dt VARCHAR2(8), day NUMBER);    -- 테이블 로우타입
    TYPE cal_tab IS TABLE OF cal_row_type INDEX BY BINARY_INTEGER; --테이블 타입
    v_cal_tab cal_tab;
BEGIN
    -- 생성하기 전 해당 년월의 데이터 삭제
    DELETE daily
    WHERE dt LIKE v_yyyymm||'%';
    
    -- 만약 커서를 달력 안에 넣으면 사이클에 있는 쿼리만큼 실행된다.. 
    -- 그래서 한번에 달력을 만들고 그걸 메모리에 올리고 시작할 것임...
    SELECT TO_CHAR(TO_DATE(v_yyyymm, 'YYYYMM') + (LEVEL-1),'YYYYMMDD') DT --DT는 문자로 받음
      ,TO_NUMBER(TO_CHAR(TO_DATE(v_yyyymm, 'YYYYMM')+(LEVEL-1), 'D')) DAY --DAY는 숫자로 받음
    BULK COLLECT INTO v_cal_tab
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(v_yyyymm, 'YYYYMM')), 'DD');
    
    -- 애음주기 정보를 읽는다
    FOR daily IN (SELECT * FROM CYCLE) LOOP
        -- 12월 일자 달력 : CYCLE ROW 건수만큼 반복함...
        FOR i IN 1..v_cal_tab.count LOOP
            IF daily.day = v_cal_tab(i).day THEN
                --CID, PID, 일자, 수량
                INSERT INTO daily VALUES
                (daily.cid, daily.pid, v_cal_tab(i).dt, daily.cnt);
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(daily.cid||', '||daily.day);
    END LOOP;
    COMMIT;
END;
/

exec create_daily_sales('201911');



-- 하지만 쿼리 효율이 그야말로 최악!!!!!!!!
-- 조인으로 해결해보쟈

SELECT cycle.cid, cycle.pid, cal.dt, cycle.cnt
FROM cycle, 
     (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL-1) dt
      ,TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM')+(LEVEL-1), 'D') day 
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))cal
WHERE cycle.day = cal.day
ORDER BY cid, pid, dt;








