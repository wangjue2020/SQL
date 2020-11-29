#进阶4: 常见函数
/*
功能： 类似于java的方法， 将一组逻辑语句封装在方法体中，对外暴露方法名
好处： 1、隐藏了实现细节 		2、提高代码的重用性
调用：select 函数名（实参列表） 【from 表】；
特点：
		1、 叫什么 --函数名
        2、 干什么 --函数功能

分类：
		1、单行函数
        如 concat、 length、 ifnull等
        2、分组函数
			功能： 做统计使用 又称为统计函数、聚合函数、组函数
*/

#一：字符函数
# 1、length 获取参数值的字节个数
select length("good");
select length("你好");

# 2、concat 拼接字符串
select concat(first_name, "  ", last_name) as legal_name from employees;

# 3、upper、lower 
select concat(lower(first_name),"  ", upper(last_name))  as legal_name from employees;

# 4、substr、 substring
# caution: index starting with 1 
# 截取从指定索引处后面所有字符
select substr("Tom love Jenny", 5);

# 截取从指定索引处指定长度的字符
select substr("Tom love Jenny", 5,3);

# 案例： 姓名中首字符大写，其他字符小写然后用_ 拼接， 显示出来
select concat(upper(substr(last_name,1,1)), "_", lower(substr(last_name, 2)))  output from employees;

# 5、instr 返回子串第一次出现的index， 如果找不到返回0
select  instr("I Love you", "o") as output;

# 6、trim 去掉以指定字符开头和结尾的部分，没有指定的时候默认去掉两头的空格
select length(trim("            hello           ") )as output;
select trim("a" from  "aaaaaaaahelaaaaaloaaaaaaaa") as output;

# 7、lpad 用指定的字符实现左填充指定长度，总和为指定长度
select LPAD('hello', 10, '*') as output;

# 8、rpad 用指定的字符实现右填充指定长度，总和为指定长度
select rPAD('hello', 10, '*') as output;

# 9、replace 替换
select replace("hello world", "o", "*") as output;

# 二、数学函数
# round 四舍五入
select round(1.65);
select round(-1.45);
select round(1.567 ,2);#保留两位小数

# ceil 向上取整, 返回大于等于该参数的最小整数
select ceil(1.1);

#floor 向下取整 返回小于等于该参数的最大整数
select floor(-9.99); #-10

# truncate 截断 即小数点后保留几位
select truncate(1.65,1); 

#mod 取余
select mod(10, -3);
select 10%3;

#三、日期函数
#now 返回当前系统日期+时间
select now();

#curdate 返回当前系统日期，不包含时间
select curdate();

#curtime 返回当前时间，不包含日期
select curtime();

#可以获取指定的部分， 年、月、日、小时、分钟、秒
select year(now());
select year('1998-1-1');
select year(hiredate) year from employees;

select month(now());
select monthname(now()) month;

#str_to_date 将日期格式的字符转换成指定格式的日期
select str_to_date('1998-3-2', '%Y-%c-%d') as output;
select * from employees where hiredate='1992-4-3';
select * from employees where hiredate=str_to_date('4-3 1992', '%c-%d %Y');

#date_format  将日期转换成字符
select date_format(now(), '%c-%d %Y');

#四、其他函数
select version();
select database();
select user();

#五、流程控制函数
#1、if函数： if else 的效果
select if (10>5, 'true', 'false');

select last_name, commission_pct, if(commission_pct is null, 'no bonus', 'congrats') from employees;

#2、case函数的使用一： switch case的效果
# case 要判断的字段或表达式
# when 常量1 then 要显示的值1或者语句1；
# when 常量2 then 要显示的值1或者语句2；
#end
/*
案例： 查询员工的工资， 要求
部门号= 30， 显示工资为1.1倍；
部门号=40， 显示工资为1.2倍；
部门号=50， 显示工资为1.3倍；
其他部门，显示工资为原始工资
*/
select employee_id, last_name, first_name, salary, department_id, 
case department_id 
when 30 then salary*1.1
when 40 then salary*1.2
when 50 then salary*1.3
else salary  
end
from employees;

#3、case 函数的使用二：类似于多重if
/*
case
when 条件1 then 要显示的值1或语句1
when 条件2 then 要现实的值2或语句2
。。。
else 要显示的值n或者语句n
end
*/
#案例：查询员工的工资情况
/*
如果工资>20000， 显示A等级
如果工资>15000， 显示B等级
如果工资>10000， 显示C等级
否则，显示D等级
*/
select employee_id, last_name, first_name, salary, 
case 
when salary > 20000 then "A"
when salary>15000 then "B"
when salary>10000 then "C"
else "D"
end as salary_level
from employees
ORDER BY salary;

#hwk
#显示系统时间（注：日期+时间）
select now();
#查询员工号，姓名，工资，以及工资提高百分之20%后的结果（new salary）
select employee_id, last_name, first_name, salary, salary*1.2 as "new salary" from employees;
#将员工的姓名按首字母排序，并写出姓名的长度（length）
select concat(last_name, "  ", first_name) as legal_name, length(last_name)+length(first_name) as len_names from employees order by substr(legal_name,1,1);
#做一个查询，产生下面的结果
#<last_name>  earns <salary> monthly but wants <salary*3> 
# Dream Salary
select concat(last_name, " earns ", salary, " monthly but wants ", salary*3) as "Dream Salary" from employees;
#使用case-when， 按照下面条件：
#job							grade
#AD_PRES				A
#ST_MAN				B
#IT_PROG				C
select * ,
case job_id
when "AD_PRES" then "A"
when "ST_MAN" then "B"
when "IT_PROG" then "C"
end
from employees;