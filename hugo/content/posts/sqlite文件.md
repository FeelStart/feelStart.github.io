---
title: "sqlite文件"
date: 2024-08-28T20:35:48+08:00
tags: ["sqlite"]
categories: ["编程"]

---

sqlite 只有一个主文件，我们将探究该文件组织结构。

## 环境配置

1 安装[HexFiend](https://github.com/HexFiend/HexFiend)，查看文件字节

2 配置 Demo 数据库文件

* 创建表 Person，并插入 3 条数据

![](/images/sqlite_1.png)

* 获取页信息

![](/images/sqlite_2.png)

## 1 查看文件

### 1.1 首页

HexFiend 打开数据库文件

![](/images/sqlite_3.png)

可以看出，数据库文件是有 “SQLite format 3” 开头的，这是个魔数。

文件库文件有 100 字节的头部，在页1 中，只有这一页有这个头部。

![](/images/sqlite_7.png)


页的大小由偏移 16 的 2 个字节决定，从图可知 ``10 00``。这个大端法，所以为 0x1000 = 4096，和上面的命令行得到的结果一致。

数据库头部下面的是页的头部。

在偏移 100，其值为 0D，可知这是叶子表 b-tree 页，其头部有 8 个字节。（如果是内部页则有 12 个字节）。

在页头部偏移 5，有页内容的偏移。这里是 0xFB8 = 4024。

![](/images/sqlite_4.png)

这里是 sqlite_master 表的数据，数据库内部的表。

其结构：

* rowid 64 位 （如果没有 rowid，则主 key 排首位）

* 1 字节声明下面类型的大小（包括自己）

* 类型列表

![](/images/sqlite_5.png)

* 数据

![](/images/sqlite_6.png)

首位数据类型为 0x17 = 23，为 >= 13 的奇数，按照规则，这是 5 字节的字符串，其值正好是 “table”。

## 1.2 表页

查询 sqlite_master 表，知道 Person 表的数据在页码为 2 的页中。而从头部我们也知道，每一页的大小为 4096 字节，所以我们可以跳转到该页。

![](/images/sqlite_8.png)

首字节为 0x0D，说明为叶子表 b-tree 页。

内容的再该页偏移为 0xFD8 = 4056，加上该页偏移 （4096），跳转到该偏移。其中从 05 ...

![](/images/sqlite_9.png)

在该例子中，顺序依次表示：

2 字节的 rowid。

1 字节，表示声明类型部分的大小（包括自己），为 3 。

内容 0x1，表示这是 1 字节的整数。

内容 0xf，表示这个 1 字节的字符串。

1 字节，对应上面 1 字节的整数，为 3。

1 字节，对应上面 1 字节的字符串，为 C。

其值为上面例子最后插入的数据。


## 参考

[file format](https://www.sqlite.org/fileformat2.html)
