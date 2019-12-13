

-- �������� + �δ�ٷμҵ� 

select f.rank, e.sido, e.sigungu, ���ù�������, f.sido, f.sigungu, �δ�ٷμҵ�
from
    (SELECT ROWNUM rank, c.*
    FROM
        (SELECT b.sido sido, b.sigungu sigungu, NVL(round(a.cnt_1/b.cnt_2,1),0) ���ù�������
        FROM
            (SELECT sido, sigungu, count(sigungu) cnt_1
            FROM fastfood
            WHERE gb IN('����ŷ','�Ƶ�����','KFC')
            GROUP BY sido, sigungu) a
        RIGHT OUTER JOIN
            (SELECT sido, sigungu, count(sigungu) cnt_2
            FROM fastfood
            WHERE gb='�Ե�����'
            GROUP BY sido, sigungu) b
        ON( a.sigungu=b.sigungu and a.sido=b.sido)
        ORDER BY ���ù������� DESC) c) e
right outer JOIN
    (SELECT ROWNUM RANK, d.*
    FROM
        (SELECT sido, sigungu, round(sal/people,1) �δ�ٷμҵ�
        FROM tax
        ORDER BY (sal/people) DESC, sido) d) f
ON(f.rank = e.rank)
ORDER BY f.rank;



UPDATE tax SET people = 70391
WHERE sido='����������'
AND sigungu = '����';
COMMIT;



-- ���ù������� �õ�, �ñ����� �������� ���Աݾ��� �õ�, �ñ����� ���� �������� ����?
-- ���� ������ TAX ���̺��� ID �÷����� ����

select *
from
    (SELECT b.sido sido, b.sigungu sigungu, NVL(round(a.cnt_1/b.cnt_2,1),0) ���ù�������
    FROM
        (SELECT sido, sigungu, count(sigungu) cnt_1
        FROM fastfood
        WHERE gb IN('����ŷ','�Ƶ�����','KFC')
        GROUP BY sido, sigungu) a
    RIGHT OUTER JOIN
        (SELECT sido, sigungu, count(sigungu) cnt_2
        FROM fastfood
        WHERE gb='�Ե�����'
        GROUP BY sido, sigungu) b
    ON(a.sigungu=b.sigungu and a.sido=b.sido)) c
RIGHT OUTER JOIN
    (SELECT id, sido, TRIM(sigungu) sigungu, round(sal/people,1) �δ�ٷμҵ�
    FROM tax) d
ON(d.sido = c.sido AND d.sigungu = c.sigungu)
ORDER BY D.id;



-- SMITH�� ���� �μ� ã�� --> 20
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
               FROM emp
               WHERE ename = 'SMITH');

SELECT empno, ename, deptno,
      (SELECT dname FROM dept WHERE dept.deptno=emp.deptno) dname
FROM emp;



-- SCALAR SUBQUERY
-- SELECT ���� ǥ���� ��������
-- �� ��, �� COLUMN�� ��ȸ�ؾ� �Ѵ�.
SELECT empno, ename, deptno,
      (SELECT dname FROM dept WHERE dept.deptno=emp.deptno) dname
FROM emp;
-- ���� 1:1 ����...


SELECT empno, ename, deptno,
      (SELECT dname FROM dept) dname
FROM emp;


-- INLINE VEIW
-- FROM���� ���Ǵ� ��������

-- SUBQUERY
-- WHERE���� ���Ǵ� ��������


-- ��� �޿����� ���� �޿��� �޴� ���� ���� ��ȸ�϶� SUB1
SELECT COUNT(sal)
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp);


-- ��� �޿����� ���� �޿��� �޴� ���������� ��ȸ�϶� SUB2
SELECT *
FROM emp
where sal > (SELECT AVG(sal) FROM emp);


-- SUB3
-- 1. SMITH, WARD�� ���� �μ� ��ȸ
-- 2. 1���� ���� ������� �̿��Ͽ� �ش� �μ���ȣ�� ���ϴ� ���� ��ȸ

