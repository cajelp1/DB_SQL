/*
Exception
- ���� �߻��� ���α׷��� �����Ű�� �ʰ�
- �ش� ���ܿ� ���� �ٸ� ������ �����ų �� �ְԲ� ó���Ѵ�

- ���ܰ� �߻��ߴµ� ����ó���� ���� ��� : PL/SQL ����� ������ �Բ� ����ȴ�
- �������� SELECT ����� �����ϴ� ��Ȳ���� ��Į�� ������ ���� �ִ� ��Ȳ
*/


-- EMP���̺��� ����̸� ��ȸ
SET serveroutput ON;
DECLARE
    --��� �̸��� ������ �� �ִ� ����
    v_ename emp.ename%TYPE;
BEGIN
    -- WHERE ���� ��� ��Į�� ���� �ƴ϶� �������� ����
    SELECT ename
    INTO v_ename
    FROM emp;
EXCEPTION 
    WHEN too_many_rows THEN
        DBMS_OUTPUT.PUT_LINE('�������� select ����� ����');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('WHEN OTHERS'); --����Ŭ���� EXCEPTION�� ��� �����ϴ� Ŭ����
END;
/



/*
����� ���� ����
- ����Ŭ���� ������ ������ ���� �̿ܿ��� �����ڰ� �ش� ����Ʈ���� �����Ͻ� ��������
  ������ ���ܸ� ����, ����� �� �ִ�.
- ������� SELECT ����� ���� ��Ȳ���� ����Ŭ������ NO_DATA_FOUND ���ܸ� ������
  �ش� ���ܸ� ��� NO_EMP��� �����ڰ� ������ ���ܷ� �������� ���ܸ� ���� �� �ִ�.

*/


DECLARE
    -- EMP ���̺��� ��ȸ ����� ���� �� ����� ����� ���� ����
    no_emp EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    -- no_data_found ������ ���
    BEGIN -- BEGIN�ȿ��� BEGIN�� �� �� �ִ�
        SELECT ename
        INTO v_ename
        FROM emp
        WHERE empno = 8888;
        EXCEPTION
    WHEN no_data_found THEN 
            -- JAVA������ THROW��� ������ ����Ŭ�� RAISE
            RAISE no_emp;
    END;
EXCEPTION
    WHEN no_emp THEN    --���⼭ NO_EMP�� ���ܸ� ��� ó������ ������
        DBMS_OUTPUT.PUT_LINE('NO_EMP');
END;
/

/*
�Լ� : ������ �۾��� ���� �� ����� �����ִ� �̸��ִ� PL/SQL BLOCK
*/

-- ����� �Է¹޾Ƽ� �ش� ������ �̸��� �����ϴ� �Լ�
-- getEmpName(7369) --> SMITH

CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE)
RETURN VARCHAR2 IS 
-- �����
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
-- �μ���ȣ�� �Է��ϸ� �ش� �μ��̸��� ����

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

SELECT getdeptname(10) --deptno�� ������ �������� dual�� �Ἥ ���� �ְ�
FROM dual;

SELECT getdeptname(deptno) -- deptno���� �������� ���� ���·�
FROM dept;                 -- ���̺��� �����ؼ� ���� �� �� ���� �ִ�... ��

SELECT getdeptname (10)
FROM dept; --�� accounting�� 4�� ������? �� �׷�? 
-- ���̺� �ִ� �ุŭ �ٲ㼭 ǥ���ϴ°�?


-- �Լ��� ���°� ���κ��� ������? ��Ȳ�� ���� �ٸ�...
-- cache : 20
-- ������ ������ : 
-- deptno (�ߺ� ����) : �������� ���� ���ϴ�
-- empno (�ߺ��� ����) : �������� ����

-- emp ���̺��� �����Ͱ� 100������ ���
-- 100�� �߿��� deptno�� ������ 4��(10~40)
SELECT getdeptname(deptno), -- 4����
       getempname(empno)    -- row ����ŭ �����Ͱ� ����
FROM emp;



--- function2
-- LPAD(' ',(level-1)*4, ' ') ��� �κ��� �Լ��� ���� �� ������?
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
-- ��.. deptnm �̸��� �ٲ�� ������ deptnm�� �޾ƾ��ϳ�?


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



-- package... interface�� ����ѵ� �ƴѵ��� �׷���. �ڹ� ��Ű���� ���..?



-- trigger

-- users ���̺��� ��й�ȣ Į���� ������ ������ ��
-- ������ ����ϴ� ��й�ȣ �÷� �̷��� �����ϱ� ���� ���̺�
CREATE TABLE users_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE
);

CREATE OR REPLACE TRIGGER make_history
    --timing
    BEFORE UPDATE ON users
    FOR EACH ROW -- �� Ʈ����, ���� ������ ���� ������ �����Ѵ�
    -- ���� ������ ���� : OLD
    -- ���� ������ ���� : NEW
    BEGIN
        -- users ���̺��� pass �÷��� ������ �� trigger ����
        IF (:OLD.pass != :NEW.pass) THEN
        INSERT INTO users_history
            VALUES (:OLD.userid, :OLD.pass, SYSDATE);
        END IF;
        -- �ٸ� �÷��� ���ؼ��� �����Ѵ�
    END;
/


-- USERS ���̺��� PASS �÷��� �������� ��
-- TRIGGER�� ���ؼ� users_history ���̺� �̷��� �����Ǵ��� Ȯ��
SELECT *
FROM users_history;
UPDATE users SET pass = '1234'
WHERE userid= 'brown';








