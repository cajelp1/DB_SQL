
select *
from dept_test;


create or replace procedure UPDATEdept_test 
(d_deptno IN dept.deptno %TYPE
,d_dname IN dept.dname %TYPE
,d_loc IN dept.loc %TYPE) IS
BEGIN   UPDATE dept_test SET 
        deptno=d_deptno, dname=d_dname, loc=d_loc
        WHERE deptno=d_deptno;
-- ����� commit�� �ִ´ٰ�? ��?
END;
/

rollback;
exec UPDATEdept_test(99,'ddit_m', 'daejeon');


/*
- ROWTYPE
- Ư�� ���̺��� ROW������ ���� �� �ִ� ���� Ÿ��
-TYPE : ���̺��, ���̺��÷���%TYPE
- ROWTYPE : ���̺��%ROWTYPE
*/


DECLARE     
--DEPT ���̺��� ROW ������ ����  �� �ִ� ��������
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    DBMS_OUTPUT.PUT_LINE ( dept_row.dname||'++'||dept_row.loc);
END;
/
-- �� �� �� �Ƹ���...


SET SERVEROUTPUT on;


/*
- record type : �����ڰ� �÷��� ���� �����Ͽ� 
���߿� �ʿ��� type�� ����
- TYPE Ÿ���̸� IS RECORD(
        �÷�1 �÷�2TYPE,
        �÷�2 �÷�2TYPE
  );
- public class
*/
DECLARE
    -- �μ��̸�, loc ������ ������ �� �ִ� record type ����
    TYPE dept_row IS RECORD(
        dname dept.dname%type,
        loc dept.loc%type);
    --TYPE������ �Ϸ�Ǿ� typr�� �����ִ� ������ ����
    -- java : class ���� �� �ش� class�� �ε����� ����(new)
    -- plsql ���� ���� : �����̸�, ����Ÿ��, dname dept.dname%TYPE;
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


-- TABLE TYPE : �������� ROWTYPE�� ������ �� �ִ� TYPE
-- col --> row --> table
-- TYPE ���̺�Ÿ�Ը� IS TABLE OF 
-- ROWTYPE/RECORD INDEX BY �ε���Ÿ��(BINARY_INTEGER)
-- ���� �Ӹ� �ƴ϶� ���ڿ� ���µ� ����...
-- �׷��⿡ index�� ���� Ÿ���� ����Ѵ�.
-- �Ϲ������� array(list) ������ ����� index by binary_integer
-- �� �ַ� ����Ѵ�.
-- arr(1).name = 'brown'
-- arr('person').name = 'brown'

DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY binary_integer;
    v_dept dept_tab;
BEGIN
    -- �� row�� ���� ������ ���� : into
    -- ���� row�� ���� ������ ���� : bulk (�������� ��´ٴ� �ǹ�) COLLECT INTO
    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    --CURSOR
    
    
    FOR i IN 1 .. v_dept.count LOOP --�ڹٿ��� for���� ���� ����
        -- arr[1] --> arr(1)
        DBMS_OUTPUT.PUT_LINE(v_dept(i).deptno);
    END LOOP;
END;
/



/*
- �������� IF
IF condition THEN 
    statement
ELSIF condition THEN 
    statement
ELSE 
    statement 
END IF;
*/

-- PL/SQL if�ǽ�
-- ���� p(number)�� 2��� ���� �Ҵ��ϰ�
-- if ������ ���� p�� ���� 1, 2, �� ���� ���� �� �ؽ�Ʈ ���
DECLARE
    p NUMBER := 2;  --���� ����� �Ҵ��� �� ���忡�� ����
BEGIN
    -- P := 2;
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('P=1');
    ELSIF p = 2 THEN    -- �ڹٿ� ������ �ٸ���! else�� �ƴ� els
        DBMS_OUTPUT.PUT_LINE('P=2');
    ELSE 
        DBMS_OUTPUT.PUT_LINE (p);
    END IF;
END;
/



/*
FOR LOOP
- FOR �ε������� IN [REVERSE] START..END LOOP
      �ݺ����๮
- END LOOP;
- 0~5���� ���� ������ �̿��Ͽ� �ݺ��� ����
*/
DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/


-- 1~10 : 55
-- 1~10������ ���� loop�� �̿��Ͽ� ���, ����� s_val�̶�� ������ ���
-- DBMS_OUTPUT.PUT_LINE �Լ��� ���� ȭ�鿡 ���

DECLARE
    p NUMBER := 0;  -- �ʱ�ȭ�� �ؾ� �Ʒ��� ��������� ������
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
- 0���� 5���� WHILE ���� �̿��Ͽ� ���
*/

DECLARE
    i NUMBER := 0;
BEGIN
    WHILE i<=5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1; -- �������� �� �ִ� �� ������ ������ ���ѷ����� ����
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
- ������ ������ ��� ���༭ �츮�� �������� �ʾ�����
- PL/SQL������ ���� �ʿ�
- SQL ���� ���� : ���км�, ������ȹ -> ���ε庯�� -> ���� 
...�ᱹ FETCH�� ��Ʈ���ϴ� ����? (50���� ����Ǿ����ϴ� ��� �װ�)

CURSOR : SQL�� �����ڰ� ������ �� �ִ� ��ü.
(�Ϻ��� ������ ���Ƕ�⺸�ٴ� �����ϱ� ���� �������ڸ� �׷���.)

������ : �����ڰ� ������ Ŀ������ ������� ���� ����, ORACLE����
        �ڵ����� OPEN, ����, FETCH, CLOSE�� �����Ѵ�.
����� : �����ڰ� �̸��� ���� Ŀ��. �����ڰ� ���� �����ϸ� 
        ����, OPEN, FETCH, CLOSE �ܰ谡 ����

CURSOR Ŀ���̸� IS     <Ŀ�� ����
    QUERY 
OPEN Ŀ���̸�          <Ŀ�� OPEN
FETCH Ŀ���̸�         <Ŀ�� FETCH(�� ����)
    INTO ����1, ����2 ... 
CLOSE Ŀ���̸�;        <Ŀ�� CLOSE
*/

-- �μ� ���̺��� ��� ���� �μ��̸�, ��ġ ���� ������ ���
SELECT dname, loc
FROM dept;
-- CURSOR�� �̿�
DECLARE
    --Ŀ�� ����
    CURSOR dept_cursor IS
        SELECT dname, loc
        FROM dept;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    --Ŀ������
    OPEN dept_cursor;
    -- SQL%FOUND / SQL%NOTFOUND �� ���������� �� �� ���� ������.
    LOOP
        FETCH dept_cursor INTO v_dname, v_loc;
        -- �������� : FETCH�� �����Ͱ� ���� ��
        EXIT WHEN dept_cursor%NOTFOUND;
        dbms_output.put_line(v_dname||','||v_loc);
    END LOOP;
    CLOSE dept_cursor;
END;
/
-- �� ��� Ŀ���� ���� �ΰ��� �����ٰ� �ϳ��� �޸𸮿� �ø�
-- BULK COLLECT �� ��� ���̺� ��ü�� ������ �ֱ� ������ 
-- ���� ���̺� �����Ͱ� �����̸� ���� ��ü�� �޸𸮿� �ø�









