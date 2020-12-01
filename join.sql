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