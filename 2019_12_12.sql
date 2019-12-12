

-- ��Ī : ���̺�, �÷��� �ٸ� �̸����� ����
--   [AS] ��Ī��
-- SELECT empno [AS] eno
-- FROM emp e

-- SYNONYM (���Ǿ�)
-- ����Ŭ ��ü�� �ٸ� �̸����� �θ� �� �ֵ��� �ϴ� ��
-- ���࿡ emp ���̺��� e ��� �ϴ� syononym



-- ������ ����... system�� ����....
-- PC20�� �������� �ο�
GRANT CREATE SYNONYM TO PC20;



-- emp ���̺��� synonym e ����
-- CREATE SYONOYM �̸� FOR ����Ŭ��ü
CREATE SYNONYM e FOR emp;


-- emp��� ���̺� �� ��ſ� e��� �ϴ� synonym�� ����Ͽ� ������ �ۼ�
SELECT *
FROM e;


-- pc20 ������ fastfood ���̺��� hr ���������� �� �� �ֵ���
-- ���̺� ��ȸ ������ �ο�

GRANT SELECT ON fastfood TO hr;

/*
- grant.. ppt 122�� ���� ��. ��й�ȣ ����

- ����Ŭ�� ��Ű���� ����ڰ����� �پ��ִٴ� ����
- grant ���Ѹ� to ����ڸ�
- revoke ���Ѹ� from ����ڸ�

- pt 127.. �ɼ�. ���ѿɼ��̶����. 
*/

SELECT *
FROM user_views;



-- ������ SQL�� ���信 ������ �Ʒ� SQL���� �ٸ���
SELECT /* 201911_205 */ * FROM emp;
SELECT /* 201911_205 */ * FROM EMP;
SELECt /* 201911_205 */ * FROM EMP;

SELECT * FROM emp WHERE empno=7788;
SELECT * FROM emp WHERE empno=7869; --���� �ٸ� ������ �����Ϳ� �����
SELECT * FROM emp WHERE empno=:empno; --�̷��� ���� ������ �����Ѵ�
-- ��� �, ������ ����. ������ ���ϰ� �ص� �ȴ�
-- ������ ������ �� ���� ������ ����� ���� �� ���� �� ����


-- multiple insert
DROP TABLE emp_test;


-- emp ���̺��� empno, ename �÷����� emp_test, emp_test2
-- ���̺��� ���� (CTAS)
CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp;


-- unconditional insert
-- �������̺� �����͸� ���� �Է�
-- brown, cony �����͸� emp_test, emp_test2 ���̺� ���� �Է�
INSERT ALL 
    INTO emp_test
    INTO emp_test2
SELECT 9999, 'brown' FROM dual UNION ALL
SELECT 9998, 'cony' FROM dual;


SELECT *
FROM emp_test2
WHERE empno >9990;

ROLLBACK;


-- ���̺� �� �ԷµǴ� �������� �÷��� ���� ����
INSERT ALL 
    INTO emp_test (empno, ename) VALUES (eno, enm)
    INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 9998, 'cony' FROM dual;

ROLLBACK;


-- CONDITIONAL INSERT
-- ���ǿ� ���� ���̺� �����͸� �Է�

INSERT ALL
    WHEN eno>9000 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 8998, 'cony' FROM dual;

rollback;


INSERT ALL
    WHEN eno>9000 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    WHEN eno>9500 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 8998, 'cony' FROM dual;
-- �̷��� ���� ���� �߰��ȴ�. 

rollback;

INSERT FIRST
    WHEN eno>9000 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    WHEN eno>9500 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 8998, 'cony' FROM dual;
-- �̷��� ���ǿ� �´µ��� ������ ������ ���� �����Ͱ� �� ���� ã�´�. 

SELECT *
FROM emp_test2
WHERE empno > 8000;








