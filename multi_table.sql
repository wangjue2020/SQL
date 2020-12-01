#进阶6:连接查询
/*
含义：又称为多表查询， 当查询的字段来自于多个表时，就会用到连接查询ALTER
笛卡尔乘积：表1 有m行， 表2有n行，结果有m*n行ALTER

发生原因：没有有效的连接条件
如果避免：添加有效的连接条件

分类：
		按年代分类： 
				sql92 标准	： 仅仅支持内连接
                sql99 标准【推荐】： 支持内连接+ 外连接（左外和右外） + 交叉连接
		按功能分类：
				内连接：
						等值连接
                        非等值连接
                        自连接
				外连接：
						左外连接
                        右外连接
                        全外连接
				交叉连接
*/
select * from beauty;
select * from boys;

select name, boyName from boys, beauty where boyfriend_id = boys.id;

#一、sql92 标准
#1、等值连接
/*
	-- 多表等值连接的结果为多表的交集部分
    -- n表连接，至少需要n-1各连接条件
    -- 多表的顺序没有要求
    --一般需要为表起别名
    --可以搭配前面介绍的所有子句使用，比如排序、分组、筛选
#案例1: 查询女生名和男朋友的名字
select name, boyName from boys, beauty where boyfriend_id = boys.id;

#案例2:查询员工名和对应的部门名
select last_name, first_name, EMP.department_id, department_name from myemployees.employees EMP, myemployees.departments DEP where EMP.department_id = DEP.department_id;

#2、为表其别名
/*
 -- 提高语句的简洁度
 --区分多个重名的字段
 注意：如果为表其别名，则查询的字段就不能使用原来的表名去限定
*/
#查询员工号、工种号、工种名
select employee_id,EMP. job_id, job_title from employees EMP, jobs  JOB where  EMP.job_id = JOB.job_id;
#3、两个表的顺序是否可以调换
select employee_id,EMP. job_id, job_title from jobs  JOB, employees EMP where  EMP.job_id = JOB.job_id;
#4、可以加筛选？
#案例：查询有奖金的员工名、部门名
select last_name, department_name from employees e, departments d where commission_pct is not null and e.department_id=d.department_id;
#案例2: 查询城市名中第二个字符为o的部门名和城市名
select department_name, city from locations l, departments d where d.location_id = l.location_id;

#5、可以加分组？
#案例1：查询每个城市的部门个数
select count(*), city from locations l, departments d where d.location_id= l.location_id group by d.location_id;
#案例2:查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资
select department_name, d.manager_id, min(salary) from employees e, departments d where e.department_id= d.department_id and commission_pct is not null group by department_name, d.manager_id;

#6、可以加排序
#案例：查询每个工种的工种名和员工的个数，并且按员工个数降序
select job_title, count(*) from jobs j, employees e where e.job_id = j.job_id group by j.job_id order by count(*) desc;

#7、可以实现三表连接？
#案例：查询员工名、部门名和所在的城市
select last_name, first_name, department_name, city from employees e, departments d, locations l where e.department_id=d.department_id and d.location_id=l.location_id;

#2、非等值连接
#案例：查询员工的工资和工资级别
select salary, grade_level from employees, job_grades where salary between lowest_sal and highest_sal;
/*
CREATE TABLE job_grades
(grade_level VARCHAR(3),
 lowest_sal  int,
 highest_sal int);

INSERT INTO job_grades
VALUES ('A', 1000, 2999);

INSERT INTO job_grades
VALUES ('B', 3000, 5999);

INSERT INTO job_grades
VALUES('C', 6000, 9999);

INSERT INTO job_grades
VALUES('D', 10000, 14999);

INSERT INTO job_grades
VALUES('E', 15000, 24999);

INSERT INTO job_grades
VALUES('F', 25000, 40000);
*/

#3、自连接
#案例：查询员工名和上级的名称
select concat(upper(e1.last_name), e1.first_name), concat(upper(e2.last_name), e2.first_name) from employees e1, employees e2 where e1.manager_id = e2.employee_id;

#二、sql99 语法
/*
语法：
	select 查询
    from 表1 别名 【连接类型】join 表2 别名  on 连接条件 
    where 筛选条件
    【group by ..】
    【having ...】
    【order by...】
    

内连接 inner
外连接
		左外 left 【outer】
        右外 right 【outer】
        全外 full 【outer】
交叉连接  cross
*/

#内连接
/*
select 查询列表
from 表1 别名
inner join  表2 别名
on 连接条件

分类：
	等值连接
    非等值连接
    自连接

特点：
	--添加排序、分组、筛选
    -- inner 可以省略
    -- 筛选条件放在where 后面，连接条件放在on后面，提高分离性， 便于阅读
    -- inner join 连接和sql92语法中的等值连接效果是一样的，都是查询多表的交集

    */
    
    
#1、等值连接
#案例1：查询员工名、部门名
select last_name, first_name, department_name from employees e inner join departments d on e.department_id=d.department_id;
#案例2: 查询名字中包含e的员工名和工种名（添加筛选）
select concat(last_name, first_name), job_title from employees e inner join jobs j on e.job_id=j.job_id where last_name like "%e%" or first_name like "%e%";
#案例3:查询部门个数大于3的城市名和部门个数（添加分组+筛选）
select city, count(*) from locations l inner join departments d on l.location_id=d.location_id group by city having count(*) > 3;
#案例4:查询哪个部门的员工个数>3的部门名和员工个数，并按个数降序（添加排序）
select department_name, count(*) from employees e inner join departments d on e.department_id=d.department_id group by e.department_id having count(*)>3 order by count(*) desc;
#案例5:查询员工名、部门名、工种名、并按部门名降序
select last_name, first_name, department_name, job_title from employees e inner join departments d on e.department_id=d.department_id inner join jobs j on e.job_id=j.job_id order by department_name desc;