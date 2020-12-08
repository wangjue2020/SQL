#DML 语言
/*
数据操作语言
插入：insert
修改：update
删除：delete
*/

#一、插入语句
/*
语法：
insert into 表名（列名，...) values (值1,...);

*/
#1、插入的值的类型要与列的类型一致或兼容
insert into beauty (id, name, sex, borndate, phone, photo, boyfriend_id)
values(13,'唐艺昕','女', '1990-4-23', '1898888888', null, 2);

#2、可以为null的列如何插入值？
#方式一
insert into beauty (id, name, sex, borndate, phone, photo, boyfriend_id)
values(13,'唐艺昕','女', '1990-4-23', '1898888888', null, 2);
#方式二
insert into beauty (id, name, sex, borndate, phone, boyfriend_id)
values(13,'唐艺昕','女', '1990-4-23', '1898888888', 2);

#3、列的顺序是否可以调换
insert into beauty(name, sex, phone, id)
values('蒋欣', '女', '110', 16);

#5、可以省略列名，默认所有列，而且列的顺序和表中列的顺序一致
insert into beauty 
values(17,'关晓彤','女', '1990-4-23', '1898888888', null, 2);

#方式二：
/*
语法
insert into 表名
set  列名=值，列名=值，...
*/
insert into beauty 
set id=18, name='刘涛', phone='999';

#两种方式PK
#1、方式一支持插入多行， 方式二不支持
insert into beauty (id, name, sex, borndate, phone, photo, boyfriend_id)
values(14,'唐艺昕2','女', '1990-4-23', '1898888888', null, 2),
(15,'唐艺昕3','女', '1990-4-23', '1898888888', null, 2);

#2、方式一支持子查询，方式二不支持
insert into beauty (id, name, phone) 
select 26, '宋茜', '11809866';

#二、修改语句
/*
1、修改单表的记录
语法：
update 表名
set 列=新值， 列=新值, ....
where 筛选条件；
2、修改多表的记录
语法：
sql92 语法：
update 表1 别名，表2 别名
set 列=值，...
where 连接条件 and 筛选条件

sql99 语法：
update 表1 别名
inner | left | right join 表2 别名 on 连接条件
set 列=值，...
where 筛选条件
*/
select * from beauty b left join boys bo on b.boyfriend_id=bo.id;
select * from boys;
#1、修改单表的记录
#案例1： 修改beauty表中姓唐的女生的电话号码为13899888899
update beauty set phone='13899888899' where name like '唐%';

#案例2: 修改boys表中id为2的名称为张飞,魅力值为10
update boys set boyname='张飞' , usercp=10 where id=2;

#2、修改多表的记录
#案例1: 修改张无忌的女朋友的手机号为114
update boys bo
inner join beauty b on bo.id=b.boyfriend_id
set b.phone=114 
where bo.boyname='张无忌';
#案例2:修改没有男朋友的女生的男朋友编号为2号
update beauty b
left join boys bo on bo.id=b.boyfriend_id
set b.boyfriend_id=2 where bo.id is null;

#三、删除语句
/*
方式一： delete
语法：
1、单表的删除
delete from tableName where CONDITION
2、多表的删除
sql92: （delete 后面接的别名，表示在哪些表上要删除记录）
delete  表1的别名，表2的别名 from 表1 别名，表2 别名 where 连接条件 and 筛选条件

sql99：（delete 后面接的别名，表示在哪些表上要删除记录）
delete 表1的别名， 表2的别名 from 表1 别名 inner | left | right  join 表2 别名 on 连接条件 where 筛选条件

方式二： truncate
语法： truncate table 表名；
*/

#方式一：delete
#1、单表的删除
#案例1: 删除手机号以9结尾的女生信息
delete from beauty where phone like '%9';
select * from beauty;

#2、多表的删除
#案例：删除张无忌的女朋友的信息
delete b from beauty  b inner join boys bo on bo.id=b.boyfriend_id where bo.boyname='张无忌';

#方式二： truncate 语句
#案例：将魅力值大于100的男生信息删除
TRUNCATE table boys;

#DELETE PK TRUNCATE
/*
1. delete 可以加where 条件，truncate 不能加
2、truncate 删除，效率高一丢丢
3、假如要删除的表中有自增长列，如果delete删除后，再插入数据，自增长列的值从断电开始；而truncate删除后，再插入数据，自增长列从1开始
4、truncate 删除没有返回值，而delete有返回值
5、truncate 删除不能回滚，delete 删除可以回滚
*/


#CASE STUDY
#1、运行一下脚本创建表my_employees；
USE MYEMPLOYEES;
CREATE TABLE MY_EMPLOYEES(
		ID INT(10),
        FIRST_NAME VARCHAR(10),
        LAST_NAME VARCHAR(10),
        USERID VARCHAR(10),
        SALARY DOUBLE(10,2)
);
CREATE TABLE USERS(
		ID INT,
        USERID VARCHAR(10),
        DEPARTMENT_ID INT
);

#2、显示表my_employees的结构
DESC my_employees;
#3、向my_employees表中插入下列数据
insert into my_employees (id, first_name, last_name, userid, salary)
values(1,'Patel', 'Ralph', 'Rpatel', 895), (2,'Dancs', 'Betty', 'Bdancs', 860), (3,'Biri', 'Ben', 'Bbiri', 1100),(4,'Newman', 'Chad', 'Cnewman', 750),(5,'Ropeburn', 'Audrey', 'Aropebur', 1550);
#4、向users表中插入数据
insert into users values (1,'Rpatel', 10),(2,'Bdancs', 10),(3,'Bbiri', 10),(4,'Cnewman', 20),(5,'Aropebur', 30);
#5、将3号员工的last_name修改为‘drelxer'
update my_employees set last_name='drelxer' where id=3;
#6、向所有工资少于900的员工的工资修改为1000
update my_employees set salary=1000 where salary<900;
#7、将userid 为Bbiri 的user表和my_employees表的记录全部删除
delete u, m from users u left join my_employees m on u.userid=m.userid where u.userid='Bbiri';
#8、删除所有数据
truncate  table my_employees;
truncate table users;


