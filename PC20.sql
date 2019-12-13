--특정 테이블의 컬럼 조회
--1. DESC 테이블명
--2. SELECT * FROM user_tab_columns;

-- prod 테이블의 컬럼조회
DESC prod;--했을 때 나오는 널? 부분은

--NOT NULL = 널이 올 수 없음. 값을 반드시 표시해야하는데 비어있음.
--NOT NULL 없이 비어있음 = 값을 안 넣어도 됨.



--- 아래의 유형 중에서
VARCHAR2, CHAR --> 문자열 (Character).. 근데 character는 문자고 sentence가 문자열 아님?
NUMBER -->숫자. 
CLOB --> character lanrge object, 문자열 타입의 길이 제한을 피하는 타입
        -- VERCHAR2 : 4000byte가 한계.
        -- CLOB : 최대 4GB
        
DATE --> 날짜 (일시 = 년,월,일 








