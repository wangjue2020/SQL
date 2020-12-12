#存储过程
/*
含义： 一组预先编译好的SQL语句的集合，理解称为批处理语句
好处：
	-- 提高代码的重用性
    -- 简化操作
    -- 减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率
*/

#一、创建语法
/*
create procedure 存储过程名(参数列表){
begin 
	存储过程体（一组合法的SQL语句）
end
注意：
1、参数列表包含三部分
		参数模式		参数名		参数类型
        举例：IN student_name VARCHAR(20)
        参数模式：
					IN			该参数可以作为输入，也就是该参数需要调用方传入值
                    OUT 		该参数可以作为输出，也就是该参数可以作为返回值
                    INOUT		该参数既可以作为输入又可以作为输出，也就是该参数既需要传入值，又可以返回值
2、如果存储过程体仅仅只有一句话，BEGIN END 可以省略
		存储过程体中的每条SQL居于的结尾要求必须加分号。
        存储过程的结尾可以使用 DELIMITER 重新设置
        语法：
				DELIMITER 结束标记
                案例：DELIMITER $
*/
#二、调用语法
-- CALL 存储过程名(实参列表);

#1、空参列表
#案例：插入到admin表中五条记录
use girls;
select * from admin;
delimiter $
create procedure myql()
BEGIN
	insert into admin(username, password) values('john1', '0000'), ('Lily', '0000'), ('Rose', '0000'), ('Tom', '0000'), ('Jack', '0000');
end $

#调用
call myql()$

#2、创建带in模式参数的存储过程
#案例1:创建存储过程实现根据女生名，查询对应的男生的信息
create procedure search_boy_by_girl(in  g_name varchar(20))
begin
	select boys.*  from boys inner join beauty on beauty.boyfriend_id=boys.id where UPPER(beauty.name)=UPPER(g_name);
end $

call search_boy_by_girl('周冬雨') $

#案例2: 创建存储过程实现，用户是否成功登录
create procedure login(in username varchar(20), in password varchar(20))
begin 
	select count(*) from admin a where a.username=username and a.password=password;
end $

call login('john1', '000') $


create procedure login1(in username varchar(20), in password varchar(20))
begin
		DECLARE result int default 0;
        
        select count(*) into result
        from admin where admin.username=username
        and  admin.password=password;

		select if(result>0, 'log in successfully', 'log in failed');
end $

call login1('john1', '000') $ 

#3、创建带out 模式的存储过程
#案例1:根据女生名，返回对应的男生名
create procedure search_boy_by_girl_return( in g_name varchar(20), out b_name varchar(20))
begin
	select boys.boyName  into b_name
    from boys inner join beauty on beauty.boyfriend_id=boys.id where UPPER(beauty.name)=UPPER(g_name);
end $
#调用

call search_boy_by_girl_return('周冬雨', @bName)$
select @bName$

#案例2: 根据女生名，返回对应的男生名和其魅力值
create procedure boy_name_CP_by_girl(in g_name varchar(20), out b_name varchar(20), out CP int)
begin
	select boys.boyName, boys.userCP  into b_name,   CP
    from boys inner join beauty on beauty.boyfriend_id=boys.id where UPPER(beauty.name)=UPPER(g_name);
end $
call boy_name_CP_by_girl('周冬雨' ,@bName, @usercp);
select @bName, @usercp$

#4、创建带inout模式参数的存储过程
#案例1:传入a和b两个值，最终a和b都翻倍并返回
delimiter $;
create procedure multiple(inout a int, inout b int)
begin 
	select a*2, b*2 into a, b;
end $;
delimiter $;
set @a:=12$;
set @b=13 $;
call multiple(@a, @b) $;
select @a, @b$;

#三、删除存储过程
#语法： drop procedure存储过程
delimiter ;
drop procedure multiple;

#四、查看存储过程的信息
show create procedure multiple;

select * from beauty;
select * from boys;
