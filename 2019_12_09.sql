

-- 오라클 제약조건 이름을 임의로 생성 (SYS-C000701)

CREATE TABLE dept_test(
deptno NUMBER(2) CONSTRAINT pk_dpet_test PRIMARY KEY);

-- PAIRWISE : 쌍의 개념
-- 상단의 PRIMARY KEY 제약조건의 경우 하나의 컬럼에 제약조건을 생성
-- 여러 컬럼을 복합으로 PRIMARY KEY제약으로 생성할 수 있다
-- 해당 방법은 위의 두가지 예시처럼 컬럼 레벨에서는 생성할 수 없다.
--> TABLE LEVEL 제약 조건 생성

-- 기존에 생성한 dept_test 테이블 삭제 (drop)
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13), -- 마지막 컬럼에 컴마를 붙이기
    
    -- 테이블 레벨 제약조건.
    -- deptno, dname 컬럼이 같을 때 동일한 (중복된) 데이터로 인식
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno, dname)
);

-- 부서번호, 부서이름 순서쌍으로 중복데이터를 검증
-- 아래 두개의 insert 구문은 부서번호는 같지만 부서이름이 다르므로
-- 다른 데이터로 인식, insert가능


INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(99, '대덕', '대전');


-- NOT NULL 제약조건
-- 해당 컬럼에 NULL값이 들어오는 것을 제한할 때 사용
-- 복합 컬럼과는 거리가 멀다


-- 컬럼 레벨이 아닌, 테이블 레벨의 제약조건 생성
-- dname 컬럼이 NULL 값이 들어오지 못하도록 NOT NULL 제약 조건 생성
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13));

INSERT INTO dept_test VALUES(99, 'ddit', null); 
-- 위의 행은 pk, null 제약에 걸리지 않음
INSERT INTO dept_test VALUES(98, null, '대전'); 
-- 위의 행은 pk에는 걸리지 않지만 null 제약에 걸림


-- NOT NULL 조건에 이름붙이기?
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) CONSTRAINT NN_dname NOT NULL,
    loc VARCHAR2(13));

DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
--    ,CONSTRAINT NN_dname NOT NULL (dname) --이같은 형식 불가능
-- NOT NULL은 테이블 전체에 적용할 수 없음. 허용되지 않는다. 
);

-- 1. 컬럼레벨
-- 2. 컬럼 레벨 제약조건 이름 붙이기
-- 3. 테이블 레벨
-- [4. 테이블 수정시 제약조건 적용]


-- UNIQUE 제약 조건
-- 해당 컬럼에 값이 중복되는 것을 제한
-- 단, NULL 값은 허용
-- GLOBAL SOLUTION의 경우 국가간 법적 적용 사항이 다르기 때문에
-- PK 제약보다는 UNIQUE 제약을 사용하는 편이며, 부족한 제약 조건은
-- APPLICATION 레벨에서 체크 하도록 설계하는 경향이 있다.


-- 컬럼 레벨 UNIQUE 제약 생성
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) unique,
    loc VARCHAR2(13));


-- 두개의 INSERT 구문을 통해 dname값을 입력하기 때문에
-- dname 컬럼에 적용된  UNIQUE 제약에 의해 
-- 두번째 쿼리는 정상적으로 실행불가
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(98, 'ddit', '대전');


DROP TABLE dept_test;

-- 이름 붙은 UNIQUE 제약 생성
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) CONSTRAINT IDX_U_dept_test_01 UNIQUE,
    loc VARCHAR2(13));


DROP TABLE dept_test;

-- 테이블 레벨 UNIQUE 제약 생성
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT IDX_U_dept_test_01 UNIQUE
);


-- 두개의 INSERT 구문을 통해 dname값을 입력하기 때문에
-- dname 컬럼에 적용된  UNIQUE 제약에 의해 
-- 두번째 쿼리는 정상적으로 실행불가
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(98, 'ddit', '대전');


-- FOREIGN KEY 제약조건
-- 다른 테이블에 존재하는 값만 입력 될 수 있도록 제한

-- dept_test 테이블 생성 (deptno 컬럼 PRIMARY KEY 제약)
-- DEPT 테이블과 컬럼이름, 타입 동일하게 생성

