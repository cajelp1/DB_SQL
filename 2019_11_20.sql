--특정 테이블의 컬럼 조회
--1. DESC 테이블명
--2. SELECT * FROM user_tab_columns;

-- prod 테이블의 컬럼조회
DESC prod;--했을 때 나오는 널? 부분은

--NOT NULL = 널이 올 수 없음. 값을 반드시 표시해야하는데 비어있음.
--NOT NULL 없이 비어있음 = 값을 안 넣어도 됨.



-- 아래의 유형 중에서
VARCHAR2, CHAR --> 문자열 (Character).. 근데 character는 문자고 sentence가 문자열 아님?
NUMBER -->숫자. 
CLOB --> character Large OBject, 문자열 타입의 길이 제한을 피하는 타입
        -- VERCHAR2 : 4000byte가 한계.
        -- CLOB : 최대 4GB

DATE --> 날짜 ( 일시 = 년,월,일 + 시간, 분, 초 )


--date타입에 대한 연산의 결과는?

'2019/11/20 09:16:20' + 1 = ? 
-- 프로그램을 만드는 회사에 따라 다름. 아예 연산이 안되는 프로그램도 존재. 
--오라클에서는 정의되어있음.

--USER 테이블의 모든 컬럼을 조회하라
DESC users;

-- userid, usernm, reg_dt 세가지 컬럼만 조회
-- 연산을 통해 새로운 컬럼을 생성 (콤마 뒤에 새로운 컬럼 이름을 써준다.)
-- 여기서는 reg_dt 에 숫자 연산을 한 새로운 가공 컬럼
-- 날짜 + 정수 연산 = 일자를 더한 날짜타입이 결과로 나온다.
SELECT userid, usernm, reg_dt, reg_dt+5
FROM users;

-- 컬럼에 별칭을 줄 수 있다. 방법은 두가지. 컬럼 후에 AS를 쓰고 별칭명을 써준다.
SELECT userid, usernm, reg_dt, reg_dt+5 AS after5day
FROM users;

-- 아니면 지금 컬럼명에 스페이스 한칸 띄우고 이름쓴다.
SELECT userid, usernm, reg_dt reg_date, reg_dt+5 AS after5day
FROM users;

-- 별칭 : 기존 컬럼명이나 연산을 통해 생성된 가상 컬럼에 임의의 컬럼이름을 부여
--     col | express [AS] 별칭명

-- 숫자 상수, 문자열 상수 (oracle : '', JAVA : '', "")
-- table에 없는 값을 임의로 컬럼으로 생성 (하려면 해당 숫자를 써주면 됨.)

-- 테이블 앞에 1이라는 숫자의 컬럼을 생성
-- DB SQL 수업 이라는 컬럼을 생성
SELECT 1, 'DB SQL 수업', userid, usernm, reg_dt
FROM users;

-- 사칙연산을 하는 컬럼도 생성 가능. (+, -, /, *)
-- 사칙연산 우선순위에 따르며 ()를 통해 연산순서 조정 가능
SELECT (10-2)*2, 'DB SQL 수업', userid, usernm, reg_dt
FROM users;

-- 문자에 대한 연산
SELECT (10-2)*2, 'DB SQL 수업', userid + '_modified', usernm, reg_dt
FROM users;
-- 에러코드 01722라고 뜸. 유효하지 않은 숫자다라고 뜬다.
-- 문자에는 연산이 존재하지 않기때문.
-- 그때는 || 를 사용한다.

SELECT (10-2)*2, 'DB SQL 수업', --(만약 컴마를 없애면 usernm 아래에 DB SQL 수업 이라는게 alias처리 됨)
        /*userid + '_modified, 문자열에는 더하기 연산이 없다'*/
        usernm || '_modified', reg_dt
FROM users;



--NULL : 아직 모르는 값
--NULL에 대한 연산 결과는 항상 NULL이다
--DESC 테이블명 : NOT NULL로 설정되어있는 컬럼에는 값이 반드시 들어가야 한다.

--users불필요한 데이터 삭제
SELECT *
FROM users;

DELETE users
WHERE userid NOT IN ('brown', 'sally', 'cony', 'moon', 'james');

rollback; -- ctrl + z

commit; --데이터에 가한 수정을 확정함

