
SELECT *
FROM pc20.users;

SELECT *
FROM jobs;

SELECT *
FROM all_tables
WHERE owner = 'PC20';


-- SELECT * FROM DBA_DATA_FILES; �̰� �����ϼ˴���..


SELECT *
FROM fastfood; -- �̷��� ������. ����� ���̺����� ����������
SELECT *
FROM pc20.fastfood; --�̷��ɿ�. �ٵ� synosym�� ����� �� ������?

-- PC20.fastfood --> fastfood synonym����
-- ���� �� sql�� ���������� �۵��ϴ��� Ȯ��
CREATE SYNONYM fastfood FOR PC20.fastfood;

-- ���� : ���� ����
-- ���� : ���� '�ּ�.��ü�̸�' �� �ּҰ� ������� ������ 
-- ���̺��� ��� �°��� ��

-- ���� synonym �̸��� �ٸ� ���̺��̶� ��ġ��?
-- name is already used by an existing object

SELECT * FROM emp WHERE empno=7788;
SELECT * FROM emp WHERE empno=7869; --���� �ٸ� ������ �����Ϳ� �����
SELECT * FROM emp WHERE empno=:empno; --�̷��� ���� ������ �����Ѵ�
-- ��� �, ������ ����. ������ ���ϰ� �ص� �ȴ�
-- ������ ������ �� ���� ������ ����� ���� �� ���� �� ����


-- multiple insert









