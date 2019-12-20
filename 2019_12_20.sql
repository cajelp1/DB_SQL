

-- ���� �� ����
SELECT empno, ename, b.a, SUM(c.b)
FROM
--    (SELECT aa.*, ROWNUM rn FROM
--        (SELECT empno, ename, sal FROM emp
--         ORDER BY sal, empno) aa) a,          
-- ���� �ִ� �÷��� �Ʒ� b���� �� ������ ��
    (SELECT bb.*, ROWNUM rn FROM
         (SELECT sal a, empno, ename FROM emp 
          ORDER BY sal, empno) bb) b,
    (SELECT cc.*, ROWNUM rn FROM
         (SELECT sal b FROM emp 
          ORDER BY sal, empno) cc) c
WHERE b.rn >= c.rn AND a.rn = b.rn
GROUP BY b.rn, empno, ename, b.a
ORDER BY b.rn;



-- hash join
SELECT *
FROM dept, emp
WHERE dept.deptno = emp.deptno;
-- DEPT ���� �д� ����
-- join �÷��� hash �Լ��� ������ �ش� �ؽ� �Լ��� �ش��ϴ� bucket�� ����
-- 10 --> aaabbaa (hashvalue �ؽð���? ���Ƿ�? ��????)


-- emp ���̺� ���� ���� ������ �����ϰ� ������
-- 10 -->c ccc1122 (hashvalue)

-- ��ü �ؽ��Լ���°� ����....



-- ppt ����
-- �����ȣ, ����̸�, �μ���ȣ, �޿�, �μ����� ��ü �޿���
SELECT empno, ename, deptno, sal, 
       SUM(sal) OVER() c_sum
FROM emp;

-- �츮�� ���Ϸ��°� ���� ����,
-- ���� �޿����� ���� �޿��� �޴� ����� ���� ���̴�
SELECT empno, ename, deptno, sal, 
       SUM(sal) OVER(ORDER BY sal 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum 
       --���� ó������ ���������
FROM emp;

-- �ٵ� �� ���� �׳� �������� �ϸ� �Ǵµ�....?
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER(ORDER BY sal) c_sum
FROM emp;

-- ���� �������� ���� unbounded preceding �� �ϸ�?
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;
-- ����Ŭ�� ��������... �������̶� �Բ� ���̴±���. 
-- �ٸ��� �غ���
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER(UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;
-- �̰͵� ����������


-- ���� ���� �� �ٷ� �� ����� �޿����� �˰�ʹٸ�?
-- n PRECEDING, n FOLLOWING
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER(ORDER BY sal
       ROWS BETWEEN 1PRECEDING AND CURRENT ROW) c_sum
FROM emp;
-- �ٸ� ���� ���� ����?
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER(ORDER BY sal
       ROWS 1PRECEDING) c_sum
FROM emp;
-- ��... BETWEEN �̶� AND ������ �κ��� ���� �����ϳ�...


-- ana7
SELECT empno, ename, deptno, sal
        ,SUM(sal) OVER (PARTITION BY deptno ORDER BY sal) c_sum
FROM emp;
-- ��.. �Լ� �����̴ϱ� WINDOW�Լ� �߰��� ������...
SELECT empno, ename, deptno, sal
        ,SUM(sal) OVER (PARTITION BY deptno ORDER BY sal
         ROWS UNBOUNDED PRECEDING) c_sum
FROM emp;


-- rows�� range ����
SELECT empno, ename, deptno, sal
    ,SUM(sal) OVER (ORDER BY sal) s_sum     
    -- ����.. �ƹ��͵� �Ⱦ��� rows�� �ƴ϶� range�� ����ǳ�
    ,SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum
    ,SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum
    ,SUM(sal) OVER (ORDER BY sal RANGE 
    BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) bt_range
    --RANGE�� between �� �ᵵ �׳� �׷���... ������?
FROM emp;
-- range�� �� ������ ���� ���� �ϳ��� ���� ����...!!!!!


/*
-------------PL/SQL--------------
�⺻���� :
    DECLARE : �����, ������ �����ϴ� �κ�
    BEGIN : PL/SQL�� ������ ���� �κ�
    EXCEPTION : ����ó����
*/

-- 1. DBMS_OUTPUT.PUT_LINE �Լ��� ����ϴ� �����
--    ȭ�鿡 �����ֵ��� Ȱ��ȭ
SET SERVEROUTPUT ON ;


DECLARE --�����
    -- java : Ÿ�� ������;
    -- pl/sql : ������ Ÿ��;
    v_dname VARCHAR2(14);
    v_loc VARCHAR2(13);
BEGIN -- �������
    -- DEPT ���̺��� 10�� �μ��� �μ��̸�, LOC������ ��ȸ
    SELECT dname, loc
    INTO v_dname, v_loc
    FROM dept
    WHERE deptno = 10;
    
    -- System.out.println(a+b) ..�ڹ� ���ڿ� ������ +
    -- pl/sql�� ||�� ���
    DBMS_OUTPUT.PUT_LINE(v_dname || v_loc);

END;
/ 
--�� �����ô� PL/SQL ����� �����϶�� ��ɾ�. ���� �ּ��� ������
--          ������ ������ ��...
--ó���δ� ����

-- ���� �츮�� ����� Anonymous block.


-- ���� �÷��� Ÿ���� �ٲ� �� �ִ�. �׷� ���� ���� ���۷��� Ÿ������ ����
SET SERVEROUTPUT ON ;

DECLARE 
    v_dname dept.dname %TYPE;
    v_loc dept.loc %TYPE;
BEGIN 
    SELECT dname, loc
    INTO v_dname, v_loc
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dname || v_loc);
END;
/ 


-- anonymous ��� ���� procedure ����� ������
PROCEDURE name IS 
(IN param OUT param IN OUT param);

-- 10�� �μ��� �μ��̸�, ��ġ������ ��ȸ�ؼ� ������ ���
-- ������ DBMS_OUTPUT.PUT_LINE �Լ��� �ֿܼ� ���
CREATE OR REPLACE PROCEDURE printdept IS
    -- �����
    dname dept.dname %TYPE;
    loc dept.loc %TYPE;
    -- �����
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = 10;
    DBMS_OUTPUT.PUT_LINE (dname||' '||loc);
    -- ����ó����(�ɼ�)
END;
/


exec printdept;


-- ������� ������ 10�̶�� ���� �����Ǿ� �ִµ� �긦 PARAM���� ������?

CREATE OR REPLACE PROCEDURE printdept 
-- �Ķ���͸� IN/OUT Ÿ��
-- p_
(p_deptno IN dept.deptno%TYPE)
IS
    dname dept.dname %TYPE;
    loc dept.loc %TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;    -- �� �κ��� �ٲ�
    DBMS_OUTPUT.PUT_LINE (dname||' '||loc);
END;
/

exec printdept(50);

select *
from emp;


-- �ǽ� pro_1
CREATE OR REPLACE PROCEDURE printemp
(e_empno IN emp.empno%TYPE) IS
    ename emp.ename%TYPE;
    dname dept.dname%TYPE;
BEGIN SELECT e.ename, d.dname
      INTO ename, dname
      FROM emp e, dept d
      WHERE e.deptno = d.deptno
      AND e.empno = e_empno;    --���ٳ� �Ѥ� �� ���� �̸� �� �ٲ����?
      DBMS_OUTPUT.PUT_LINE(ename||'   '||dname);
END;
/
exec printemp(7788);



SELECT *
FROM dept_test;

-- insert ������ pl/sql�� �ִ´�. �ٵ� commit�� ���� �־������
CREATE OR REPLACE PROCEDURE registdept_test
(d_deptno IN dept_test.deptno%TYPE,
 d_dname IN dept_test.dname%TYPE,
 d_loc IN dept_test.loc%TYPE) IS
BEGIN   INSERT INTO dept_test 
        VALUES (d_deptno, d_dname, d_loc);
        COMMIT;
END;
/

exec registdept_test(99, 'ddit', 'daejeon');
SELECT *
FROM dept_test;

INSERT INTO dept_test VALUES (1, 'ASDF', 'ASDFASDF);
-- insert�� �ص� commit�� �� �ϸ� ǥ�ð� �ȵȴ�����... �Ф�






