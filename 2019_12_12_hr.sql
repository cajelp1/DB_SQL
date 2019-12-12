
SELECT *
FROM pc20.users;

SELECT *
FROM jobs;

SELECT *
FROM all_tables
WHERE owner = 'PC20';


-- SELECT * FROM DBA_DATA_FILES; 이건 뭐라하셧더라..


SELECT *
FROM fastfood; -- 이러면 오류뜸. 어디의 테이블인지 명시해줘야함
SELECT *
FROM pc20.fastfood; --이러케에. 근데 synosym을 만들면 더 쉽겟지?

-- PC20.fastfood --> fastfood synonym생성
-- 생성 후 sql이 정상적으로 작동하는지 확인
CREATE SYNONYM fastfood FOR PC20.fastfood;

-- 장점 : 쓰기 쉬움
-- 단점 : 앞의 '주소.객체이름' 의 주소가 사라지기 때문에 
-- 테이블이 어디서 온건지 모름

-- 만약 synonym 이름이 다른 테이블이랑 겹치면?
-- name is already used by an existing object

SELECT * FROM emp WHERE empno=7788;
SELECT * FROM emp WHERE empno=7869; --둘은 다른 쿼리로 데이터에 저장됨
SELECT * FROM emp WHERE empno=:empno; --이러면 같은 쿼리로 저장한다
-- 운영은 운영, 개발은 개발. 개발은 편하게 해도 된다
-- 하지만 개발할 때 쓰던 쿼리가 운영으로 오면 안 좋을 수 있음


-- multiple insert









