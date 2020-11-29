select last_name, job_id, salary as sal from employees;

select * from  employees;

select employee_id, last_name,  salary*12 "ANNUAL SALARY" from employees;

desc departments;

select * from departments;

select distinct job_id from employees;

desc employees;

select * from employees;

select concat(employee_id, ',', first_name, ',', last_name, ',', email, ',', phone_number, ',', job_id, ',', salary, ',', ifnull(commission_pct,0), ',', ifnull(manager_id,"no_manager"), ',', department_id, ',', hiredate) as OUT_PUT from employees;