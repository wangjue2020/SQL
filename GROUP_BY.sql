#进阶5: 分组查询
/*
语法：
		select 分组函数，列（要求出现在group by 的后面）
        from 表
        【where 筛选条件】
        group by 分组的列表
        【order by 子句】
注意： 查询列表必须特殊，要求是分组函数和group by 后面出现的字段
*/
#引入：查询每个部门的平均工资
select avg(salary), department_id from employees group by department_id;