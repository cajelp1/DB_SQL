

-- 달력...  
-- 선생님이 했던 것처럼 CONNECT BY 절을 연결해주고
-- 그룹바이 기준을 MOD((LEVEL-1)/7) 로 해주면 한주마다 0이 나온다.



-- 분석함수 / window함수
-- 오라클은 행간 연산이 취약...?
-- window함수는 고비용 쿼리. 웬만해서는 안 쓰는 것이 좋음...


-- 사원의 부서별 급여(sal)별 순위 구하기
-- 아이고 시블링하기가 어려운데? 레벨을 추가하려면... 흐음....
SELECT ename, sal, deptno, level
FROM emp
START WITH sal IN (SELECT MAX(SAL) FROM EMP GROUP BY DEPTNO)
CONNECT BY sal < PRIOR sal and deptno = PRIOR deptno
ORDER SIBLINGS BY DEPTNO;
--ORDER SIBLINGS BY NVL(parent_seq, seq) DESC;

SELECT ename, sal, deptno (SELECT ROWNUM
                           FROM dual, emp
                           WHERE 
FROM emp
ORDER BY deptno, sal DESC;


-- 1. 먼저 1부터 14까지 카운팅하는 컬럼을 만들고
SELECT ROWNUM
FROM emp;
-- 2. 각 부서에 몇명인지가 나오게 하는 컬럼을 또 만들어서
SELECT COUNT(deptno)
FROM emp
GROUP BY deptno
ORDER BY deptno;
-- 3. 두 컬럼을 카테션 조인하면 14개의 컬럼이 나오겠지...!
SELECT *
FROM (SELECT ROWNUM A
      FROM emp)
JOIN
     (SELECT COUNT(deptno) B
     FROM emp
     GROUP BY deptno
     ORDER BY deptno)
ON;

-- 엥 아닌가...
SELECT *
FROM (SELECT ROWNUM A
      FROM emp),
     (SELECT deptno, COUNT(deptno) B
     FROM emp
     GROUP BY deptno
     ORDER BY deptno)
WHERE a <= b
ORDER BY deptno, a; -- deptno를 넣어야 여기서 order by를 할 수 있다..


-- 여기에 ROWNUM을 기준으로 EMP테이블과 합친다...
SELECT *
FROM
   (SELECT ename, sal, deptno, ROWNUM j_rn
    FROM
        (SELECT ename, sal, deptno
        FROM emp
        ORDER BY deptno, sal DESC)) AA,
   (SELECT A, ROWNUM j_rn
    FROM
        (SELECT *
         FROM (SELECT ROWNUM A
               FROM emp),
              (SELECT deptno, COUNT(deptno) B
              FROM emp
              GROUP BY deptno
              ORDER BY deptno)
         WHERE a <= b
         ORDER BY deptno, a)) BB
WHERE AA.j_rn = BB.j_rn
;


-- 미친.. 쿼리 놓침 ㅡㅡ

SELECT a.ename, a.sal, a.deptno, b.rn
FROM 
(SELECT ename, sal, deptno, ROWNUM j_rn
    FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC)) a,

(SELECT rn, ROWNUM j_rn
FROM
    (SELECT b.*, a.rn
    FROM 
    (SELECT ROWNUM rn
     FROM dual
     CONNECT BY level <= (SELECT COUNT(*) FROM emp)) a,
    
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) b
    WHERE b.cnt >= a.rn
    ORDER BY b.deptno, a.rn )) b
WHERE a.j_rn = b.j_rn;



-- 위의 것을 분석함수로 써보면
SELECT ename, sal, deptno, 
        RANK() OVER (PARTITION BY deptno ORDER BY sal) rank
FROM emp;
-- 파티션은 partition by null도 되는구나!



-- DENSE RANK, ROW NUM
-- RANK : 동일 값에 동일 순위 부여. 1등이 2명일 경우 그 다음 순위 3
-- DENSE_RANK : 동일 값에 동일 순위 부여, 1등이 2명일 경우 그 다음 순위 2
-- ROW_NUMBER :  동일 값에 별도 순위 부여
SELECT ename, sal, deptno, 
        RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) dense_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) row_rank
FROM emp;


-- 실습 ana1
-- 사원 전체 급여순위, 다만 급여가 동일하면 사번이 빠른 사람이 우선순위
SELECT empno, ename, sal, deptno, 
       RANK() OVER (ORDER BY SAL desc, empno) sal_rank,
       DENSE_RANK() OVER (ORDER BY sal desc, empno) dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal desc, empno) row_rank
FROM emp;


-- 실습 no_ana2
-- 모든 사원에 대해 사원번호, 사원이름, 해당 사원이 속한 부서 사원수를 조회
-- 분석함수 안 쓰고~
SELECT empno, ename, sal, deptno, 
       COUNT() OVER (PARTITION BY deptno) sal_rank
FROM emp;

