
-- col IN (value1, value2...)
-- col의 값이 IN 연산자 안에 나열된 값 중에 포함될 때 참으로 판정. 


-- RDBMS .. 집합개념.
-- 1. 집합에는 순서가 없다.
-- ( 1, 3, 5)와 (3, 5, 1)는 동일집합.

-- 2. 집합에는 중복이 없다. 
-- (1, 2, 3, 4, 4, 4)와 (1, 2, 3, 4)는 동일집합

SELECT *
FROM emp
WHERE deptno IN (10, 20); 
-- emp 테이블 직원의 소속 부서가 10 이거나(OR) 20번인 직원 정보만 조회

DESC users;
SELECT userid 아이디, usernm " 이름", alias 별명
FROM users;
--WHERE alias LIKE '(null)';


-- like 연산자 : 문자열 매칭 연산
-- % : 여러 문자 (문자가 없을 수도 있다)
-- _ : 하나의 문자
-- LIKE 'S%' --S로 시작하는 문자 검색
-- LIKE '%T' --T로 끝나는 문자 검색
-- LIKE 'S____' --S로 시작하는 다섯 글자의 단어 검색
-- LIKE '_____' --다섯 글자의 단어 검색


--emp 테이블에서 사원 이름이 s로 시작하는 사원 정보만 조회
SELECT *
FROM emp
WHERE ename LIKE 'S__T_';


DESC member;

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';


-- 컬럼 값이 NULL인 데이터 찾기
-- emp 테이블에 보면 MGR 컬럼이 NULL 인 데이터 존재

SELECT *
FROM emp
WHERE mgr IS NULL;
WHERE mgr = NULL;  --mgr 값이 NULL인 사원 정보 조회..안뜬다.
WHERE mgr = 7698;  --mgr 값이 7698인 사원 정보 조회


DESC emp;
SELECT *
FROM emp
WHERE comm IS NOT NULL;

UPDATE  emp SET comm = 0
WHERE empno=7844;

COMMIT;


-- AND : 조건을 동시에 충족
-- OR : 조건을 한개만 충족하면 만족
SELECT *
FROM emp
WHERE mgr = 7698
AND sal > 1000;


-- emp 테이블에서 mgr가 7698이거나(or), 급여가 1000보다 큰 사람
SELECT *
FROM emp
WHERE mgr=7698
OR sal > 1000;



--emp 테이블에서 관리자 사번이 7698, 7839가 아닌 직원 정보 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);


SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL); --이건 아예 안 나온다. 

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
OR mgr IS NULL;



-- EMP에서 JOB = SALESMAN & 입사날짜 = 19810601

SELECT *
FROM emp
WHERE job = 'SALESMAN'
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');





