#视图
/*
含义：虚拟表， 和普通表一样使用

mysql15.1版本出现的新特色，是通过表动态生成的数据

*/

#案例：查询姓张的学生名和专业名
select student_name, major_name from student_info s inner join major m on s.major_id=m.id where s.student_name like 'J';

create view v1 as select student_name, major_name from student_info s inner join major m on s.major_id=m.id;
select * from v1 where student_name like 'J';

#一、创建视图
/*
语法：
create view 视图名 as 查询语句；
*/
use myemployees;
#1、查询邮箱中包含a字符的员工名、部门名和工种信息
drop view  if exists employee_department_info;
create view employee_department_info as select e.last_name, e.first_name, d.department_name, j.*
from employees e 
inner join departments d on e.department_id = d.department_id 
inner join jobs j on e.job_id=j.job_id;

select * from employee_department_info EDI where last_name like '%a%' ;

#2、查询各部门的平均工资级别
create view average_salary_per_department as
select avg(salary) avg_salary, department_id from employees group by department_id;
select avg_salary, department_id, grade_level from average_salary_per_department  A inner join job_grades J on A.avg_salary between J.lowest_sal and J.highest_sal;

#3、查询平均工资最低的部门信息
select * from departments d where d.department_id=(select department_id from average_salary_per_department order by avg_salary asc limit 1);

#4、查询平均工资最低的部门名和工资
select * from departments d inner join (select * from average_salary_per_department order by avg_salary asc limit 1) as min_avg on d.department_id=min_avg.department_id;
