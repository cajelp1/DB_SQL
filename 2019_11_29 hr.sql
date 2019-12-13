
----------------------------------- join8
DESC countries;
DESC regions;


SELECT regions.region_id, region_name, country_name
FROM countries, regions
WHERE countries.region_id=regions.region_id
AND region_name='Europe';


----------------------------------- join9

SELECT regions.region_id, region_name, country_name, city
FROM countries, regions, locations
WHERE countries.region_id=regions.region_id
AND countries.country_id=locations.country_id
AND region_name='Europe';


----------------------------------- join10

SELECT regions.region_id, region_name, country_name, city
FROM countries, regions, locations, departments
WHERE countries.region_id=regions.region_id
AND countries.country_id=locations.country_id
AND locations.location_id=departments.location_id
AND region_name='Europe';


----------------------------------- join11
SELECT *
FROM employees;


SELECT regions.region_id, region_name, country_name, city
      ,department_name, concat(first_name, last_name) name
FROM countries, regions, locations, departments, employees
WHERE countries.region_id = regions.region_id
AND countries.country_id = locations.country_id
AND locations.location_id = departments.location_id
AND departments.department_id = employees.department_id
AND region_name='Europe';


----------------------------------- join12

SELECT employee_id, concat(first_name, last_name) name
      ,jobs.job_id, job_title
FROM jobs, employees
WHERE jobs.job_id = employees.job_id;


----------------------------------- join13
SELECT *
FROM employees;



SELECT manager_id mng_id, mgr_name, employee_id, concat(first_name, last_name) name
      ,jobs.job_id, job_title
FROM jobs, employees
WHERE jobs.job_id = employees.job_id;



SELECT o.manager_id mng_id, concat(t.first_name, t.last_name) mgr_name
      ,o.employee_id, concat(o.first_name, o.last_name) name, jobs.job_id
      ,job_title
FROM employees o, employees t, jobs
WHERE o.manager_id = t.employee_id
AND jobs.job_id = o.job_id;


SELECT *
FROM employees o, employees t
WHERE o.manager_id = t.employee_id;

SELECT t.manager_id mng_id, concat(o.first_name, o.last_name) mgr_name
      ,t.employee_id, concat(t.first_name, t.last_name) name, jobs.job_id
      ,jobs.job_title
FROM employees o, employees t, jobs
WHERE o.employee_id = t.manager_id
AND jobs.job_id = t.job_id;






