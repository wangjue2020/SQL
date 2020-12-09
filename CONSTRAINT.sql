#常见约束
/*
含义：一种限制，用于限制表中的数据，为了保证表中的数据的准确和可靠性
分类： 六大约束
		NOT NULL ： 非空， 用于保证该字段的值不能为空， 比如姓名、学号等
        DEFAULT； 默认， 用于保证该字段有默认值 比如性别
		PRIMARY KEY： 主键， 用于保证该字段的具有唯一性， 并且非空  比如学号、员工编号等
        UNIQUE： 唯一，用于保证该字段的值具有唯一性，可以为空  比如座位号（不是很重要，但是必须唯一）
        CHECK：检查约束【mysql 中不支持】
        FOREIGN KEY： 外键， 用于限制两个表的关系， 用于保证该字段的值必须来自于主表的关联列的值
									在从表添加外键约束，用于引用主表中某列的值， 比如学生表的专业编号，员工表的部门编号，员工表的工种编号

添加约束的时机：
		1、创建表时
        2、修改表时
约束的添加分类：
		列级约束：
			六大约束语法上都支持，但外键约束没有效果
        表级约束
			除了非空、默认、其他的都支持


create table 表名(
		字段名 字段类型 列级约束，
        字段名 字段类型 ，
        表级约束
);

主键和唯一的对比：	
							保证唯一性			是否允为空			一个表中可以有多少个			是否允许组合
        主键					Y							N								1											Y， 但不推荐
        唯一					Y							Y								multi									Y， 但不推荐
        
外键：
		-- 要求在从表设置外键关系
        -- 从表的外键列的类型和主表的关联列的类型要求一致或兼容， 名称无要求
        -- 主表的关联列必须是一个key（一般是主键或唯一）
		-- 插入数据时，先插入主表，在插入从表
		-- 删除数据是，先删除从表，后删除主表
        
*/
create database students;
#一、创建表时添加约束
#1、添加列级约束
/*
语法： 
直接在字段名和类型后面追加约束类型即可。
只支持：默认、非空、主键、唯一
*/
use students;
create table student_info(
	id int primary key,
    student_name varchar(20) not null, 
    gender char(1) check(gender='M' or gender='F'),
    seat int unique,
    age int default 18,
    major_id INT references major(id)
    
);

create table major(
		id int primary key,
        major_name varchar(20)
);

show index from student_info;
#2、添加表级约束
/*
语法：在各个字段的最下面
【constraint 约束名】 约束类型（字段名）
		不给constraint 取名会有默认名
*/
drop table if exists student_info;
create table student_info(
	id int,
    studeng_name varchar(20),
    gender char(1),
    seat int,
    age int,
    major_id int,
    constraint student_info_PK primary key(id),
    constraint student_info_UNIQ unique(seat),
    constraint student_info_CHECK check(gender='M' or gender='F'),
    CONSTRAINT student_info_FK_major foreign key(major_id) references major(id)
);
desc student_info;

#通用的写法：
create table if not exists student_info(
	id int primary key,
    student_name varchar(20) not null,
    gender char(1),
    age int default 18, 
    seat int unique,
    major_id int, 
    constraint FK_STUDENT_INFO_MAJOR foreign key(major_id) references major(id)
    );
    
    #二、修改表时添加约束
    /*
    1、添加列级约束
		alter table 表名 modify column 字段名 字段类型 新约束；
	2、添加表级约束
		alter table 表名 add 【constraint 约束名】 约束类型（字段名） 外键的引用；
	*/
drop table if exists student_info;
create table student_info(
	id int,
    student_name varchar(20),
    gender char(1),
    seat int,
    age int,
    major_id int
    );
    desc student_info;
    
#1、添加非空约束
alter table student_info modify column student_name varchar(20) not null;
#2、添加默认约束
alter table student_info modify column age int default 18;
#3、添加主键
#列级约束
alter table student_info modify column id int primary key;
#表级约束
alter table student_info add primary key(id);
#4、添加唯一
#列级约束
alter table student_info modify column seat int unique;
#表级约束
alter table student_info add unique(seat);
#5、添加外键
alter table student_info add FOREIGN KEY(major_id) references major(id);
alter table student_info add constraint FK_student_info FOREIGN KEY(major_id) references major(id);

#三、修改表示删除约束
#1、删除非空约束
alter table student_info modify column student_name varchar(20) null;
#2、删除默认约束
alter table student_info modify column age int;
#3、删除主键
alter table student_info drop primary key;
#4、删除唯一键
alter table student_info drop index seat;
show index from student_info;
#5、删除外键
alter table student_info drop FOREIGN KEY student_info_ibfk_1;


