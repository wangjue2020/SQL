#进阶5: 分组查询
/*
语法：
		select 分组函数，列（要求出现在group by 的后面）
        from 表
        【where 筛选条件】
        group by 分组的列表
        【order by 子句】
注意： 查询列表必须特殊，要求是分组函数和group by 后面出现的字段

特点： 
		1、分组查询的筛选条件分为两类
											数据源								位置											关键字
			分组前筛选				原始表								group by 子句的前面				where
            分组后筛选				分组后的结果集				group by 子句的后面				having
            
            分组函数做条件肯定是放在having子句中
            能用分组前筛选的，就优先考虑使用分组前筛选
		2、group by 子句支持单个字段分组，多个字段分组 （多个字段之间用逗号隔开没有顺序要求），表达式或函数（用得较少）
        3、也可以添加排序（排序放在整个分组查询的最后）
*/
#引入：查询每个部门的平均工资
select avg(salary), department_id from employees group by department_id;

#简单的分组查询
#案例1: 查询每个工种的最高工资
select max(salary), job_id from employees group by job_id;
#案例2: 查询每个位置上的部门个数
select count(department_id), location_id  from departments group by location_id;

#添加分组前的筛选条件
#案例1:查询邮箱中包含a字符的， 每个部门的平均工资
select avg(salary), department_id from  employees where email like "%a%" group by department_id;
#案例2:查询有奖金的每个领导手下员工的最高工资
select max(salary), manager_id from employees where commission_pct is not null group by manager_id;

#添加分组后的筛选条件
#案例1: 查询哪个部门的员工个数> 2
select count(*), department_id from employees group by department_id having count(employee_id) > 2;
#案例2:查询每个工种有奖金的员工的最高工资>12000的工种编号和最高工资
#第一步：查询每个工种有奖金的员工的最高工资
#第二步：添加筛选条件
select  job_id, max(salary) from employees where commission_pct is not null  group by job_id having max(salary)>12000;
#案例3: 查询领导编号>102 的每个领导手下的最低工资>5000 的领导编号是哪个， 以及其最低工资
select manager_id, min(salary) from employees where manager_id > 102 group by manager_id having min(salary) > 5000;

#按表达式或函数分组
#案例： 按员工姓名的长度分组，查询每一组的员工个数，筛选员工个数>5的有哪些
select count(*),length(last_name) length_name from employees group by length_name having count(*) > 5;

#按多个字段分组
#案例：查询每个部门每个工种的员工的平均工资
select avg(salary), job_id, department_id from employees group by department_id, job_id;

#添加排序
#案例：查询每个部门每个工种的员工的平均工资， 并按平均工资的高低显示
select avg(salary), job_id, department_id from employees group by department_id, job_id order by avg(salary) desc;


#hwk
#查询各job_id的员工工资的最大值，最小值，平均值，总和，并按job_id升序
select max(salary), min(salary), avg(salary), sum(salary), job_id from employees group by job_id order by job_id;
#查询员工最高工资和最低工资的差距（DIFFERENCE) 
select  max(salary)-min(salary) DIFFERENCE from employees ;
#查询各个管理者手下员工的最低工资， 其中最低工资不能低于6000， 没有管理者的员工不计算在内
select min(salary) min_salary, manager_id from employees where manager_id is not null group by manager_id having min_salary >= 6000;
#查询所有部门的编号，员工数量和工资平均值，并按工资平均值降序
select department_id, count(*), avg(salary) average from employees group by department_id order by average desc;
#选择具有各个job_id的员工人数
select count(*) from employees group by job_id;
