

-- regions ���̺�

CREATE TABLE regions (
    region_id NUMBER,
    region_name VARCHAR2(25),
    CONSTRAINT pk_regions PRIMARY KEY (region_id)
);


-- countries ���̺�

CREATE TABLE countries (
    country_id CHAR(2),
    country_name VARCHAR2(40),
    region_id NUMBER,
    CONSTRAINT pk_countries PRIMARY KEY (country_id),
    CONSTRAINT fk_count_reg FOREIGN KEY (region_id)
    REFERENCES regions (region_id)
);


-- location ���̺�

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


-- department ���̺�. 
-- manager id �÷��� employees ���̺��� ���������� �������� �ʾ����Ƿ�
-- �ϴ� ���̺��� ���� �� ���� alter�� manager id �÷��� fk�� �����Ѵ�
-- employees ���̺� ���� department ���̺��� fk�� �����ϹǷ� ���������
-- fk�� ���� department ���̺��� ���� �����Ѵ�.

CREATE TABLE departments(
    department_id NUMBER(4),
    department_name VARCHAR2(30),
    manager_id NUMBER(6),
    location_id NUMBER(4),
    CONSTRAINT pk_departments PRIMARY KEY (department_id),
    CONSTRAINT fk_dept_loc FOREIGN KEY (location_id)
    REFERENCES locations (location_id)
);


-- jobs ���̺�

CREATE TABLE jobs (
    job_id VARCHAR2(10),
    job_title VARCHAR2(35),
    min_salary NUMBER(6),
    max_salary NUMBER(6),
    CONSTRAINT pk_jobs PRIMARY KEY (job_id)
);


-- job_history ���̺�
-- deparments �� ���������� ���� �������� ���� employees ���̺���
-- fk�� �����ϰ� ������ employees �� ������ �ʾ����Ƿ� �� ���̺���
-- ���� �� alter �� employee_id�� fk�� ������ش�.

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


-- employees ���̺� 

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


-- ��� ���̺��� �����Ǿ����Ƿ� job_history �� fk�� 
-- departments�� fk�� �����Ѵ�

ALTER TABLE job_history ADD CONSTRAINT fk_job_h_emp 
    FOREIGN KEY (employee_id) REFERENCES employees (employee_id);
ALTER TABLE departments ADD CONSTRAINT fk_dept_emp 
    FOREIGN KEY (manager_id) REFERENCES employees (employee_id);
-- ���� ��ȣ �Ѥ�


SELECT constraint_name, table_name, constraint_type type
FROM user_constraints
WHERE table_name IN ('JOBS','JOB_HISTORY','DEPARTMENTS'
                    ,'EMPLOYEES','LOCATIONS','COUNTRIES'
                    ,'REGIONS');


COMMIT;





