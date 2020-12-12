#函数
/*
含义： 一组预先编译好的SQL语句的集合，理解称为批处理语句
好处：
	-- 提高代码的重用性
    -- 简化操作
    -- 减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率
    
区别：
存储过程：可以有0个返回，也可以有多个返回，适合做批量插入、批量更新
函数：有且仅有1个返回，适合做处理数据后返回一个结果
*/
#一、创建语法
-- create function 函数名(参数列表) returns 返回类型
-- begin
-- 	函数体
-- end

/*
注意：
-- 参数列表包含两部分：
		参数名		参数类型
-- 函数体： 肯定会有return语句，如果没有会报错
	如果return 语句没有放在函数体的最后也不报错，但不建议
	return 值;
-- 函数体中仅有一句话，则可以省略begin end
-- 使用delimiter 语句设置结束标记
	delimiter $;
*/
#二、调用语法
-- select  函数名(参数列表)
#-------------------------案例演示-------------------------
#1、无参有返回
#案例：返回公司的员工个数
use myemployees;
delimiter $
create function num_employee_company() returns int
begin
	declare c int default 0;
	select count(*) into c from employees;
    return c;
end $
delimiter ;
select num_employee_company();

#2、有参有返回
#案例1: 根据员工名，返回它的工资
delimiter $
create function salary_by_name (name varchar(20) ) returns double
begin
	set @salary:=0;
	select e.salary into @salary from employees e where last_name=name;
    return @salary;
end $
delimiter ;
select salary_by_name('Hunold');
select @salary;

#案例2:根据部门名，返回该部门的平均工资
delimiter $
create function avg_salary_by_department_name (department_name varchar(20)) returns double
begin
		declare avg double default 0;
        select avg(salary) into avg from employees e inner join departments d on e.department_id = d.department_id where d.department_name=department_name group by d.department_id, d.department_name;
		return avg;
end $
delimiter ;
select avg_salary_by_department_name('IT');

#三、查看函数
show create function avg_salary_by_department_name;

#四、删除函数
drop function avg_salary_by_department_name;

