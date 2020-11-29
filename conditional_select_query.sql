#进阶二： 条件查询
/* 语法：
select 查询列表 from 表名 where 筛选条件；
分类： 
	一、 按条件表达式筛选
			条件运算符： > , <, =, !=, <>, >=, <=
	二、 按逻辑表达式筛选
			逻辑运算符： && , ||, ! , and, not, or
	三、模糊查询
			like, between and, in, is null
            
*/
#	一、 按条件表达式筛选
#案例一：查询工资高于12000的员工信息
select * from employees where salary > 12000;
#案例二： 查询部门编号不等于90 号的员工名和部门编号
select first_name, last_name, department_id from employees where department_id <> 90;

#	二、 按逻辑表达式筛选
#案例一： 工资在10000到20000之间的员工名、工资以及奖金
select concat(first_name,'	', last_name), salary, commission_pct from employees where salary between 10000 and 20000;
#案例二： 查询部门编号不是在90到110之间的，或者工资高于15000的员工信息
select * from employees where ( department_id < 90 and department_id > 110) or salary>150000;

#	三、模糊查询
# 一般和通配符搭配使用
# % 任意多个字符，包含0个字符
# _  任意单个字符
# like
# % 表示通配符
#案例一：查询员工名中包含字符a的员工信息
SELECT * FROM Employees where first_name like '%a%' or last_name like '%a%';
#案例二：查询员工中第三个字符为e， 第五个字符为a的员工名和工资
select last_name, salary from employees where last_name like '__n_l%';
#案例三： 查询员工名中第二个字符为_ 的员工名
#escape '$' 是指用'$'说明在$后面的字符不是通配符，而是普通符
select last_name, salary from employees where last_name like '_$_%'  escape  '$' ;

# between and 包含临界值
# 案例一：查询员工编号在100到120之间的
select last_name, employee_id from employees where employee_id between 100 and 120;

# in
# 含义：判断某字段的值是否属于in列表中的某一项
# 特点：1 使用in提高语句简洁度
#			  2 in列表的值类型必须统一或兼容
#			  3 in列表中的值不支持通配符
# 案例： 查询员工的工种是 IT_PROG、AD_VP、AD_PRES
select * from employees where job_id in ('IT_PROG','AD_VP','AD_PRES');

# is null
# = 或 <> 不能用于判断null值， is null 或 is not null 可以判断null值
# 案例一： 查询没有奖金的员工名和奖金
select * from employees where commission_pct is null;

# 安全等于 <=>
# 判断是否等于， 可以用于判断null和普通数值
# 案例一：查询没有奖金的员工名和奖金率
select * from employees where commission_pct <=> null;
# 案例二：查询工资为12000的员工信息
select * from employees where salary <=> 12000;

# 查询员工号为176的员工的姓名和部门号和年薪
# 因为commission_pct可以是null， 如果是null，那么不用ifnull的话，遇到null的运算都会变成null
select last_name, department_id, salary*12*(1+ifnull(commission_pct, 0)) as annual_salary from employees;

# 经典面试题：
# 试问 select * from employees; 和 
# select * from employees where commission_pct like '%%' and last_name like '%%';  
# 以及 select * from employees where commission_pct like '%%' or employee_id like '%%'
# 结果是否一样？ 并说明原因
# 不一样！ 如果判断的字段有null值，‘%%’ 是没有办法匹配的， 所以第一句和第二句是不一样的， 因为commission_pct 是nullable的， 但如果是第三句查询用or连接，则第一句和第三句的结果是一样的