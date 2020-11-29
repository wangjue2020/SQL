#进阶3: 排序查询
/*
引入
		select * from employees;

语法：
		select 查询列表
        from 表
        【where 筛选条件】
        order by 排序列表 【asc｜desc】
特点：
		1. asc代表升序， desc 代表的是降序
        如果不写， 默认是升序
        2. order by 子句可以支持单个字段、多个字段、表达式、函数、别名
        3. order by 子句一般是放在查询语句的最后面， limit子句除外
*/

#案例一： 查询员工信息，要求工资从高到低排序
select * from employees order by salary desc;

#案例二：查询部门编号大于等于90 的员工信息，按照入职时间的先后进行排序
select * from employees where department_id>=90 order by hiredate asc;

#case 3: show all info including annual salary ordered by annual salary ( order by expression) 
select *, salary*12*(1+ifnull(commission_pct,0)) as annual_salary from employees order by salary*12*(1+ifnull(commission_pct,0)) desc;

#case 4: show all info including annual salary ordered by annual salary ( order by nickanme) 
select *, salary*12*(1+ifnull(commission_pct,0)) as annual_salary from employees order by annual_salary desc;

#case 5: show name and salary order by length of name
select length(last_name) len_name, last_name, salary from employees order by length(last_name) desc;

#case 6: show infos , first  order by salary asc, then order by employee_id desc
select * from employees order by salary asc, employee_id desc;


#hwk
# 查询员工的姓名和部门号和年薪， 按年薪降序， 按姓名升序
select concat(first_name, "  ", last_name) as Legal_name, department_id, salary from employees order by salary desc, Legal_name asc;

#选择工资不在8000到17000的员工的姓名和工资， 按工资降序
select concat(first_name, "  ", last_name) as Legal_name, salary from employees where salary <8000 or salary >17000 order by salary desc;

#查询邮箱中包含e的员工的信息，并先按邮箱的字节数降序，再按部门号升序
select *, length(email) from employees where email like "%e%" order by length(email) desc, department_id asc;