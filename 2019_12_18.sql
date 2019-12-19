


-- 12.18일까지 과제 (박종민씨)

-- 아항... -를 +로 바꿔보니까 좀 알겠음...
-- 해당 날짜를 전부 그 날의 첫일요일 첫월요일.. 이런 식으로 바꿔넣은거.
SELECT
    MAX(NVL(DECODE(d, 1, dt), dt - (d - 1))) 일, --아니 널이면 dt가 없는거 아닌가...???만약 디코드가 없다면 어떻게나오지?
    MAX(NVL(DECODE(d, 2, dt), dt - (d - 2))) 월, 
    MAX(NVL(DECODE(d, 3, dt), dt - (d - 3))) 화,
    MAX(NVL(DECODE(d, 4, dt), dt - (d - 4))) 수, 
    MAX(NVL(DECODE(d, 5, dt), dt - (d - 5))) 목, 
    MAX(NVL(DECODE(d, 6, dt), dt - (d - 6))) 금, 
    MAX(NVL(DECODE(d, 7, dt), dt - (d - 7))) 토
FROM
    (SELECT 
            TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
    GROUP BY dt - (d - 1)
    ORDER BY dt - (d - 1);



-- 위의 쿼리 해부!
SELECT d,
    NVL(DECODE(d, 1, dt), null ) 일,
    NVL(DECODE(d, 2, dt), dt ) 월, --- 아항... 다 dt 데이터가 있는 상태인데 거기서 디코드를 넣어서 널값을 강제로 넣은거구나...
                                    -- 근데 얜 decode한 값이 널이 아닌거 같은데...? 아 어차피 걍 dt를 넣으라고 해놓은거구만
    NVL(DECODE(d, 3, dt), dt - d ) 화, -- 아 근데 이거 연산은 왜 되는거임?? 일주일 전..?
    NVL(DECODE(d, 4, dt), dt - d ) 수, 
    NVL(DECODE(d, 5, dt), dt - d ) 목, 
    NVL(DECODE(d, 6, dt), dt - d ) 금, 
    NVL(DECODE(d, 7, dt), dt - d ) 토
FROM
    (SELECT 
            TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'));
--    GROUP BY dt - (d - 1)
--    ORDER BY dt - (d - 1);



-- 201910 : 35, 첫주의 일요일 : 20190929, 마지막주 토요일 : 20191102
(SELECT LD-FD+1
FROM
(SELECT LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')) dt,
       TO_DATE(:yyyymm, 'YYYYMM') -                 -- TO_DATE하고 그냥 월만 쓰면 그 월의 첫째날이 나오는구나...
       (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) fd, -- 첫날짜에서 그 날의 요일을 찾고 거기서 요일 자체를 뺀다....
       LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')) + 
       7 - (TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')), 'd')) ld --- 아... 그냥 날짜에다가 +를 한다고 생각하면 되는구나...
FROM dual));



-- 저 쿼리를 커넥트 바이 레벨에 붙여넣어라...
SELECT 
        MIN(DECODE(d, 1, dt)) SUN, MIN(DECODE(d, 2, dt)) MON, 
        MIN(DECODE(d, 3, dt)) TUE, MIN(DECODE(d, 4, dt)) WED, 
        MIN(DECODE(d, 5, dt)) THU, MIN(DECODE(d, 6, dt)) FRI, 
        MIN(DECODE(d, 7, dt)) SAT 
FROM
    (SELECT TO_DATE(:yyyymm, 'YYYYMM') -
           (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) + (LEVEL -1) DT,     -- 해당 주의 첫 일요일부터 시작한다
           TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') -
           (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) + (LEVEL -1), 'd') D -- 여기도 해당 주의 첫 일요일로 바꾼다
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


------------------------ 수업


-- lpad 넣기. h_1실습
SELECT dept_h.*, level, LPAD(' ' , (LEVEL-1)*3)||deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


SELECT LPAD('XX회사', 15, '*'),
       LPAD('XX회사', 15)
FROM dual;


--- h_2
SELECT deptcd, LPAD(' ' , (LEVEL-1)*3)||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


-- 상향식. 계층 맨 아래부터 위로 올라가기.
SELECT *
FROM dept_h;


-- 디자인팀(dept0_00_0)을 기준으로 상향식 계층쿼리 작성
-- 자기 부서의 부모 부서와 연결을 한다
SELECT dept_h.*,  level --엥! 시작점이 무조건 레벨 1이 되네
FROM dept_h
START WITH deptcd = 'dept0_00_0'
-- CONNECT BY PRIOR p_deptcd = deptcd
-- CONNECT BY deptcd = PRIOR p_deptcd --위아래가 같은거임!
CONNECT BY deptcd = PRIOR p_deptcd AND col = PRIOR col2 -- 엥 무슨 소리지
;

-- PRIOR 개념 이해하기
SELECT dept_h.*,  level
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd AND PRIOR deptnm LIKE '디자인%' --이러면 컬럼 3개가 다 나옴
;

SELECT dept_h.*,  level
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd AND deptnm LIKE '디자인%' -- 이러면 컬럼이 2개만 나옴.
;


-- h_3 상향식 쓰기
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
START WITH org_cd = 'XX회사'
CONNECT BY parent_org_cd = PRIOR org_cd;

SELECT *
FROM no_emp;



-- pruning branch (가지치기)
-- 계층 쿼리의 실행순서
-- FROM --> START WITH ~ CONNECT BY --> WHERE
-- 조건을 CONNECT BY 절에 기술한 경우
--  . 조건에 따라 다음 ROW로 연결이 안되고 종료
-- 조건을 WHERE 절에 기술한 경우
--  . START WITH ~ CONNECT BY 절에 의해 계층형으로 나온 결과에
--    WHERE절에 기술한 결과 값에 해당하는 데이터만 조회 


-- 최상위 노드에서 하향식으로 탐색
-- 가지치기. connect by 절에 기술함
SELECT *
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY p_deptcd = PRIOR deptcd AND deptnm != '정보기획부';

-- WHERE 절에 기술함
SELECT *
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY p_deptcd = PRIOR deptcd;


-- 계층쿼리에서 사용 가능한 특수함수
-- CONNECT_BY_ROOT(col) 가장 최상위 ROW의 COL정보 값 조회
-- SYS_CONNECT_BY_PATH(col, 구분자) : 최상위 row에서 현재 로우까지
--                          col값을 구분자로 연결해준 문자열
-- CONNECT_BY_ISLEAF : 해당 ROW가 마지막 노드인지(leaf node)
--      인자가 없다. 걍 키워드만 쓰면 됨
--      leaf node : 1, node, : 0
SELECT deptcd, LPAD(' ', 4*(LEVEL-1))||deptnm
       ,CONNECT_BY_ROOT(deptnm) c_root
       ,LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-') --LTRIM을 관용구처럼 같이 쓴다
       ,CONNECT_BY_ISLEAF
FROM dept_h
START WITH deptcd = 'dept0' --AND deptcd = 'dept0_00' 시작을 두개로 잡으면 안되는구마
CONNECT BY p_deptcd = PRIOR deptcd;


-- h_6

SELECT seq, LPAD(' ',3*(LEVEL-1))||title title
FROM board_test
START WITH seq IN(1,2,4)
CONNECT BY parent_seq = PRIOR seq;


-- h_7
SELECT seq, LPAD(' ',3*(LEVEL-1))||title title
FROM board_test
START WITH parent_seq IS NULL -- 음.. in 보다는 이게 더 나은 쿼리인듯.
CONNECT BY parent_seq = PRIOR seq
ORDER BY seq desc;


-- h_7 다른 식으로 쿼리를 짜는건? 음.. 힘들어보이는걸
-- h_8

SELECT seq, LPAD(' ',3*(LEVEL-1))||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY parent_seq = PRIOR seq
ORDER SIBLINGS BY seq DESC;


-- h_9 와! 추가 안햇서!

SELECT seq, parent_seq,
       LPAD(' ',3*(LEVEL-1))||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY parent_seq = PRIOR seq
ORDER SIBLINGS BY NVL(parent_seq, seq) DESC;

SELECT *
FROM board;


-- 처음 했던 답...

SELECT seq, LPAD(' ',3*(LEVEL-1))||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY parent_seq = PRIOR seq
ORDER BY connect_by_root(seq) desc, seq ;














