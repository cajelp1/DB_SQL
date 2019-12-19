


-- 12.18�ϱ��� ���� (�����ξ�)

-- ����... -�� +�� �ٲ㺸�ϱ� �� �˰���...
-- �ش� ��¥�� ���� �� ���� ù�Ͽ��� ù������.. �̷� ������ �ٲ������.
SELECT
    MAX(NVL(DECODE(d, 1, dt), dt - (d - 1))) ��, --�ƴ� ���̸� dt�� ���°� �ƴѰ�...???���� ���ڵ尡 ���ٸ� ��Գ�����?
    MAX(NVL(DECODE(d, 2, dt), dt - (d - 2))) ��, 
    MAX(NVL(DECODE(d, 3, dt), dt - (d - 3))) ȭ,
    MAX(NVL(DECODE(d, 4, dt), dt - (d - 4))) ��, 
    MAX(NVL(DECODE(d, 5, dt), dt - (d - 5))) ��, 
    MAX(NVL(DECODE(d, 6, dt), dt - (d - 6))) ��, 
    MAX(NVL(DECODE(d, 7, dt), dt - (d - 7))) ��
FROM
    (SELECT 
            TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
    GROUP BY dt - (d - 1)
    ORDER BY dt - (d - 1);



-- ���� ���� �غ�!
SELECT d,
    NVL(DECODE(d, 1, dt), null ) ��,
    NVL(DECODE(d, 2, dt), dt ) ��, --- ����... �� dt �����Ͱ� �ִ� �����ε� �ű⼭ ���ڵ带 �־ �ΰ��� ������ �����ű���...
                                    -- �ٵ� �� decode�� ���� ���� �ƴѰ� ������...? �� ������ �� dt�� ������� �س����ű���
    NVL(DECODE(d, 3, dt), dt - d ) ȭ, -- �� �ٵ� �̰� ������ �� �Ǵ°���?? ������ ��..?
    NVL(DECODE(d, 4, dt), dt - d ) ��, 
    NVL(DECODE(d, 5, dt), dt - d ) ��, 
    NVL(DECODE(d, 6, dt), dt - d ) ��, 
    NVL(DECODE(d, 7, dt), dt - d ) ��
FROM
    (SELECT 
            TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'));
--    GROUP BY dt - (d - 1)
--    ORDER BY dt - (d - 1);



-- 201910 : 35, ù���� �Ͽ��� : 20190929, �������� ����� : 20191102
(SELECT LD-FD+1
FROM
(SELECT LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')) dt,
       TO_DATE(:yyyymm, 'YYYYMM') -                 -- TO_DATE�ϰ� �׳� ���� ���� �� ���� ù°���� �����±���...
       (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) fd, -- ù��¥���� �� ���� ������ ã�� �ű⼭ ���� ��ü�� ����....
       LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')) + 
       7 - (TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')), 'd')) ld --- ��... �׳� ��¥���ٰ� +�� �Ѵٰ� �����ϸ� �Ǵ±���...
FROM dual));



-- �� ������ Ŀ��Ʈ ���� ������ �ٿ��־��...
SELECT 
        MIN(DECODE(d, 1, dt)) SUN, MIN(DECODE(d, 2, dt)) MON, 
        MIN(DECODE(d, 3, dt)) TUE, MIN(DECODE(d, 4, dt)) WED, 
        MIN(DECODE(d, 5, dt)) THU, MIN(DECODE(d, 6, dt)) FRI, 
        MIN(DECODE(d, 7, dt)) SAT 
FROM
    (SELECT TO_DATE(:yyyymm, 'YYYYMM') -
           (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) + (LEVEL -1) DT,     -- �ش� ���� ù �Ͽ��Ϻ��� �����Ѵ�
           TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') -
           (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) + (LEVEL -1), 'd') D -- ���⵵ �ش� ���� ù �Ͽ��Ϸ� �ٲ۴�
    FROM dual
    CONNECT BY LEVEL <= (SELECT LD-FD+1
                        FROM
                        (SELECT LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')) dt,
                               TO_DATE(:yyyymm, 'YYYYMM') -
                               (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) fd,
                               LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')) + 
                               7 - (TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')), 'd')) ld
                        FROM dual)))
GROUP BY DT-(D-1)
ORDER BY DT-(D-1)
;


------------------------ ����


-- lpad �ֱ�. h_1�ǽ�
SELECT dept_h.*, level, LPAD(' ' , (LEVEL-1)*3)||deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


SELECT LPAD('XXȸ��', 15, '*'),
       LPAD('XXȸ��', 15)
FROM dual;


--- h_2
SELECT deptcd, LPAD(' ' , (LEVEL-1)*3)||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


-- �����. ���� �� �Ʒ����� ���� �ö󰡱�.
SELECT *
FROM dept_h;


-- ��������(dept0_00_0)�� �������� ����� �������� �ۼ�
-- �ڱ� �μ��� �θ� �μ��� ������ �Ѵ�
SELECT dept_h.*,  level --��! �������� ������ ���� 1�� �ǳ�
FROM dept_h
START WITH deptcd = 'dept0_00_0'
-- CONNECT BY PRIOR p_deptcd = deptcd
-- CONNECT BY deptcd = PRIOR p_deptcd --���Ʒ��� ��������!
CONNECT BY deptcd = PRIOR p_deptcd AND col = PRIOR col2 -- �� ���� �Ҹ���
;

-- PRIOR ���� �����ϱ�
SELECT dept_h.*,  level
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd AND PRIOR deptnm LIKE '������%' --�̷��� �÷� 3���� �� ����
;

SELECT dept_h.*,  level
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd AND deptnm LIKE '������%' -- �̷��� �÷��� 2���� ����.
;


-- h_3 ����� ����
SELECT dept_h.*, level, lpad(' ',(level-1)*3)||deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;


-- h_4
SELECT LPAD(' ',(level-1)*3)||s_id, value
FROM h_sum
START WITH ps_id IS NULL
CONNECT BY PRIOR s_id = ps_id;

SELECT *
FROM h_sum;


-- h_5
SELECT LPAD(' ',(level-1)*3)||org_cd, no_emp
FROM NO_EMP
START WITH org_cd = 'XXȸ��'
CONNECT BY parent_org_cd = PRIOR org_cd;

SELECT *
FROM no_emp;



-- pruning branch (����ġ��)
-- ���� ������ �������
-- FROM --> START WITH ~ CONNECT BY --> WHERE
-- ������ CONNECT BY ���� ����� ���
--  . ���ǿ� ���� ���� ROW�� ������ �ȵǰ� ����
-- ������ WHERE ���� ����� ���
--  . START WITH ~ CONNECT BY ���� ���� ���������� ���� �����
--    WHERE���� ����� ��� ���� �ش��ϴ� �����͸� ��ȸ 


-- �ֻ��� ��忡�� ��������� Ž��
-- ����ġ��. connect by ���� �����
SELECT *
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY p_deptcd = PRIOR deptcd AND deptnm != '������ȹ��';

-- WHERE ���� �����
SELECT *
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY p_deptcd = PRIOR deptcd;


-- ������������ ��� ������ Ư���Լ�
-- CONNECT_BY_ROOT(col) ���� �ֻ��� ROW�� COL���� �� ��ȸ
-- SYS_CONNECT_BY_PATH(col, ������) : �ֻ��� row���� ���� �ο����
--                          col���� �����ڷ� �������� ���ڿ�
-- CONNECT_BY_ISLEAF : �ش� ROW�� ������ �������(leaf node)
--      ���ڰ� ����. �� Ű���常 ���� ��
--      leaf node : 1, node, : 0
SELECT deptcd, LPAD(' ', 4*(LEVEL-1))||deptnm
       ,CONNECT_BY_ROOT(deptnm) c_root
       ,LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-') --LTRIM�� ���뱸ó�� ���� ����
       ,CONNECT_BY_ISLEAF
FROM dept_h
START WITH deptcd = 'dept0' --AND deptcd = 'dept0_00' ������ �ΰ��� ������ �ȵǴ±���
CONNECT BY p_deptcd = PRIOR deptcd;


-- h_6

SELECT seq, LPAD(' ',3*(LEVEL-1))||title title
FROM board_test
START WITH seq IN(1,2,4)
CONNECT BY parent_seq = PRIOR seq;


-- h_7
SELECT seq, LPAD(' ',3*(LEVEL-1))||title title
FROM board_test
START WITH parent_seq IS NULL -- ��.. in ���ٴ� �̰� �� ���� �����ε�.
CONNECT BY parent_seq = PRIOR seq
ORDER BY seq desc;


-- h_7 �ٸ� ������ ������ ¥�°�? ��.. �����̴°�
-- h_8

SELECT seq, LPAD(' ',3*(LEVEL-1))||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY parent_seq = PRIOR seq
ORDER SIBLINGS BY seq DESC;


-- h_9 ��! �߰� ���޼�!

SELECT seq, parent_seq,
       LPAD(' ',3*(LEVEL-1))||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY parent_seq = PRIOR seq
ORDER SIBLINGS BY NVL(parent_seq, seq) DESC;

SELECT *
FROM board;


-- ó�� �ߴ� ��...

SELECT seq, LPAD(' ',3*(LEVEL-1))||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY parent_seq = PRIOR seq
ORDER BY connect_by_root(seq) desc, seq ;














