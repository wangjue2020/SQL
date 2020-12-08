#进阶9: 联合查询
/*
union 联合 合并：将多条查询语句的结果合并成一个结果

语法： 
查询语句1 union 查询语句2 union ...

应用场景：
要查询的结果来自于多个表，且多个表没有直接的连接关系，但查询的信息一直时

特点：
1、要求多条查询语句的查询列表是一致的
2、要求多条查询语句的查询的每一列的类型和顺序最好一致
3、union 关键字默认去重，如果使用union all 可以包含重复项
*/

#引入的案例：查询部门编号>90 或邮箱包含a的员工信息

select * from employees where email like "%a%" or department_id>90;

select * from employees where email like "%a%"
union
select * from employees where department_id > 90;

#查询

