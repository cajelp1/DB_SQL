

---------join0_3, 0_4, 


SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal>2500 AND empno > 7600
AND dname = 'RESEARCH';



----------------------------------- join1
DESC prod;
DESC lprod;


SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod, lprod
WHERE prod_lgu = lprod_gu;


----------------------------------- join2

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod, buyer
WHERE prod_buyer=buyer_id;


----------------------------------- join3

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE mem_id=cart_member AND cart_prod=prod_id;


----------------------------------- join4

SELECT cycle.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid=cycle.cid 
AND (cnm='brown' OR cnm='sally');


----------------------------------- join5

SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid=cycle.cid AND cycle.pid = product.pid
AND (cnm='brown' OR cnm='sally');


----------------------------------- join6

SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid=cycle.cid AND cycle.pid = product.pid;

select *
from cycle;

SELECT cycle.cid, cnm, cycle.pid, pnm, sum(cnt) cnt
FROM customer, cycle, product
WHERE customer.cid=cycle.cid AND cycle.pid = product.pid 
GROUP BY cycle.cid, cnm, cycle.pid, pnm;


----------------------------------- join7

SELECT cycle.pid, pnm, sum(cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, pnm;