-- 1. 카운팅 하는 쿼리를 만들고 
SELECT deptno, count(deptno)
FROM emp
GROUP BY deptno;
-- 2. 부원수만큼 나오게 곱하기
SELECT empno, ename, a.deptno, cnt 
FROM (SELECT empno, ename, deptno
      FROM emp) a,
    (SELECT deptno, count(deptno) cnt
     FROM emp
     GROUP BY deptno) b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;
-- 원래 테이블에 더하기.. 할 필요없이 A에서 부가컬럼 추가


-- 근데 이거 어차피 emp 테이블에 cnt만 따로 추가해서 조인하는거랑 똑같지 않음?
-- 인라인 뷰를 없애버리쟈
SELECT empno, ename, a.deptno, cnt 
FROM emp a,
    (SELECT deptno, count(deptno) cnt
     FROM emp
     GROUP BY deptno) b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;


-- 사원번호, 사원이름, 부서번호, 부서의 직원수
SELECT empno, ename, deptno, 
--      COUNT(*) OVER (PARTITION BY deptno) cnt --아래랑 같은결과
        COUNT(deptno) OVER (PARTITION BY deptno) cnt
FROM emp;


-- ana2
-- window 함수를 이용해서 모든 사원의 사원번호, 사원이름, 본인급여, 부서번호,
-- 해당 사원이 속한 부서의 평균(평균은 소수 둘째까지)
SELECT empno, ename, sal, deptno,
        ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg
FROM emp;


-- ana3
-- window 함수를 이용해서 모든 사원의 사원번호, 사원이름, 본인급여, 부서번호,
-- 해당 사원이 속한 부서의 가장 높은 급여 조회
SELECT empno, ename, sal, deptno,
        MAX(sal) OVER (PARTITION BY deptno) MAX_SAL
FROM emp;


-- ana4
-- window 함수를 이용해서 모든 사원의 사원번호, 사원이름, 본인급여, 부서번호,
-- 해당 사원이 속한 부서의 가장 낮은 급여 조회
SELECT empno, ename, sal, deptno,
        MIN(sal) OVER (PARTITION BY deptno) MIN_SAL
FROM emp;


-- 실습 ana5
-- 전체 사원을 대상으로 급여순위가 자신보다 한단계 낮은 사람의 급여
-- 급여가 같을때는 입사일자가 빠른 사람이 높은 순위
SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate; --오더바이 확인

SELECT empno, ename, hiredate, sal,
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate) l_sal
FROM emp;


-- 실습 6
SELECT empno, ename, hiredate, job, sal,
        LAG(SAL) OVER (PARTITION BY job ORDER BY sal, hiredate) d
FROM emp;
-- 으으음... LAG랑 LEAD 사용은 정렬을 뭘로 할거냐에 따라 달라진다. 
-- 잘 생각해볼것!


-- 이게뭐람 no_ana3
SELECT SUM(b) c_sum
FROM (SELECT rownum rn, sal a FROM emp ORDER BY sal) a
     (SELECT rownum rn, sal b FROM emp ORDER BY sal) b
WHERE a.rn >= b.rn
GROUP BY a.rn
ORDER BY a.rn;


-- 아이고... a.rn >= b.rn ... 이 부등호를!!!! 못 찾아서!!!!! ㅠㅠㅠㅠ

SELECT empno, ename, sal, c_sum
FROM
    (SELECT AA.*, ROWNUM rnn FROM
        (SELECT empno, ename, sal
        FROM emp ORDER BY sal) aa) CC,
    (SELECT BB.*, ROWNUM rnn FROM
        (SELECT SUM(b) c_sum
        FROM (SELECT aa.*, ROWNUM rn FROM
             (SELECT sal a FROM emp ORDER BY sal) aa) a,
             (SELECT bb.*, ROWNUM rn FROM
             (SELECT sal b FROM emp ORDER BY sal) bb) b
        WHERE a.rn >= b.rn
        GROUP BY a.rn
        ORDER BY a.rn) bb) DD
WHERE cc.rnn = dd.rnn;


-- SUM하고 조인하지말고 조인이랑 SUM을 한번에 해라
SELECT empno, ename, b.a, SUM(c.b)
FROM
    (SELECT aa.*, ROWNUM rn FROM
        (SELECT empno, ename, sal FROM emp
         ORDER BY sal, empno) aa) a,
    (SELECT bb.*, ROWNUM rn FROM
         (SELECT sal a FROM emp 
          ORDER BY sal, empno) bb) b,
    (SELECT cc.*, ROWNUM rn FROM
         (SELECT sal b FROM emp 
          ORDER BY sal, empno) cc) c
WHERE b.rn >= c.rn AND a.rn = b.rn
GROUP BY b.rn, empno, ename, b.a
ORDER BY b.rn;


-- 삽질한거
SELECT DECODE(sal
FROM
(SELECT ROWNUM rn, sal
FROM emp
ORDER BY sal)
CONNECT BY level = (SELECT Count(empno) FROM emp);





