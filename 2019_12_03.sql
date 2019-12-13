

-- OUTERJOIN 4

SELECT product.pid, product.pnm, 
       :CID CID, NVL(cycle.day,0) DAY, NVL(cycle.cnt,0) CNT
FROM cycle, product
WHERE cid(+) = :CID       -- 아.. 여기에 (+)를 붙이는걸 못봤네...
                          -- 바인드 변수가 뭐더라???
AND cycle.pid(+) = product.pid;



SELECT product.pid, product.pnm, 
       :CID, customer.CNM, NVL(cycle.day,0) DAY, NVL(cycle.cnt,0) CNT
FROM customer, cycle, product
WHERE cycle.cid(+) = :CID AND customer.cid(+) = cycle.cid --brown이 비네
AND cycle.pid(+) = product.pid;



SELECT a.pid, a.pnm, a.cid, customer.cnm, a.day, a.cnt
FROM 
(SELECT product.pid, product.pnm, 
       :CID cid, NVL(cycle.day,0) DAY, NVL(cycle.cnt,0) CNT
FROM cycle, product
WHERE cycle.cid(+) = :CID 
AND cycle.pid(+) = product.pid) a, customer
WHERE a.cid = customer.cid;


-- ㅠㅠ.. 쉽게 할 수 있으면 좋겠다.. 잘 하면 좋겠다아...

select *
from product left outer join cycle 
    on (product.pid = cycle.pid and cid=1)
    ;




--- crossjoin1

select *
from customer, product;



--------------------------------------복습!

--1. 버거지수대로 데이터를 정렬해서 뽑아내라 
--   버거킹+맥도날드+kfc/롯데리아
--2. 순위/시도/시군구/도시발전지수(소수점 첫번째 자리까지(1). 둘째에서 반올림)
--(sido, sigungu, 도시발전지수)


--롯데리아 없는 시군구는 제외함
--포함하려면??
select *
from
(SELECT ROWNUM rank, C.*
FROM
    (SELECT b.sido sido, b.sigungu sigungu, NVL(round(a.cnt_1/b.cnt_2,1),0) 도시발전지수
    FROM
        (SELECT sido, sigungu, count(sigungu) cnt_1
        FROM fastfood
        WHERE gb IN('버거킹','맥도날드','KFC')
        GROUP BY sido, sigungu) a
    RIGHT OUTER JOIN
        (SELECT sido, sigungu, count(sigungu) cnt_2
        FROM fastfood
        WHERE gb='롯데리아'
        GROUP BY sido, sigungu) b
    ON( a.sigungu=b.sigungu and a.sido=b.sido)
    ORDER BY 도시발전지수 DESC) c) e
right outer JOIN
(SELECT ROWNUM RANK, D.*
FROM
    (SELECT sido, sigungu, round(sal/people,1) 인당근로소득
    FROM tax
    ORDER BY 인당근로소득 DESC, sido) d) F
ON(f.rank = e.rank)
ORDER BY f.rank
;

---우웨ㅔㅔㅔㅔㄱ