desc fastfood;
SELECT *
FROM EMP;

SELECT *
FROM EMP
WHERE DEPTNO IN (SELECT deptno 
                 FROM emp
                 WHERE ename IN('SMITH', 'WARD'));


-- SMITH�� WARD���� �޿��� ���� ����
SELECT *
FROM emp
WHERE sal < any(SELECT sal 
                FROM emp 
                WHERE ename in ('SMITH', 'WARD'));


-- ������ ������ ���� �ʴ� ��� ���� ��ȸ
SELECT *
FROM emp -- ��� ������ ��ȸ --> �������� ��� ��ȸ
WHERE empno IN (SELECT mgr FROM emp);


-- NOT IN NULL ���ǻ���
SELECT *
FROM emp -- ��� ������ ��ȸ --> �����ڰ� �ƴ� ��� ��ȸ
WHERE empno NOT IN (SELECT mgr FROM emp);
-- �ƹ��͵� �� ����....
-- NOT IN�� ��� NULL�� �÷��� ����߸� ����� �� ������� ���´�. 

-- ���1.
SELECT *
FROM emp -- ��� ������ ��ȸ --> �����ڰ� �ƴ� ��� ��ȸ
WHERE empno NOT IN (SELECT NVL(mgr,-1) -- MGR ���� �� �� �� ���� ���� �־���
                    FROM emp);

-- ���2.
SELECT *
FROM emp -- ��� ������ ��ȸ --> �����ڰ� �ƴ� ��� ��ȸ
WHERE empno NOT IN (SELECT mgr FROM emp WHERE mgr IS NOT NULL); -- NULL ���� ������


-- PAIRWISE ���� �÷��� ���� ���ÿ� �����ؾ��ϴ� ���
-- ALLEN, CLARK�� �Ŵ����� �μ���ȣ�� ���ÿ� ���� ��� ���� ��ȸ
-- (7698, 30)
-- (7839, 10)

SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));


-- ���� ������ ��������?
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN (7499, 7782))
AND deptno IN (SELECT deptno
               FROM emp
               WHERE empno IN (7499, 7782));
-- ������� �ٸ�. 



-- ���ȣ ���� �������� non correlated subquery. 
-- ���������� �÷��� ������������ ������� �ʴ� ������ ���� ����

-- ���ȣ ���� ���������� ��� ������������ ����ϴ� ���̺�,
-- �������� ��ȸ ������ ���������� ������ ������ �Ǵ��Ͽ� ������ �����Ѵ�.
-- ���������� emp ���̺��� ���� ���� ���� �ְ�, ���������� emp ���̺���
-- ���� ���� ���� �ִ�. 

-- ���ȣ ���� ������������ ���������� ���̺��� ���� ���� ����
-- ���������� ������ ������ �ߴ� ��� �� �������� ǥ��... 
-- ���ȣ ���� ������������ ���������� ���̺��� ���߿� ���� ����
-- ���������� Ȯ���� ������ �ߴ� ��� �� �������� ǥ��... 

-- ������ �޿� ��պ��� ���� �޿��� �޴� ���� ���� ��ȸ
-- ������ �޿� ���

SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp);




-- ��ȣ���� ��������
-- ���� �μ��� �޿���պ��� ���� �޿��� �޴� ���� ��ȸ

SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
             FROM emp
             WHERE deptno = m.deptno); --�ƴ� �� �˸��ƽ��� �ٸ��� �ϸ�;;
-- �� ��쿣 ���������� ���� �о �׷�������.. ��ȣ������ �׻� ���긦 ���� �г�?
-- ��. ���⼭�� ���������� ���������� � ������ ����Ǿ� �ִ����� �˷�����.
-- ���������� �ִ� �ֵ鸸 ������ �Ʒ� WHERE���� ���� �Ŷ� �Ȱ��� ��� ���.



-- 10�� �μ��� �޿� ���
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;



--------------------------------------------------------

SELECT NEXT_DAY(SYSDATE, '������')
FROM dual;






