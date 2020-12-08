#DDL
/*
数据定义语言
库和表的管理
一、库的管理
	创建、修改、删除
二、表的管理
	创建、修改、删除
    
创建：CREATE
修改：ALTER
删除：DROP

*/
#一、库的管理
#1、库的创建
/*
语法： create database 【 if not exists 】库名；
*/
create database  if not exists books;

#2、库的修改
#更改库的字符集
ALTER database books character set utf8;

#3、库的删除
drop database if exists  books;

#二、表的管理
#1、表的创建
/*
语法：
create table TABLENAME （
		列名  列的类型【（长度）约束】，
		列名  列的类型【（长度）约束】，
		列名  列的类型【（长度）约束】，
        ...
        
		列名  列的类型【（长度）约束】
）
*/
# 案例：创建表book
CREATE TABLE  if not exists BOOK(
		ID INT , #编号
        bName varchar(20), #图书名
        price double, #价格
        authorId int, #作者编号
        publishDate datetime #出版日期
);
desc book;

create table author(
		id int,
        au_name varchar(40),
        nation varchar(10)
);
desc author;

#2、表的修改
/*
语法：
alter table 表名 add | drop | modify | change column 列名 【列类型 约束】
*/

#--修改列名
alter table book change column publishDate pubDate Datetime;
#--修改列的类型或约束
alter table book modify column pubDate timestamp;
#--添加新列
alter table author add column annual double;
#--删除列
alter table author drop column annual;
#--修改表名
alter table author rename to book_author;

#3、表的删除
drop table if exists author;
show tables;

#4、表的复制
insert into author values (1, 'Robin','JAN'),(2, 'Lucy','CHN'),(3, 'FengTang','CHN');
#仅仅复制表的结构
create table author_copy like author;
#复制表的结构+数据
create table author_copy1 select * from author where nation='CHN';
select * from author_copy1;
#仅仅复制某些字段
create table author_copy2 select id, au_name from author where 1=2;

#CASE STUDY
#1、创建表dept1
use test;
create table dept1 (
		id int(7),
        name varchar(25)
);
#2、将表departments 中的数据插入到新表dept2中
create table dept2 select * from myemployees.departments;
#3、创建表emp5
create table emp5(
		id int(7),
        first_name varchar(25),
        last_name varchar(25), 
        dept_id int(7)
);
#4、将列last_name的长度增加到50
alter  table emp5 modify column last_name varchar(50);
#5、根据表employees创建employees2
create table employees2 like  myemployees.employees;
#6、删除表emp5
drop table if exists emp5;
#7、将表employees2 重命名为emp5
alter table employees2 rename to emp5;
#8、在表dept 和emp5中添加新列test_column，并检查所做操作；
alter table emp5 add column test_column double ;
desc emp5;
#9、直接删除emp5中的列dept_id
alter table emp5 drop column test_column;
