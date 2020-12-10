#变量
/*
系统变量：
	全局变量
    会话变量
自定义变量：
	用户变量
    局部变量
*/

#一、系统变量
/*
说明：变量由系统提供，不是用户定义，属于服务器层面
使用的语法：
1、查看所有的系统变量
show  global ｜【session】 variables;
2、查看满足条件的部分系统变量
show global | 【session】 variables like '%char%'
3、查看指定的某个系统变量的值
select @@系统变量名；-----> 默认session的系统变量
select @@global | 【session】.系统变量名			----> 注意有一个“.“
4、为某个系统变量赋值
方式一：	set global | 【session】 系统变量名=值；
方式二：	set @@global｜【session】.系统变量名=值；----> 注意有一个“.“

注意：
如果是全局级别，则需要加global，如果是会话级别，则需要加session， 如果不写，则默认session
*/
#1、全局变量
/*
作用域；服务器每次启动将为所有的全局变量赋予初始值，针对于所有的回话（连接）有效， 但是一旦重启所设置的全局变量的值不再有效
*/
#查看所有的全局变量
show global variables;
#查看部分的全局变量
show global variables like '%char%';
#查看置顶的全局变量的值
select @@global.autocommit;
select @@tx_isolation;
#为某个指定的全局变量赋值
set @@global.autocommit = 1;

#2、会话变量
/*
作用域：仅仅针对于当前会话（连接）有效
*/
#查看所有的会话变量
show variables;
show session variables;
#查看部分的会话变量
show variables like '%char%';
show session variables like '%char%';
#查看指定的某个会话变量
select @@tx_isolation;
select @@session.tx_isolation;
#为某个会话变量赋值
set @@session.tx_isolation='read-uncommitted';
set session tx_isolation='read-committed';

#二、自定义变量
/*
说明：变量是用户自定义的，不是有系统定义的
使用步骤：
		声明
        赋值
        使用（查看、比较、运算等）
*/
#1、用户变量
/*
作用域：针对于当前会话（连接）有效，同于会话变量的作用域
				应用在任何地方
*/
/*
赋值的操作符： 	= 或 :=
#声明并初始化	
set @用户变量名=值;
set @用户变量名:=值;
select @用户变量名:=值;
#赋值（更新用户变量的值）
方式一：通过set 或select
			set @用户变量名=值;
			set @用户变量名:=值;
			select @用户变量名:=值;
方式二： 通过select into
			select 字段 into 变量名 from 表；
*/
#案例：
set @name='john';
set @name=100;
select count(*) into @count from employees;
select @count;
#2、局部变量
/*
作用域：仅仅在定义他的begin end 中有效
应用在begin end 中的第一句话！！！
*/
/*
#声明
declare 变量名 类型；
declare 变量名 类型 default 值；

#赋值            
方式一：通过set 或select
			set 局部变量名=值;
			set 局部变量名:=值;
			select @局部变量名:=值;
方式二： 通过select into
			select 字段 into 局部变量名 from 表；
#使用
select 局部变量名；
*/

/*
对比用户变量和局部变量
						作用域						定义和使用的位置										语法
用户变量			当前会话					会话中的任何地方										必须加@符号，不用限定类型
局部变量			BEGIN END中			只能在BEGIN END 中，且为第一句话		一般不用加@符号，需要限定类型
*/
#案例：声明两个变量并赋初始值，求和，并打印
#1、用户变量
set @m=1;
set @n:=2;
set @sum=@m+@n;
select @sum;
#2、局部变量
-- following SQL doesn't work
-- declare m int default 1;
-- declare n int default 2;
-- declare sum int;
-- set sum:=m+n;