DESC dept;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname   VARCHAR2(14),
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(99,'DDIT', 'daejeon');
COMMIT;

-- emp_test_

DESC emp;
-- empno, ename, deptno : emp_test
-- empno PRIMARY KEY
-- deptno dept_test.deptno FOREIGN KEY

-- 컬럼레벨 FOREIGN KEY
CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno) );

-- dept_test 테이블에 존재하는 deptno로 값을 입력
INSERT INTO emp_test VALUES(9999, 'brown', 99);

-- dept_test 테이블에 존재하지 않는 deptno로 값을 입력
INSERT INTO emp_test VALUES(9998, 'sally', 98); --실패


DROP TABLE emp_test;


-- 컬럼레벨 FOREIGN KEY(제약조건 명)
CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2) CONSTRAINT FK_dept_test FOREIGN KEY
                        REFERENCES dept_test (deptno) );
-- FOREIGN 컬럼도 NOT NULL 처럼 컬럼레벨로는 이름을 붙일 수 없음


CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2), 
    CONSTRAINT FK_dept_test FOREIGN KEY (deptno)
    REFERENCES dept_test (deptno)
);

INSERT INTO emp_test VALUES(9999, 'brown', 99);
INSERT INTO emp_test VALUES(9998, 'sally', 98); --안들어감

DELETE dept_test
WHERE deptno=99;--안먹힘

-- 부서 정보를 지우려면
-- 지우려고 하는 부서번호를 참조하는 직원정보를 삭제
-- 또는 deptno 컬럼을 NULL 처리
-- emp_test -> dept_test

DROP TABLE emp_test;

CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2), 
    CONSTRAINT FK_dept_test FOREIGN KEY (deptno)
    REFERENCES dept_test (deptno) ON DELETE CASCADE
);

INSERT INTO emp_test VALUES(9999, 'brown', 99);
COMMIT;

DELETE dept_test
WHERE deptno=99;

SELECT *
FROM emp_test; 
-- 아뉘;;; FOREIGN키만 삭제했는데 연관된 데이터를 다 지워버리네;;;

-- ON DELETE CASCADE 옵션에 따라 DEPT 테이터를 삭제할 경우
-- 해당 데이터를 참조하고 있는 EMP_TEST의 사원데이터도 삭제된다



INSERT INTO dept_test VALUES(99,'DDIT', 'daejeon');
DROP TABLE emp_test;

CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2), 
    CONSTRAINT FK_dept_test FOREIGN KEY (deptno)
    REFERENCES dept_test (deptno) ON DELETE SET NULL
);

INSERT INTO emp_test VALUES(9999, 'brown', 99);
COMMIT;

DELETE dept_test
WHERE deptno=99;

SELECT *
FROM empt_test;
-- 이 경우는 emp_test에서 deptno 부분만 NULL 로 표시됨



-- check 제약조건
-- 컬럼에 들어가는 값을 검증할 때
-- EX : 급여 컬럼에는 값이 0보다 큰 값만 들어가도록 체크
--      성별 컬럼에는 남/녀 혹은 F/M이 들어가도록 제한


DROP TABLE emp_test;

-- emp_test 테이블 칼럼
-- empno NUMBER(4)
-- ename VARCHAR2(10)
-- sal NUMBER(7,2) -- 0보다 큰 숫자만 입력되도록 제한
-- emp_gb VARCHAR2(2) -- 직원구분 01-정규직 02-인턴

CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    sal NUMBER(7,2) CHECK (sal>0),
    emp_gb VARCHAR2(2) CHECK (emp_gb IN ('01','02'))
);

-- sal 체크 제약조건 sal>0 에 의해 음수값은 입력될 수 없다. 아래값 불가.
INSERT INTO emp_test VALUES(9999, 'brown', -1, '01' );
-- 아래값은 위배되지 않음
INSERT INTO emp_test VALUES(9999, 'brown', 1000, '01' );
-- emp_gb 체크 제약조건 아래값은 위배
INSERT INTO emp_test VALUES(9998, 'sally', 1000, '03' );


DROP TABLE emp_test;


