

-- ����Ŭ �������� �̸��� ���Ƿ� ���� (SYS-C000701)

CREATE TABLE dept_test(
deptno NUMBER(2) CONSTRAINT pk_dpet_test PRIMARY KEY);

-- PAIRWISE : ���� ����
-- ����� PRIMARY KEY ���������� ��� �ϳ��� �÷��� ���������� ����
-- ���� �÷��� �������� PRIMARY KEY�������� ������ �� �ִ�
-- �ش� ����� ���� �ΰ��� ����ó�� �÷� ���������� ������ �� ����.
--> TABLE LEVEL ���� ���� ����

-- ������ ������ dept_test ���̺� ���� (drop)
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13), -- ������ �÷��� �ĸ��� ���̱�
    
    -- ���̺� ���� ��������.
    -- deptno, dname �÷��� ���� �� ������ (�ߺ���) �����ͷ� �ν�
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno, dname)
);

-- �μ���ȣ, �μ��̸� ���������� �ߺ������͸� ����
-- �Ʒ� �ΰ��� insert ������ �μ���ȣ�� ������ �μ��̸��� �ٸ��Ƿ�
-- �ٸ� �����ͷ� �ν�, insert����


INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(99, '���', '����');


-- NOT NULL ��������
-- �ش� �÷��� NULL���� ������ ���� ������ �� ���
-- ���� �÷����� �Ÿ��� �ִ�


-- �÷� ������ �ƴ�, ���̺� ������ �������� ����
-- dname �÷��� NULL ���� ������ ���ϵ��� NOT NULL ���� ���� ����
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13));

INSERT INTO dept_test VALUES(99, 'ddit', null); 
-- ���� ���� pk, null ���࿡ �ɸ��� ����
INSERT INTO dept_test VALUES(98, null, '����'); 
-- ���� ���� pk���� �ɸ��� ������ null ���࿡ �ɸ�


-- NOT NULL ���ǿ� �̸����̱�?
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
--    ,CONSTRAINT NN_dname NOT NULL (dname) --�̰��� ���� �Ұ���
-- NOT NULL�� ���̺� ��ü�� ������ �� ����. ������ �ʴ´�. 
);

-- 1. �÷�����
-- 2. �÷� ���� �������� �̸� ���̱�
-- 3. ���̺� ����
-- [4. ���̺� ������ �������� ����]


-- UNIQUE ���� ����
-- �ش� �÷��� ���� �ߺ��Ǵ� ���� ����
-- ��, NULL ���� ���
-- GLOBAL SOLUTION�� ��� ������ ���� ���� ������ �ٸ��� ������
-- PK ���ຸ�ٴ� UNIQUE ������ ����ϴ� ���̸�, ������ ���� ������
-- APPLICATION �������� üũ �ϵ��� �����ϴ� ������ �ִ�.


-- �÷� ���� UNIQUE ���� ����
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) unique,
    loc VARCHAR2(13));


-- �ΰ��� INSERT ������ ���� dname���� �Է��ϱ� ������
-- dname �÷��� �����  UNIQUE ���࿡ ���� 
-- �ι�° ������ ���������� ����Ұ�
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(98, 'ddit', '����');


DROP TABLE dept_test;

-- �̸� ���� UNIQUE ���� ����
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) CONSTRAINT IDX_U_dept_test_01 UNIQUE,
    loc VARCHAR2(13));


DROP TABLE dept_test;

-- ���̺� ���� UNIQUE ���� ����
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT IDX_U_dept_test_01 UNIQUE
);


-- �ΰ��� INSERT ������ ���� dname���� �Է��ϱ� ������
-- dname �÷��� �����  UNIQUE ���࿡ ���� 
-- �ι�° ������ ���������� ����Ұ�
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(98, 'ddit', '����');


-- FOREIGN KEY ��������
-- �ٸ� ���̺� �����ϴ� ���� �Է� �� �� �ֵ��� ����

-- dept_test ���̺� ���� (deptno �÷� PRIMARY KEY ����)
-- DEPT ���̺�� �÷��̸�, Ÿ�� �����ϰ� ����

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

-- �÷����� FOREIGN KEY
CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno) );

-- dept_test ���̺� �����ϴ� deptno�� ���� �Է�
INSERT INTO emp_test VALUES(9999, 'brown', 99);

-- dept_test ���̺� �������� �ʴ� deptno�� ���� �Է�
INSERT INTO emp_test VALUES(9998, 'sally', 98); --����


DROP TABLE emp_test;


-- �÷����� FOREIGN KEY(�������� ��)
CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2) CONSTRAINT FK_dept_test FOREIGN KEY
                        REFERENCES dept_test (deptno) );
-- FOREIGN �÷��� NOT NULL ó�� �÷������δ� �̸��� ���� �� ����


CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2), 
    CONSTRAINT FK_dept_test FOREIGN KEY (deptno)
    REFERENCES dept_test (deptno)
);

INSERT INTO emp_test VALUES(9999, 'brown', 99);
INSERT INTO emp_test VALUES(9998, 'sally', 98); --�ȵ�

DELETE dept_test
WHERE deptno=99;--�ȸ���

-- �μ� ������ �������
-- ������� �ϴ� �μ���ȣ�� �����ϴ� ���������� ����
-- �Ǵ� deptno �÷��� NULL ó��
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
-- �ƴ�;;; FOREIGNŰ�� �����ߴµ� ������ �����͸� �� ����������;;;

