# Install Docker Oracle on macOS - 在macOS系统用Docker安装Oracle数据库

## Background - 背景

在非Windows系统上安装Oracle数据库，是一件比让你上刀山下火海，还要难受的事。我不是DBA，但因为一些工作需要，要在自己的Macbook上搭建Oracle数据库。

两天时间，我跟自己博弈了不下10000次。

* 双系统情况下，切换到Windows系统麻烦
* Windows系统在mac机器上比较耗能
* 尝试Instant Client for Mac，但不能建立Oracle数据库实例，只能访问其他服务器，不能把远程服务器的数据copy/download到本地
* 尝试了在Centos Linux和Ubuntu Linux虚拟机下安装Oracle数据库，但系统参数过于复杂，起码对于我这个非计算机科班出身的人来说是的，最终虚拟机Linux装Oracle的路宣告失败
* R和Python通过ODBC的方法链接远程Oracle数据库不可行。前者获取不到表内容，后者因为中文编码失败而获取表失败
* …...

最后，我选择了[Docker](https://yeasy.gitbooks.io/docker_practice/content/introduction/what.html)。

> Docker是一个开放源代码软件项目，让应用程序布署在软件容器下的工作可以自动化进行，借此在Linux操作系统上，提供一个额外的软件抽象层，以及操作系统层虚拟化的自动管理机制。Docker利用Linux核心中的资源分脱机制，例如cgroups，以及Linux核心名字空间，来创建独立的软件容器。[维基百科](https://zh.wikipedia.org/zh-cn/Docker_(%E8%BB%9F%E9%AB%94))

## Install & Configure - 安装配置

后期主要参照该篇[文章](https://www.jianshu.com/p/14000d16915c)。

可能想文章中安装[docker-toolbox](http://mirrors.aliyun.com/docker-toolbox/mac/docker-toolbox/?spm=a2c1q.8351553.0.0.dn1SYR)，会快点。但我自己当时还是走了弯路。不过有一个是一定要先做的，就是安装[VirtualBox](https://www.virtualbox.org/wiki/Downloads)。

我自己的步骤是：

1. 安装VirtualBox

2. 安装[boot2docker](https://github.com/boot2docker/osx-installer/releases)

3. 安装[docker community edition](https://www.docker.com/community-edition)

4. 初始化docker变量环境

   1. ```bash
      eval "$(boot2docker shellinit)"
      ```

   2. ```bash
      # 测试docker是否安装成功
      docker run hello-world
      ```

   3. 如果terminal有结果像"Hello from Docker!"，证明已经成功配置docker

5. 下载并配置oracle容器

   1. ```bash
      # 下载oracle镜像
      docker pull alexeiled/docker-oracle-xe-11g
      ```

   2. ```bash
      # 等下载配置完后，启动镜像并命名为oracle
      docker run -h "oracle" --name "oracle" -d -p 49160:22 -p 49161:1521 -p 49162:8080 alexeiled/docker-oracle-xe-11g

      # 49160是用ssh链接对应的端口
      # 49161是链接sqlplus对应的端口
      # 49162是了解oem对应的端口

      # 该镜像的oracle参数配置默认设置如下，以后登录也是先用这些参数登录，然后创建其他用户

      # hostname: localhost (这里和文章中不一样，因为用navicat链接docker oracle不需要ip)
      # port: 49161 (sqlplus的端口)
      # sid: xe
      # username: system
      # password: oracle
      ```

   3. ```bash
      # 获取container id
      docker container ls

      # CONTAINER ID下那个a47...那一串就是 :-D
      ```

      ![如图](https://github.com/howardch1993/howardchunghc/blob/master/Markdown/images/20180210_00.png?raw=true)

   4. ```bash
      # 如果要进入docker oracle的控制台
      docker exec -it a470e65045ca /bin/bash
      # sqlplus用户登录命令 sqlplus [username]/[passwd]
      sqlplus system/oracle

      # 开始一个之前已经部署的容器container
      docker container start a470e65045ca
      ```

   5. 配置结束。可以用其他软件链接docker oracle，例如Navicat

6. Navicat链接


## Using Sqlplus - sqlplus一些基本用法

```bash
# bash
# sqlplus用户登录命令 sqlplus [username]/[passwd]
sqlplus system/oracle
```

```sql
-- sqlplus
-- 登录到其他用户

connect [username]/[passwd]

-- 创建用户并赋予用户权限
create user [username] identified by [passwd];
grant [connect | resource | dba] to [username];
-- 删除用户及权限
drop user [username] [cascade];
revoke [connect | resource | dba] to [username];

-- 修改用户密码
alter user [username] identified by [passwd];

```

See more [here](http://blog.csdn.net/jiangxinyu/article/details/9624721).

```sql
-- 创建oracle dblink
CREATE PUBLIC DATABASE LINK [dblink name] CONNECT TO [username] IDENTIFIED BY "[passwd]"
USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST= [host ip])(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME= [sid] )))';
-- 替换掉中括号的内容(包括中括号)，即可创建
```

See more [here](http://zero696295.iteye.com/blog/721971).

## References

- [tools: docker: boot2docker](https://github.com/boot2docker/osx-installer/releases)
- [tools: docker: oracle docker-images](https://github.com/oracle/docker-images/tree/master/OracleDatabase)
- [docs: docker: guide: Docker Machin用户指南](http://liuhong1happy.lofter.com/post/1cdb27c8_60292ee)
- [docs: docker: guide: Mac OS X 安装 Docker](http://www.widuu.com/docker/installation/mac.html)
- [docs: docker: guide: docker-machin create](https://docs.docker-cn.com/machine/reference/create/)
- [tools: virtualbox](https://www.virtualbox.org/wiki/Downloads)
- [docs: docker: docker container start](https://docs.docker.com/engine/reference/commandline/container_start/)
- [docs: docker: guide: mac os 下使用Docker安装oracle数据库（主要）](https://www.jianshu.com/p/14000d16915c)
- [docs: centos: guide: Oracle 12c on Centos 7 安装记录](https://dotblogs.com.tw/jamesfu/2016/02/02/oracle12c_install)
- [docs: centos: guide: Install Oracle 11G Release 2(11.2) on Centos Linux 7](http://dbaora.com/install-oracle-11g-release-2-11-2-on-centos-linux-7/)
- [docs: linux: guide: VM虚拟机下载LINUX上安装ORACLE 11G单实例数据库](http://blog.csdn.net/haibusuanyun/article/details/12433731)
- [docs: docker: guide: Docker中的Oracle数据库（安装）](http://blog.csdn.net/yidu_fanchen/article/details/75568748)
- [docs: docker: guide: 在Docker中搭建Oracle数据库，并使用PL/SQL Developer链接](http://blog.csdn.net/qq_17518433/article/details/72835844)
- [docs: docker: guide: ...Docker安装oracle并通过navicat进行登录](http://www.cnblogs.com/LiQ0116/p/6980301.html)
- [docs: navicat: oracle: dblink: Oracle Database Links](https://www2.navicat.com/manual/online_manual/en/navicat/mac_manual/DatabaseLinksOracle.html)
- [docs: oracle: dblink: oracle创建database link远程链接](http://blog.csdn.net/tianping168/article/details/4069975)
- [docs: oracle: dblink: Database Link基本语法](http://zero696295.iteye.com/blog/721971)
- [docs: oracle: guide: oracle创建数据库和用户](https://www.jianshu.com/p/9589a29f9705)
- [docs: oracle: guide: Oracle创建表空间、创建用户以及授权、查看权限](http://blog.csdn.net/jiangxinyu/article/details/9624721)
- [docs: oracle: guide: oracle 查看、创建、删除DBLINK](http://blog.csdn.net/home_zhang/article/details/8575668)
- [docs: oracle: guide: Oracle/PLSQL: CREATE SCHEMA statement](https://www.techonthenet.com/oracle/schemas/create_schema_statement.php)
- [docs: oracle: guide: Oracle 11g Express Edition - missing or invalid schema authorization identifier](https://dba.stackexchange.com/questions/160517/oracle-11g-express-edition-missing-or-invalid-schema-authorization-identifier)
- [docs: docker: Docker--从入门到实践](https://yeasy.gitbooks.io/docker_practice/content/)

