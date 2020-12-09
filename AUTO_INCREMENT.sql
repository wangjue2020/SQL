#标识列
/*
又称为自增长列
含义：可以不用手动的插入值，系统提供默认的序列值

特点：
	-- 标识列必须和主键搭配吗？ 不一定，但要求是一个key， 可以是unique，也可以是primary key
    -- 一个表可以有几个标识列？ 至多一个
    -- 标识列的类型只能是数值型
    -- 标识列可以通过 set auto_increment_increment=1; 来设置每次增加多少
*/
#一、创建表时设置标识列
drop table if exists tab_identity;
create table tab_identity(
	id int ,
    name varchar(20)
);
truncate table tab_identity;
insert into tab_identity values(NULL, 'John');
select * from tab_identity;

show variables like '%increment%';
set auto_increment_increment=1;

#二、修改表时设置标识列
alter table tab_identity modify column id int primary key auto_increment;
desc tab_identity;

#三、修改表时删除标识列
alter table tab_identity modify column id int;