-- ON DELETE CASCADE �ɼǿ� ���� DEPT �����͸� ������ ���
-- �ش� �����͸� �����ϰ� �ִ� EMP_TEST�� ��������͵� �����ȴ�



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
-- �� ���� emp_test���� deptno �κи� NULL �� ǥ�õ�



-- check ��������
-- �÷��� ���� ���� ������ ��
-- EX : �޿� �÷����� ���� 0���� ū ���� ������ üũ
--      ���� �÷����� ��/�� Ȥ�� F/M�� ������ ����


DROP TABLE emp_test;

-- emp_test ���̺� Į��
-- empno NUMBER(4)
-- ename VARCHAR2(10)
-- sal NUMBER(7,2) -- 0���� ū ���ڸ� �Էµǵ��� ����
-- emp_gb VARCHAR2(2) -- �������� 01-������ 02-����

CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    sal NUMBER(7,2) CHECK (sal>0),
    emp_gb VARCHAR2(2) CHECK (emp_gb IN ('01','02'))
);

-- sal üũ �������� sal>0 �� ���� �������� �Էµ� �� ����. �Ʒ��� �Ұ�.
INSERT INTO emp_test VALUES(9999, 'brown', -1, '01' );
-- �Ʒ����� ������� ����
INSERT INTO emp_test VALUES(9999, 'brown', 1000, '01' );
-- emp_gb üũ �������� �Ʒ����� ����
INSERT INTO emp_test VALUES(9998, 'sally', 1000, '03' );


DROP TABLE emp_test;


-- CHECK �������� �̸� ���̱�.. pk�� ����
CREATE TABLE emp_test(
    empno NUMBER(4) CONSTRAINT PK_emp_test PRIMARY KEY,
    ename VARCHAR2(10),
    sal NUMBER(7,2) CONSTRAINT C_SAL CHECK (sal>0),
    emp_gb VARCHAR2(2) CONSTRAINT C_emp_gb CHECK (emp_gb IN ('01','02'))
);

-- ���̺��� CHECK �������� �̸� ���̱�.. pk�� ����
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



-- ���̺� ���� : CREATE TABLE ���̺�� (�÷� �÷�Ÿ�� ....);
-- ���� ���̺��� Ȱ���ؼ� ���̺� �����ϱ�
-- Creat Table AS : CTAS (��Ÿ��? ������
-- CREATE TABLE ���̺�� (�÷�1, �÷�2, �÷�3...) AS 
--      SELECT co1, col2 ...
--      FROM �ٸ� ���̺��
--      WHERE ����

DROP TABLE emp_test;

CREATE TABLE emp_test AS
    SELECT *
    FROM emp;

SELECT *
FROM emp_test
MINUS
SELECT *
FROM emp;

-- ���� �Ϻ��� ������ �˷���?
-- EMP_test - EMP = NULL
-- EMP - EMP_test = NULL


DROP TABLE emp_test;


-- EMP ���̺��� �÷����� �����ؼ� ����
CREATE TABLE emp_test (C1, C2, C3, C4, C5, C6, C7, C8) AS
    SELECT *
    FROM emp;


-- ���̺��� ���� �� Ʋ�� ������ ���� ������? ������ ����
CREATE TABLE emp_test AS
    SELECT *
    FROM emp
    WHERE 1=2; --�̷������� ������ �����ϴ� �����Ͱ� ������ Ʋ�� ������


-- empno, ename, deptno �÷����� emp_test ����
CREATE TABLE emp_test AS
    SELECT empno, ename, deptno
    FROM emp
    WHERE 1=2;

-- emp_test ���̺� �ű� �÷� �߰�
-- HP VARCHAR2(20) dafault '010'
-- ALTER TABLE ���̺�� ADD (�÷��� �÷�Ÿ�� [DEFAULT value]);

ALTER TABLE emp_test ADD (HP VARCHAR2(20) DEFAULT '010');

-- �����Ͱ� ���� ������ �÷� ���� ����
-- ALTER TABLE ���̺�� MODIFY (�÷� �÷�Ÿ�� [DEFAULT value]);
-- hp �÷��� Ÿ���� VARCHAR2(20)->(30)

ALTER TABLE emp_test MODIFY (HP VARCHAR2(30));

-- VARCAHR2(30) -> NUMBER
ALTER TABLE emp_test MODIFY (HP NUMBER(11));
DESC emp_test;


-- �÷��� ����
-- �ش� �÷��� pk, unique, not null, check ���� ���ǽ�
-- ����� �÷��� ���ؼ��� �ڵ������� ������ �ȴ�. �ٵ� foreign�� �ƴѰ���
-- HP �÷� HP_N ���� �����ϱ�
ALTER TABLE emp_test RENAME COLUMN (HP TO HP_N);


-- �÷�����
-- ALTER TABLE ���̺�� DROP (�÷���);
-- ALTER TABLE ���̺�� DROP COLUMN �÷���;
ALTER TABLE emp_test DROP (hp_n);


-- �������� �߰�
-- ALTER TABLE ���̺�� ADD  --���̺� ���� �������� ��ũ��Ʈ
-- emp_test ���̺��� empno�÷��� PK���� �߰�
ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test PRIMARY KEY(empno);


-- �������� ����
-- ALTER TABLE ���̺�� DROP CONSTRAINT  ���������̸�
-- emp_test ���̺��� PRIMARY KEY ���������� pk_emp_test ���� ����
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;


-- ���̺� �÷�, Ÿ�� ������ ���������γ��� ����
-- ���̺��� �÷� ������ �����ϴ� ���� �Ұ����ϴ�
















