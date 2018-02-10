# Install Docker Oracle on macOS - 在macOS系统用Docker安装Oracle数据库

## 背景

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

## 安装

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
      ```

   5. 配置结束。可以用其他软件链接docker oracle，例如Navicat

