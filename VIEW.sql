#视图
/*
含义：虚拟表， 和普通表一样使用

mysql15.1版本出现的新特色，是通过表动态生成的数据

视图		create view		没有实际占用物理空间,只保存了sql逻辑			在使用上可以增删改查，一般不能增删改
表		create table		保存了数据														在使用上可以增删改查

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

#二、视图的修改
#方式一：
/*
create  or replace view as 查询语句；
*/
select * from average_salary_per_department ;
create or  replace view average_salary_per_department  as select avg(salary), job_id from employees group by job_id;

#方式二：
/*
语法：
alter view 视图名 as 查询语句；
*/
 alter view average_salary_per_department  as select * from employees;
 
 #三、删除视图
 /*
 语法： drop view 视图名，视图名，...；
 */
 drop view average_salary_per_department, employee_department_info;
 
 #四、查看视图
 desc average_salary_per_department;
 show create view average_salary_per_department;
 
 
 #hwk
 #创建视图emp_v1， 要求查询电话号码以‘011’开头的员工姓名和工资、邮箱
 create or replace view emp_v1 as select last_name, first_name, salary, email from employees where phone_number like '011%';
 select * from emp_v1;
 select * from employees;
 #创建视图emp_v2， 要求查询部门的最高工资高于12000的部门信息
 create or replace view emp_v2 as
 select d.* from departments d join (select max(salary), department_id from employees group by department_id having max(salary) > 12000) as maxi on d.department_id=maxi.department_id;
select * from emp_v2;

#五、视图的更新
create or replace view myv1 as 
select last_name, email from employees;

select * from myv1;
#1、插入
insert into myv1 values('John', 'john@qq.com');
#2、修改
update myv1 set last_name="Lucy" where last_name="John";
#3、删除
delete from myv1 where last_name='Lucy';
#具备以下特点的视图不允许更新
/*
1、包含一下关键字的sql语句：分组函数、distinct、group by、 having、union 或者union all
2、常量视图	select 'john' name;
3、select 中包含子查询
4、join
5、from 一个不能更新的视图
6、where 子句的子查询阴阳路from子句中的表