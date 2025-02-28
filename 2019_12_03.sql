

-- OUTERJOIN 4

SELECT product.pid, product.pnm, 
       :CID CID, NVL(cycle.day,0) DAY, NVL(cycle.cnt,0) CNT
FROM cycle, product
WHERE cid(+) = :CID       -- 焼.. 食奄拭 (+)研 細戚澗杏 公挫革...
                          -- 郊昔球 痕呪亜 更希虞???
AND cycle.pid(+) = product.pid;



SELECT product.pid, product.pnm, 
       :CID, customer.CNM, NVL(cycle.day,0) DAY, NVL(cycle.cnt,0) CNT
FROM customer, cycle, product
WHERE cycle.cid(+) = :CID AND customer.cid(+) = cycle.cid --brown戚 搾革
AND cycle.pid(+) = product.pid;



SELECT a.pid, a.pnm, a.cid, customer.cnm, a.day, a.cnt
FROM 
(SELECT product.pid, product.pnm, 
       :CID cid, NVL(cycle.day,0) DAY, NVL(cycle.cnt,0) CNT
FROM cycle, product
WHERE cycle.cid(+) = :CID 
AND cycle.pid(+) = product.pid) a, customer
WHERE a.cid = customer.cid;


-- ばば.. 襲惟 拝 呪 赤生檎 疏畏陥.. 設 馬檎 疏畏陥焼...

select *
from product left outer join cycle 
    on (product.pid = cycle.pid and cid=1)
    ;




--- crossjoin1

select *
from customer, product;



--------------------------------------差柔!

--1. 獄暗走呪企稽 汽戚斗研 舛慶背辞 嗣焼鎧虞 
--   獄暗天+呼亀劾球+kfc/茎汽軒焼
--2. 授是/獣亀/獣浦姥/亀獣降穿走呪(社呪繊 湛腰属 切軒猿走(1). 却属拭辞 鋼臣顕)
--(sido, sigungu, 亀獣降穿走呪)


--茎汽軒焼 蒸澗 獣浦姥澗 薦須敗
--匂敗馬形檎??
select *
from
(SELECT ROWNUM rank, C.*
FROM
    (SELECT b.sido sido, b.sigungu sigungu, NVL(round(a.cnt_1/b.cnt_2,1),0) 亀獣降穿走呪
    FROM
        (SELECT sido, sigungu, count(sigungu) cnt_1
        FROM fastfood
        WHERE gb IN('獄暗天','呼亀劾球','KFC')
        GROUP BY sido, sigungu) a
    RIGHT OUTER JOIN
        (SELECT sido, sigungu, count(sigungu) cnt_2
        FROM fastfood
        WHERE gb='茎汽軒焼'
        GROUP BY sido, sigungu) b
    ON( a.sigungu=b.sigungu and a.sido=b.sido)
    ORDER BY 亀獣降穿走呪 DESC) c) e
right outer JOIN
(SELECT ROWNUM RANK, D.*
FROM
    (SELECT sido, sigungu, round(sal/people,1) 昔雁悦稽社究
    FROM tax
    ORDER BY 昔雁悦稽社究 DESC, sido) d) F
ON(f.rank = e.rank)
ORDER BY f.rank
;

---酔裾つつつつぁ







