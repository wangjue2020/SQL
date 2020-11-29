#二、分组函数
/*
功能：用做统计使用，又称为聚合函数，组合函数或统计函数
分类：
sum 求和、 avg 平均值、 max 最大值、min最小值、count计算个数
特点：
	1、sum、avg一般用于处理数值型
			max、min、count可以处理任何类型
	2、以上分组函数都可以忽略null 值
    3、可以和distinct搭配实现去重的运算
    4、count函数的单独介绍
		一般使用count(*) 用作统计行数
	5、和分组函数一同查询的字段要求是group by 后的字段
*/

#1、简单的使用
select sum(salary) from employees;
select avg(salary) from employees;
select min(salary) from employees;
select max(salary) from employees;
select count(salary) from employees;

select sum(salary) "sum", avg(salary) "avg", min(salary) 'min', max(salary) 'max', count(salary) 'count' from employees;

#是否忽略null
select sum(commission_pct), avg(commission_pct),  sum(commission_pct)/35,sum(commission_pct)/107 from employees; 

#和distinct搭配
select  sum(distinct salary), sum(salary) from employees;
select count(distinct salary), count(salary) from employees;

#count函数的详细介绍
select count(salary) from employees;

select count(*) from employees; #常用于统计行数

select count(1) from employees;#相当于加了一整列的1，然后统计1的个数，依旧是统计行数
#效率 
/*
MYISAM 存储引擎下，count(*) 的效率高，因为这个里面有一个计数器，可以直接返回行数
INNODB  存储引擎下 count(1) 和 count(*) 的效率差不多，比count(字段） 要高一些，因为实际上用字段的话是需要判断的，判断这个值是否为null，如果为null就不+1，不为null则+1
*/

#6、和分组函数一同查询的字段有限制



#hwk
#查询公司员工工资的最大值，最小值，平均值，总和
select max(salary) as "max", min(salary) as 'min' , round(avg(salary) ,2) as 'avg', sum(salary) as 'sum' from employees;
#查询员工表中的最大入职时间和最小入职时间的相差天数
select datediff(max(hiredate),min(hiredate)) as difference from employees;
#查询部门编号为90的员工个数
select count(department_id), department_id from employees group by department_id;
select count(*) from employees where department_id =90;