--오라클은 키워드에 대한 대소문자는 구분하지 않지만 실제 데이터값에서는 구분한다.
--저기서 brown을 BROWN이라고 쓰면 brown데이터는 지워진다.

SELECT userid, usernm, reg_dt
FROM users;
--NULL연산을 시험해보기 위해 moon의 reg_dt컬럼을 null로 변경
UPDATE users SET reg_dt = NULL
WHERE userid = 'moon';

COMMIT;

--users 테이블의 reg_dt 컬럼값에 5일을 더한 새로운 컬럼을 생성
--NULL값에 대한 연산의 결과는 정말 NULL 인지 확인. (나중에 연산방법을 배울것임)
SELECT userid, usernm, reg_dt, reg_dt + 5
FROM users;



------------COLUMN ALIAS 실습

--PROD테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하라
-- 단, prod_id -> id, prod_name -> name 으로 컬럼 별칭을 지정

SELECT prod_id AS id, prod_name name
FROM prod;

--lprod 테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회하라
--단, lprod_gu > gu, lpro_nm > nm으로 바꿔라

SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

--buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하라
--단 buyer_id > 바이어아이디, buyer_name > 이름 으로 컬럼 별칭을 지정하라

SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;

---------------------

--문자열 컬럼간 결합        (컬럼 || 컬럼, '문자열상수' || 컬럼, CONCAT(컬럼, 컬럼))
SELECT userid, usernm, userid || usernm AS id_nm,
        CONCAT(userid, usernm) con_id_nm,
        -- ||을 이요해서 userid, usernm, pass 결합
        userid || usernm || pass id_nm_pass,
        -- concat 을 이용해서 userid, usernm, pass
        CONCAT(CONCAT(userid, usernm), pass) sadf
FROM users;


-- 사용자가 소유한 테이블 목록 조회
SELECT table_name
FROM user_tables;


-- 문자열 결합을 이용해 다음과 같이 조회되도록~
SELECT 'SELECT * FROM '||table_name||';' query,
        --연산은 한꺼번에 된다! 그 후에 테이블의 이름 붙일것
        --CONCAT 함수만 이용해서 써봐라
        CONCAT(CONCAT('SELECT * FROM ', table_name), ';') query
FROM user_tables;



--WHERE : 조건이 일치하는 행만 조회화기 위해 사용
--          행에 대한 조회 기준을 작성
--where가 없으면 해당 테이블의 모든 행에 대해 조회함
SELECT userid, usernm, alias, reg_dt
FROM users;

SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid = 'brown'; --userid 컬럼이 'brown'인 행(row)만 조회

SELECT *
FROM DBA_USERS;
--오류나넹....



-- EMP 테이블의 전체 데이터 조회 (행, 열... ROW, COLUNM)
SELECT *
FROM emp;

SELECT *
FROM dept;


--부서번호(deptno)가 20보다 크거나 같은 부서에서 일하는 직원 정보 조회
SELECT *
FROM emp
WHERE deptno >= 20;


--사원번호가 7700보다 크거나 같은 사원의 정보 조회
SELECT *
FROM emp
WHERE empno >= 7700;


-- TO_DATE 함수... 문자열을 날짜 타입으로 변경. 
-- TO_DATE('날짜문자열', '날짜문자열format')
-- 사원 입사일자가 1982년 1월 1일 이후인 사원 정보 조회
SELECT empno, ename, hiredate, 2000 no, '문자열상수' str,
        TO_DATE('19820101', 'yyyymmdd')
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');


--범위조회 (BETWEEN 시작기준 AND 종료기준)
--시작기준, 종료기준을 포함!!!!!
--사원 중 급여(SAL)가 1000보다 크거나 같고, 2000보다 작거나 같은 사원 정보조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;


-- BETWEEN AND 연산자는 부등호 연산자로 바꿀 수 있다.
SELECT *
FROM emp
WHERE sal >= 1000
AND sal <= 2000;



--------------------
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('01/01/1982', 'dd/mm/yyyy')
AND hiredate <= TO_DATE('19830101', 'YYYYMMDD');

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'yyyymmdd')
AND hiredate <= TO_DATE('19830101', 'yyyymmdd');
-------------------------------


--------------------------------
SELECT *
FROM emp
WHERE deptno IN ( 10, 20, 30);

SELECT *
FROM emp
WHERE deptno = 10
OR deptno = 20;
---------------------------------





