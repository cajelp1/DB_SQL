

-- regions 테이블

CREATE TABLE regions (
    region_id NUMBER,
    region_name VARCHAR2(25),
    CONSTRAINT pk_regions PRIMARY KEY (region_id)
);


-- countries 테이블

CREATE TABLE countries (
    country_id CHAR(2),
    country_name VARCHAR2(40),
    region_id NUMBER,
    CONSTRAINT pk_countries PRIMARY KEY (country_id),
    CONSTRAINT fk_count_reg FOREIGN KEY (region_id)
    REFERENCES regions (region_id)
);


-- location 테이블

CREATE TABLE locations (
    location_id NUMBER(4),
    street_address VARCHAR2(40),
    postal_code VARCHAR2(12),
    city VARCHAR2(30),
    state_province VARCHAR2(25),
    country_id CHAR(2),
    CONSTRAINT pk_location PRIMARY KEY (location_id),
    CONSTRAINT fk_loc_count FOREIGN KEY (country_id)
    REFERENCES countries (country_id)
);


-- department 테이블. 
-- manager id 컬럼이 employees 테이블을 참조하지만 생성되지 않았으므로
-- 일단 테이블을 만든 후 이후 alter로 manager id 컬럼에 fk를 생성한다
-- employees 테이블 역시 department 테이블을 fk로 참조하므로 상대적으로
-- fk가 적은 department 테이블을 먼저 생성한다.

CREATE TABLE departments(
    department_id NUMBER(4),
    department_name VARCHAR2(30),
    manager_id NUMBER(6),
    location_id NUMBER(4),
    CONSTRAINT pk_departments PRIMARY KEY (department_id),
    CONSTRAINT fk_dept_loc FOREIGN KEY (location_id)
    REFERENCES locations (location_id)
);


-- jobs 테이블

CREATE TABLE jobs (
    job_id VARCHAR2(10),
    job_title VARCHAR2(35),
    min_salary NUMBER(6),
    max_salary NUMBER(6),
    CONSTRAINT pk_jobs PRIMARY KEY (job_id)
);


-- job_history 테이블
-- deparments 와 마찬가지로 아직 생성되지 않은 employees 테이블을
-- fk로 참조하고 있으나 employees 를 만들지 않았으므로 본 테이블을
-- 생성 후 alter 로 employee_id에 fk를 만들어준다.

CREATE TABLE job_history (
    employee_id NUMBER(6),
    start_date DATE,
    end_date DATE,
    job_id VARCHAR2(10),
    department_id NUMBER(4),
    CONSTRAINT pk_job_history PRIMARY KEY (employee_id, start_date),
    CONSTRAINT fk_job_h_jobs FOREIGN KEY (job_id)
    REFERENCES jobs (job_id),
    CONSTRAINT fk_job_h_dept FOREIGN KEY (department_id)
    REFERENCES departments (department_id)
);


-- employees 테이블 

CREATE TABLE employees (
    employee_id NUMBER(6),
    first_name VARCHAR2(20),
    last_name VARCHAR2(25),
    email VARCHAR2(25),
    phone_number VARCHAR2(20),
    hire_date DATE,
    job_id VARCHAR2(10),
    salary NUMBER(8,2),
    commission_pct NUMBER(2,2),
    manager_id NUMBER(6),
    department_id NUMBER(4),
    CONSTRAINT pk_employees PRIMARY KEY (employee_id),
    CONSTRAINT fk_emp_dept FOREIGN KEY (department_id)
    REFERENCES departments (department_id),
    CONSTRAINT fk_emp_jobs FOREIGN KEY (job_id)
    REFERENCES jobs (job_id),
    CONSTRAINT fk_emp_emp FOREIGN KEY (manager_id)
    REFERENCES employees (employee_id)
);


-- 모든 테이블이 생성되었으므로 job_history 의 fk와 
-- departments의 fk를 생성한다

ALTER TABLE job_history ADD CONSTRAINT fk_job_h_emp 
    FOREIGN KEY (employee_id) REFERENCES employees (employee_id);
ALTER TABLE departments ADD CONSTRAINT fk_dept_emp 
    FOREIGN KEY (manager_id) REFERENCES employees (employee_id);
-- 망할 괄호 ㅡㅡ


SELECT constraint_name, table_name, constraint_type type
FROM user_constraints
WHERE table_name IN ('JOBS','JOB_HISTORY','DEPARTMENTS'
                    ,'EMPLOYEES','LOCATIONS','COUNTRIES'
                    ,'REGIONS');


COMMIT;





