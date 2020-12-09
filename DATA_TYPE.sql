#常见数据类型
/*
数值型：
		整型
		小数：		
					定点数
                    浮点数
字符型：
			较短的文本： char 、 varchar
            较长的文本： text、blob（较长的二进制数据）
            
日期型：


选择类型的原则：
	-- 所选择的类型越简单越好，能保存数值的类型越小越好
*/
#一、整型
/*
分类：
tinyint 、smallint、mediumin、int/integer、bigint
1				2				3					4				5
特点：
		-- 如果不设置无符号还是有符号，默认有符号。 如果想设置无符号，需要添加unsigned 关键字
        --如果插入的数值超出了整型的范围，会报插入异常
        --如果不设置长度，会有默认的长度
        --长度代表了显示的最大宽度，如果不够会用0在左边填充，但必须搭配zerofill使用， 长度是指int(...) 中括号内的数字
*/
#1、如何设置无符号和有符号
drop table tab_int;
create table tab_int(
		t1 INT(7) zerofill,
        t2 int(7)  unsigned
);

desc tab_int;

insert into tab_int values(-123456,123456);
insert into tab_int values(2147483647,4294967295);
insert into tab_int values(123,123);
select * from tab_int;

#二、小数
/*
1、浮点型
	float（M，D）
	double （M，D）
2、定点型
	dec（M，D）
    decimal（M，D）
    
特点：
	-- M：整数部位+小数部位		D：小数部位		如果超过范围，则抛出异常或插入临界值，具体看设置
    -- M和D都可以省略， 如果是decimal， 则M默认为10， D默认为0. 如果是float 和double，则会根据插入的数值的精度来决定精度
    -- 定点型的精确度较高，如果要求插入数值的精度较高如货币运算等则考虑用decimal
    
*/

CREATE TABLE tab_float(
	f1 float (5,2),
    f2 double(5,2),
    f3 decimal(5,2)
);

select * from tab_float;

insert into tab_float values(123.45, 123.45, 123.45);
insert into tab_float values(123.456, 123.456, 123.456);
insert into tab_float values(123.4, 123.4, 123.4);
insert into tab_float values(1523.4, 1523.4, 1523.4);

#三、字符型
/*
较短的文本：
char
varchar
其他：binary 和varbinary用于保存较短的二进制
			enum用于保存枚举
			set用于保存集合

特点：
					写法					M的意思				特点							空间的耗费		效率
char				char(M)			最大的字符数		固定长度的字符		比较耗费			高
varchar		varchar(M)		最大的字符数		可变长度的字符		比较节省			低

*/

create table tab_char(
		c1 enum('a','b','c')
);
select * from tab_char;
insert into tab_char values('a');
insert into tab_char values('b');
insert into tab_char values('c');
insert into tab_char values('A');
insert into tab_char values('m');

#四、日期型
/*
分类：
date 只保存日期
time 只保存时间
year 只保存年
datetime 保存日期+时间
timestamp 保存日期+时间

特点：
						字节			范围					时区等的影响
datetime			8				1000-9999		不受
timestamp		4				1970-2038		受
*/
create table tab_date(
	t1 datetime,
    t2 timestamp
);

insert into tab_date values(now(), now());
select * from tab_date;
show variables like 'time_zone';
set time_zone='+8:00';