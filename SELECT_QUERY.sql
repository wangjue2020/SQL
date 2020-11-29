#进阶1:基础查询
/*
语法：
select 查询列表 from 表名；
特点： 
1. 查询列表可以是： 表中的字段、常量值、表达式、函数
2. 查询结果是一个虚拟的表格
*/
USE myemployees;
SELECT last_name from employees;
select last_name, salary, email from employees;
select employee_id,first_name,last_name,email,phone_number,job_id from employees;
select * from employees;

#1. 查询常量值
select 100;
select 'john';

# 2. 查询表达式
select 100%98;

# 3. 查询函数
select version();

# 4. 起别名
/*
便于理解
如果要查询的字段有重名的情况，使用别名可以区分开来
*/
# 方式一：使用as
select 100%98 as result;
select last_name as 姓,  first_name as 名 from employees;

#方式二：使用空格
select last_name 姓, first_name 名 from employees;

# 5. 去重
#案例：查询员工表中涉及到的所有的部门编号
select distinct department_id from employees;

#6. +号的作用
/*
mysql 中的+号： 仅仅只有一个功能： 运算符
select 100+90； 两个操作数都为数值型，则做加法运算
select '123'+90;  只要其中一方为字符型，试图将字符型数值转换成数值型，如果转换成功，则继续做加法运算
select 'john'+90; 如果转换失败，则将字符数值转换成0
select null+10;   只要其中一方为null，则结果肯定为null
*/
#案例：查询员工名和姓连接成一个字段，并显示为姓名
SELECT concat(last_name, ' ',first_name) as 姓名 from employees;

#7 IFNULL
SELECT concat(employee_id, ',',first_name,',',last_name,',', ifnull(commission_pct,0)) from employees;
