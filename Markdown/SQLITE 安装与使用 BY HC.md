# SQLITE

## INSTALL

> 目前几乎所有版本的Linux操作系统都附带SQLite。所以，只要使用命令检查下是否已经安装SQLite就可以，终端输入`sqlite3`。

### macOS

1. 访问[SQLITE官网下载网页]("http://www.sqlite.org/download.html")，从`Source Code`区域下载`sqlite-autoconf-***.tar.gz`文件

2. 在*Terminal*敲命令对下载的包进行解压和安装

   ```bash
   $tar xvfz sqlite-autoconf-3220000.tar.gz
   $cd sqlite-autoconf-3220000
   $./configure --prefix=/usr/local
   $make
   $make install
   ```

3. 在*Terminal*输入命令`sqlite3`测试是否安装成功

### Windows

1. 访问[SQLITE官网下载网页]("http://www.sqlite.org/download.html")，从`Precompiled Binaries for Windows`区域下载`sqlite-dll-win32-***.zip`或者`sqlite-dll-win64-***.zip`，和`sqlite-tools-win32-***.zip`
2. 把下载的两个zip文件都解压到`C:\sqlite`
3. 把`C:\sqlite`添加到系统变量`PATH`，保存
4. `win+r`输入`cmd`，敲入`sqlite3`，就可以检查是否已经成功安装

## USE

### SQLite命令

> ……这些命令被称为SQLite的点命令，这些命令的不同之处在于他们不以`;`结束。

这里列举各种重要的[SQLite点命令]("http://www.runoob.com/sqlite/sqlite-commands.html")

通用设置，这样看起来会好看些：

```sql lite
.header on
.mode column
.timer on
```

### [SQLite语法]("http://www.runoob.com/sqlite/sqlite-syntax.html")

* 大小写敏感性

  SQLite同样**不区分大小写**，但有一些命令是大小写敏感的，比如`GLOB`和`glob`在SQLite的语句中有不同含义。

* 注释

  注释以"--" 开始，直到有换行符结束

  或者以"/*"开始，以"\*/"结束。跨行注释。

### [SQLite语句]("http://www.runoob.com/sqlite/sqlite-syntax.html")

> 所有语句都以如SELECT, INSERT, UPDATE等关键字开始，以`;`结束。

#### analyze

```sql lite
analyze;
or
analyze database_name;
or
analyze database_name.table_name;
```

#### and/or

#### alter table

#### attach database

```sql lite
attach database 'Databasename' As 'alias-name';
```

#### begin transaction

```sql lite
begin;
or
begin exclusive transaction;
```

#### between

#### commit

#### create index

```sql lit
create index index_name
on table_name (column_name collate nocase);
```

#### create table

```sql lite
create table table_name(
	column1 datatype,
	column2 datatype,
	primary key (one or more columns)
);
```

#### create trigger

```sql lite
create trigger database_name.trigger_name
before insert on table_name for each row
begin
	stmt1;
	stmt2;
	....
end;
```

#### create view

#### create virtual table

```sql lite
create virtual table database_name.table_name using weblog(access.log);
or
create virtual table database_name.table_name using fts3();
```

#### commit transaction

#### count

#### delete

#### detach database

```sql lite
detach database 'alias-name';
```

#### distinct

#### drop index

```sql lite
drop index database_name.index_name;
```

#### drop table

#### drop view

#### drop trigger

#### exists

```sql lit
select col1, col2,...
from table_name
where column_name exists (select * from table_name2);
```

#### GLOB

```sql lite
select col1, col2,...
from table_name
where column_name GLOB {PATTERN};
```

#### group by

#### having

#### insert into

```sql li
insert into table_name(col1, col2, ... colN)
values(value1, value2, ... valueN);
```

#### in

#### like

#### not in

#### order by

#### pragma

```sql lit
pragma pragma_name;

for example:

pragma page_size;
pragma cache_size = 1024;
pragma table_info(table_name);
```

#### release savepoint

```sql li
release savepoint_name;
```

#### reindex

```sql li
reindex collation_name;
reindex database_name.index_name;
reindex database_name.table_name;
```

#### rollback

```sql lite
rollback;
or
rollback to savepoint savepoint_name;
```

#### savepoint

```sql lite
savepoint savepoint_name;
```

#### select

#### update

#### vacuum

```sql lite
vacuum;
```

#### where

## Suggests

使用`sqlite3 database.db`来创建数据库，数据库是文件`*.db`

```bash
sqlite3 /Users/howardchung/Documents/sqlite/mysql.db
```

以上是一个例子，创建后可以通过

```sql lite
attach '/Users/howardchung/Documents/sqlite/mysql.db' as 'mydb';
-- 反向操作如下
detach database 'mydb';
```

来设置别名

然后就是创建表了

```sql lite
create table otaku(
	name varchar(10) primary key not null,
	hobbies varchar(20),
	favourite varchar(10) not null,
	isBadGuy int(2) not null
);
insert into otaku values('hc', 'anime, it, etc...', 'anime', '1');
select * from otaku;
```

其他

设置输出列的宽度。设置三列宽度分别为10，20，20。

```bash
sqlite>.width 10, 20, 10
```

