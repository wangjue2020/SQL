#TCL
/*
Transaction Control Language 事物控制语言

事务：
	一个或一组sql语句组成一个执行单元，这个执行单元要么全部执行，要么全部不执行

事务的属性（ACID）：
	-- 原子性（Atomicity）： 原子性是指事务是一个不可分割的工作单位，事务中的操作要么都发生，要么都不发生
    -- 一致性（Consistency）：事务必须使数据库从一个一致性状态变换到另一个一致性状态
    -- 隔离性（Isolation）：事务的隔离性是指一个事务的执行不能被其他事务干扰，
						即一个事务内部的操作及使用的数据对并发的其他事务是隔离的，并发执行的各个事务之间不能相互干扰
	-- 持久性（Durability）：持久性是指一个事务一旦被提交，他对数据库中数据的改变就是永久性的，
						接下来的其他操作和数据库故障不应该对其有任何影响
    
案例：转账
A		1000
B		1000
update 表 set A的余额=500 where name=‘A'；
update 表 set B的余额=1500 where name=’B'

事务的创建
		隐式事务：事务没有明显的开启和结束的标记， 如insert、update、delete语句
        显式事务：事务具有明显的开启和结束的标记， 前提是必须先设置自动提交功能为禁用
							set autocommit=0;
				步骤1:开启事务
							set autocommit=0;
                            start transaction; 可选的
				步骤2: 编写事务中的sql语句（select	insert	 update	delete）
							语句1；
                            语句2；
                            ......
				步骤3: 结束事务
							commit；提交事务
                            rollback；回滚事务
                            
事务隔离级别：

read uncommitted：	出现脏读、幻读、不可重复读
read committed：		避免脏读，出现幻读和不可重复
repeatable read：		避免脏读、不可重复读， 出现幻读
serializable：				避免了脏读、不可重复读、幻读

mysql中默认第三个隔离级别 repeatable read
oracle 中默认第二个隔离级别 read committed
查看隔离级别
select @@tx_isolation;
设置隔离级别
set session | global transaction isolation level
*/

show variables like 'autocommit';
set autocommit=0;

#演示事务的使用步骤
drop table if exists account;
create table account(
	id int primary key auto_increment,
    username varchar(20),
    balance double
);
insert into account (username, balance) values ('John', 1000), ('Lucy', 1000);
select * from account;

set autocommit=0;
start transaction;
update account set balance = 1000 where username='John';
update account set balance = 1000 where username='Lucy';
commit; # OR rollback; 提交或者撤销 

#2、演示事务对于delete 和truncate 的处理的区别
# truncate 不能回滚，回滚没有用，delete可以回滚
set autocommit=0;
start transaction;
delete from accoun;  #truncate account;
rollback;

#3、演示savepoint
set  autocommit=0;
start transaction;
delete from account where id=2;
savepoint a;#设置保存点
delete from account where id=1;
rollback to a; #回滚到保存点
