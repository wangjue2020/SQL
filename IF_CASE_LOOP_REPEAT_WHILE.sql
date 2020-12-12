#流程控制结构
/*
顺序结构：程序从上往下依次执行
分支结构：程序从两条或多条路径中选择一条去执行
循环结果：程序在满足一定条件的基础上，重复执行一段代码
*/
#一、分支结构
#1、if函数
/*
功能：实现简单的双分支
语法
				IF (表达式1， 表达式2， 表达式3)
执行顺序：
	如果表达式1成立，则IF函数返回表达式2的值，否则返回表达式3的值

应用：任何地方
*/

#2、case 结构
/*
方式一：
	语法：
					CASE 变量｜表达式｜字段
                    WHEN 要判断的值 THEN 返回的值1（或语句1；）
                    WHEN 要判断的值 THEN 返回的值2（或语句2）
                    ......
                    ELSE 要返回的值n （或语句n；）
                    END  CASE;
方式二：
	语法：
					CASE 
                    WHEN 要判断的条件1 	THEN 返回的值1（或语句1；）
                    WHEN 要判断的条件2	THEN 返回的值2（或语句2；）
                    ......
                    ELSE 要返回的值n（或语句n；）
                    END  CASE;
                    
特点：
-- 可以作为表达式，嵌套在其他语句中使用，可以放在任何地方， BEGIN  END 中或BEGIN  END 的外面
-- 可以作为独立的语句去使用，只能放在BEGIN END中
-- 如果WHEN中的值满足或条件成立，则执行对应的THEN后面的语句，并且结束CASE
	如果都不满足，则执行ELSE中的语句或值
-- ELSE 可以省略，如果ELSE 省略了，并且所有的WHEN条件都不满足，则返回NULL
*/
#案例：创建存储过程，根据传入的成绩，来显示等级， 比如90-100 显示A， 80-90 显示B， 60-80 显示C， 否则显示D
delimiter $
create procedure show_level(in grades int)
begin 
	case 
    when grades between 90 and 100 then select 'A' ;
    when grades between 80 and 89 then select 'B';
    when grades between 60 and 79 then select 'C';
    else select 'D';
    end case;
END $
delimiter ;
call show_level(10);

#3、if结构
/*
功能：实现多重分支

语法：
		if	条件1	then 	语句1；
        elseif 条件2	 then  语句2；
        ......
        【else 语句n;】
        end if；

应用在begin end  中
*/
#案例：根据传入的成绩，来显示等级， 比如90-100 返回A， 80-90 返回B， 60-80 返回C， 否则返回D
delimiter $
create function return_level(mark int) returns char
begin 
	if mark between 90 and 100 then return 'A';
    elseif mark between 80 and 89  then return 'B';
    elseif mark between 60 and 79 then return 'C';
    else return 'D';
    end if;
    
end $
delimiter ;
select return_level(10) as level;

#二、循环结构
/*
分类：
while 、loop、repeat

循环控制：
iterate		类似于 continue， 结束本次循环，继续下一次
leave 类似于	break 结束当前所在的循环
*/

#1、while
/*
语法：
			【标签：】while 循环条件 do
					循环体；
			end while 【标签】；
*/

#2、loop
/*
语法：
				【标签：】loop
						循环体；
					end loop 【标签】；
可以用来模拟简单的死循环
*/

#3、repeat
/*
语法：
				【标签：】repeat
						循环体；
				until 结束循环的条件
                end repeat 【标签】；
*/

#案例：批量插入，根据次数插入到admin表中多条记录
#没有添加循环控制语句
delimiter $
drop procedure pro_while1;
use girls;
create  procedure pro_while1 (in insert_count int)
begin
		declare i int default 1;
        while i < insert_count do 
			insert into admin(username,password) values (concat('rose',i), '666');
			set i=i+1;
		end while;
end $
delimiter ;
call pro_while1(100) ;

select * from admin;

#添加leave 语句
#案例：批量插入， 根据次数插入到admin表中多条记录，如果次数大于20 则停止
truncate table admin ;
delimiter $
create procedure test_while1(in insertCount int)
begin
	declare i int default 1;
    a: while i <= insertCount do 
		insert into admin(username, password) values(concat('lucy',i), '0000');
        if i >= 20 then leave a;
        end if;
        set i=i+1;
	end while a;
end $
delimiter ;
call test_while1(100);