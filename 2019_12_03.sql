

-- OUTERJOIN 4

SELECT product.pid, product.pnm, 
       :CID CID, NVL(cycle.day,0) DAY, NVL(cycle.cnt,0) CNT
FROM cycle, product
WHERE cid(+) = :CID       -- ��.. ���⿡ (+)�� ���̴°� ���ó�...
                          -- ���ε� ������ ������???
AND cycle.pid(+) = product.pid;



SELECT product.pid, product.pnm, 
       :CID, customer.CNM, NVL(cycle.day,0) DAY, NVL(cycle.cnt,0) CNT
FROM customer, cycle, product
WHERE cycle.cid(+) = :CID AND customer.cid(+) = cycle.cid --brown�� ���
AND cycle.pid(+) = product.pid;



SELECT a.pid, a.pnm, a.cid, customer.cnm, a.day, a.cnt
FROM 
(SELECT product.pid, product.pnm, 
       :CID cid, NVL(cycle.day,0) DAY, NVL(cycle.cnt,0) CNT
FROM cycle, product
WHERE cycle.cid(+) = :CID 
AND cycle.pid(+) = product.pid) a, customer
WHERE a.cid = customer.cid;


-- �Ф�.. ���� �� �� ������ ���ڴ�.. �� �ϸ� ���ڴپ�...

select *
from product left outer join cycle 
    on (product.pid = cycle.pid and cid=1)
    ;




--- crossjoin1

select *
from customer, product;



--------------------------------------����!

--1. ����������� �����͸� �����ؼ� �̾Ƴ��� 
--   ����ŷ+�Ƶ�����+kfc/�Ե�����
--2. ����/�õ�/�ñ���/���ù�������(�Ҽ��� ù��° �ڸ�����(1). ��°���� �ݿø�)
--(sido, sigungu, ���ù�������)


--�Ե����� ���� �ñ����� ������
--�����Ϸ���??
select *
from
(SELECT ROWNUM rank, C.*
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
(SELECT ROWNUM RANK, D.*
FROM
    (SELECT sido, sigungu, round(sal/people,1) �δ�ٷμҵ�
    FROM tax
    ORDER BY �δ�ٷμҵ� DESC, sido) d) F
ON(f.rank = e.rank)
ORDER BY f.rank
;

---����ĤĤĤĤ�







