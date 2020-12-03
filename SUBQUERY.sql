#进阶7:子查询
/*含义：
出现在其他语句中的select语句，称为子查询或者内查询
外部的查询语句，称为主查询或外查询

分类：
按子查询出现的位置：
						select 后面：
										仅仅支持标量子查询
                        from 后面：
										支持表子查询
                        where 或having 后面：
										标量子查询 （单行）
                                        列子查询  （多行）
                                        行子查询
                        exists 后面（相关子查询）：
										表子查询
                        
按结果集的行列数不同：
						标量子查询（结果集只有一行一列）
                        列子查询 （结果集只有一列多行）
                        行子查询（结果集有一行多列）
                        表子查询（结果集一般为多行多列）
*/
#一、where 或having 后面
/*
		标量子查询 （单行）
		列子查询  （多行）
		行子查询
        
        特点：
				-- 子查询放在小括号内
                -- 子查询一般放在条件的右侧
                --标量子查询，一般搭配着单行操作符使用
						>, < , <=, >=, =, <>
				-- 列子查询，一般搭配这多行操作符使用
						in、any/some、all
*/
#1、标量子查询
#案例1: 谁的工资比Abel 高？
select * from employees e where e.salary > (select salary from employees where last_name="Abel");
#案例2:返回job_id 于141 号员工相同，salary比143 号员工多的员工姓名，job_id 和工资
select * from employees e where e.job_id=(select job_id from employees where employee_id=141) and salary>(select salary from employees where employee_id=143);
#案例3:返回公司工资最少的员工的last_name, job_id 和salary
select * from employees where salary = (select min(salary) from employees );
#案例4: 查询最低工资大于50号部门最低工资的部门id和其最低工资
select min(salary), department_id from employees group by department_id having min(salary) > (select min(salary) from employees where department_id=50);

#2、列子查询
#案例1: 返回location_id 是1400 或1700 的部门中的所有员工姓名
select * from employees where department_id in ( select distinct department_id from departments where location_id=1400 or location_id=1700);
#案例2: 返回其他部门中比job_id为‘IT_PROG' 部门任意工资低的员工的员工号、姓名、job_id 以及salary
select employee_id, last_name, first_name, job_id, salary from employees where job_id != 'IT_PROG' and salary<any(select salary from employees where  job_id='IT_PROG');
#案例3: 返回其他部门中比job_id为‘IT_PROG' 部门所有工资低的员工的员工好、姓名、job_id 以及salary
select employee_id, last_name, first_name, job_id, salary from employees where job_id != 'IT_PROG' and salary<all(select salary from employees where  job_id='IT_PROG');
select employee_id, last_name, first_name, job_id, salary from employees where job_id != 'IT_PROG' and salary<(select min(salary) from employees where  job_id='IT_PROG');

#3、行子查询（结果集一行多列或多行多列）
#案例：查询员工编号最小并且工资最高的员工信息
select * from employees  where employee_id = (select min(employee_id) from employees) and salary=(select max(salary) from employees);
select * from employees where (employee_id, salary) = (select min(employee_id), max(salary) from employees);

#二、select 后面
/*
仅仅支持标量子查询
*/
#案例：查询每个部门的员工个数
select *, ( select count(*) from employees e where e.department_id=d.department_id group by department_id) from departments d;
#案例2:查询员工号=102的部门名
select (select department_name from departments d where d.department_id=e.department_id) from employees e where e.employee_id=102;

#三、from 后面
#案例1:查询每个部门的平均工资的工资等级
select grade_level, average, department_id from job_grades, (select avg(salary) as average, department_id from employees e group by department_id) a  where a.average between lowest_sal and highest_sal;

#四、exists 后面（相关子查询）
/*
语法：
		exists(完整的查询语句）
结果：
		1或0
*/
select exists(select employee_id from employees where salary=3000);
#案例1: 查询有员工的部门名
select department_name from departments d where d.department_id in (select e.department_id from employees e); 
select department_name from departments d where 1= exists(select * from employees e where e.department_id=d.department_id); 
#案例2:查询没有女朋友的男生信息
select * from boys bo where 0=exists(select * from beauty b where b.boyfriend_id = bo.id);

#hwk
#查询和Zlotkey相同部门的员工姓名和工资
select last_name, first_name from employees where department_id = (select department_id from employees where last_name="Zlotkey");
#查询工资比公司平均工资高的员工的员工号，姓名和工资
select employee_id, last_name, first_name, salary from employees where salary > (select avg(salary) from employees);
#查询各部门中工资比本部门平均工资高的员工的员工号，姓名和工资
select avg(salary), department_id from employees group by department_id;
select last_name, first_name, employee_id, salary from employees e inner join (select avg(salary) as average, department_id from employees group by department_id) as averages on e.department_id=averages.department_id where salary > averages.average;
#查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
select department_id from employees where last_name like "%u%";
select employee_id, last_name from employees where department_id in (select department_id from employees where last_name like "%u%");
#查询在部门的location_id为1700的部门工作的员工的员工号
select department_id from departments where location_id=1700;
select employee_id from employees where department_id in (select department_id from departments where location_id=1700);
#查询管理这是King的员工的员工姓名
select last_name, first_name from employees where manager_id in (select employee_id from employees where last_name='K_ing');
#查询工资最高的员工的姓名， 要求first_name 和 last_name 显示为一列, 列名为姓.名
select concat(upper(last_name),"  ", first_name)from employees where salary=(select max(salary) from employees );

#查询工资最低的员工信息：last_name, salary
select last_name, salary from employees where salary =(select min(salary) from employees);
# 查询平均工资最低的部门信息
select d.* , av.*
from departments  d inner join (select avg(salary) as ave, department_id from employees group by department_id) as av on  d.department_id=av.department_id 
where ave=(select min(salary) from (select avg(salary) as salary from employees group by department_id) as average);
		# 方式二：
select * from departments where department_id=(
select department_id from employees group by department_id order by avg(salary) limit 1);

#查询平均工资最低的部门信息和该部门的平均工资
select d.*, av.* from departments d inner join (select department_id, avg(salary) as salary from employees group by department_id order by avg(salary) limit 1) as av on av.department_id=d.department_id;