-- CHECK 제약조건 이름 붙이기.. pk와 동일
CREATE TABLE emp_test(
    empno NUMBER(4) CONSTRAINT PK_emp_test PRIMARY KEY,
    ename VARCHAR2(10),
    sal NUMBER(7,2) CONSTRAINT C_SAL CHECK (sal>0),
    emp_gb VARCHAR2(2) CONSTRAINT C_emp_gb CHECK (emp_gb IN ('01','02'))
);

-- 테이블레벨 CHECK 제약조건 이름 붙이기.. pk와 동일
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    sal NUMBER(7,2),
    emp_gb VARCHAR2(2)
    
    CONSTRAINT PK_emp_test PRIMARY KEY,
    CONSTRAINT nn_ename CHECK (ename IS NOT NULL)
    CONSTRAINT C_SAL CHECK (sal>0),
    CONSTRAINT C_emp_gb CHECK (emp_gb IN ('01','02'))
);



-- 테이블 생성 : CREATE TABLE 테이블명 (컬럼 컬럼타입 ....);
-- 기존 테이블을 활용해서 테이블 생성하기
-- Creat Table AS : CTAS (씨타스? ㅋㅋㅋ
-- CREATE TABLE 테이블명 (컬럼1, 컬럼2, 컬럼3...) AS 
--      SELECT co1, col2 ...
--      FROM 다른 테이블명
--      WHERE 조건

DROP TABLE emp_test;

CREATE TABLE emp_test AS
    SELECT *
    FROM emp;

SELECT *
FROM emp_test
MINUS
SELECT *
FROM emp;

-- 둘이 완벽히 같은걸 알려면?
-- EMP_test - EMP = NULL
-- EMP - EMP_test = NULL


DROP TABLE emp_test;


-- EMP 테이블의 컬럼명을 변경해서 생성
CREATE TABLE emp_test (C1, C2, C3, C4, C5, C6, C7, C8) AS
    SELECT *
    FROM emp;


-- 테이블을 만들 때 틀만 복사할 수는 없을까? 데이터 빼고
CREATE TABLE emp_test AS
    SELECT *
    FROM emp
    WHERE 1=2; --이런식으로 조건을 만족하는 데이터가 없으면 틀만 복제됨


-- empno, ename, deptno 컬럼으로 emp_test 생성
CREATE TABLE emp_test AS
    SELECT empno, ename, deptno
    FROM emp
    WHERE 1=2;

-- emp_test 테이블에 신규 컬럼 추가
-- HP VARCHAR2(20) dafault '010'
-- ALTER TABLE 테이블명 ADD (컬럼명 컬럼타입 [DEFAULT value]);

ALTER TABLE emp_test ADD (HP VARCHAR2(20) DEFAULT '010');

-- 데이터가 없기 때문에 컬럼 수정 가능
-- ALTER TABLE 테이블명 MODIFY (컬럼 컬럼타입 [DEFAULT value]);
-- hp 컬럼의 타입을 VARCHAR2(20)->(30)

ALTER TABLE emp_test MODIFY (HP VARCHAR2(30));

-- VARCAHR2(30) -> NUMBER
ALTER TABLE emp_test MODIFY (HP NUMBER(11));
DESC emp_test;


-- 컬럼명 변경
-- 해달 컬럼이 pk, unique, not null, check 제약 조건시
-- 기술한 컬럼명세 대해서도 자동적으로 변경이 된다. 근데 foreign은 아닌가봄
-- HP 컬럼 HP_N 으로 변경하기
ALTER TABLE emp_test RENAME COLUMN (HP TO HP_N);


-- 컬럼삭제
-- ALTER TABLE 테이블명 DROP (컬럼명);
-- ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
ALTER TABLE emp_test DROP (hp_n);


-- 제약조건 추가
-- ALTER TABLE 테이블명 ADD  --테이블 레벨 제약조건 스크립트
-- emp_test 테이블의 empno컬럼에 PK조건 추가
ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test PRIMARY KEY(empno);


-- 제약조건 삭제
-- ALTER TABLE 테이블명 DROP CONSTRAINT  제약조건이름
-- emp_test 테이블의 PRIMARY KEY 제약조건은 pk_emp_test 제약 삭제
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;


-- 테이블 컬럼, 타입 변경은 제한적으로나마 가능
-- 테이블의 컬럼 순서를 변경하는 것은 불가능하다
















