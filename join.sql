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
    
    
#一、等值连接
#案例1：查询员工名、部门名
select last_name, first_name, department_name from employees e inner join departments d on e.department_id=d.department_id;
#案例2: 查询名字中包含e的员工名和工种名（添加筛选）
select concat(last_name, first_name), job_title from employees e inner join jobs j on e.job_id=j.job_id where last_name like "%e%" or first_name like "%e%";
#案例3:查询部门个数大于3的城市名和部门个数（添加分组+筛选）
select city, count(*) from locations l inner join departments d on l.location_id=d.location_id group by city having count(*) > 3;
#案例4:查询哪个部门的员工个数>3的部门名和员工个数，并按个数降序（添加排序）
select department_name, count(*) from employees e inner join departments d on e.department_id=d.department_id group by e.department_id having count(*)>3 order by count(*) desc;
#案例5:查询员工名、部门名、工种名、并按部门名降序(添加三表连接）
select last_name, first_name, department_name, job_title from employees e inner join departments d on e.department_id=d.department_id inner join jobs j on e.job_id=j.job_id order by department_name desc;

#二、非等值连接
#查询员工的工资级别
select  salary, grade_level from employees e join job_grades g on e.salary between lowest_sal and highest_sal;
#查询每个工资级别的个数>2的个数，并且按工资级别降序
select grade_level, count(*) from employees e join job_grades g on e.salary between lowest_sal and highest_sal group by grade_level having count(*)>2 order by grade_level desc;

#三、自连接
#查询员工的名字、上级的名字
select concat(Upper(e1.last_name), "  ", e1.first_name) employee_name, concat(upper(e2.last_name),'  ', e2.first_name) manager_name from employees e1 join employees e2 on e1.manager_id=e2.employee_id;
#查询姓名中包含字符k的员工的名字、上级的名字
select concat(Upper(e1.last_name), "  ", e1.first_name) employee_name, concat(upper(e2.last_name),'  ', e2.first_name) manager_name from employees e1 join employees e2 on e1.manager_id=e2.employee_id where e1.last_name like "%k%" or e1.first_name like '%k%';

#外连接
/*
应用场景：用于查询一个表有，一个表没有的记录
特点：
	-- 外连接的查询结果为主表中的所有记录
		如果从表中有和它匹配的，则显示匹配的值
        如果从表中没有和它匹配的，则显示null
        外连接查询结果=内连接查询结果+主表中有而从表没有的记录
	-- 左外连接： 主表 left join 从表
		右外连接：从表 right join 主表
	-- 左外和右外交换两个表的舒徐，可以实现同样的效果
    -- 全外连接=内连接的结果+表1中有但表2中没有的+表2中有但表1中没有的
#引入：查询男朋友不在男生表的女生名
*/
select b.name from beauty b left join boys bo on b.boyfriend_id=bo.id where bo.id is null;
select b.name from boys bo right join beauty b on b.boyfriend_id=bo.id where bo.id is null;
#查询哪个部门没有员工
select d.* , e.*from departments d left join  employees e on d.department_id=e.department_id where e.employee_id is null;
#全外 mysql 不支持全外连接
#select b.*, bo.* from beauty b full outer join boys bo on b.boyfriend_id=bo.id;

#交叉连接 笛卡尔连接
select b.*, bo.* from beauty b cross join boys bo;

#sql92 VS sql99
/*
功能： sql99 支持的较多
可读性：sql99实现连接条件和筛选条件的分离
*/
#hwk
#查询编号>3 的女生的男朋友信息，如果有则列出详细，如果没有，用null填充
select b.*, bo.* from beauty b left join boys bo on b.boyfriend_id=bo.id where b.id>3;
#查询哪个城市没有部门
select l.*, d.* from locations l left join departments d on l.location_id=d.location_id where d.department_id is null;
#查询部门名为sal或it的员工信息
select d.*,e.* from departments d left join employees e on e.department_id=d.department_id where d.department_name in ('SAL','IT');