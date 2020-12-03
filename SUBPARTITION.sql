#进阶8:分页查询
/*
应用场景：当要显示的数据，一页显示不全，需要分页提交sql请求
语法：
		select  查询列表
		from  表
		【join ...  on...】
        【where】
        【group by】
        【having】
        【order by】
        limit offset， size；
        
        offset 要现实的起始索引（起始索引从0开始）
        size 要现实的条目个数    
        
特点：
	-- limi 语句放在查询语句的最后
	-- 公式
			要显示的页数 page， 每页的条目数size
            limit (page-1)*size, size;
            
*/
#案例1: 查询前五条员工信息
select * from employees limit 0, 5;
select * from employees limit 5;
#案例2: 查询第11条---第25条
select * from employees limit 10, 15;
#案例3: 有奖金的员工信息，并且工资较高的前10名显示出来
select * from employees where commission_pct is not null order by salary desc limit 10;
