---
title: 读书笔记《Redis深度历险》
date: 2024-08-17T22:05:20+08:00
categories: ["读书笔记"]
tags: [""]

---

2018年的书，作者是钱文品，掌阅服务端的技术员，开源项目爱好者，开发过多人在线 RPG 游戏，写过大型网站、消息推送系统和 MySQL 中间机。

Redis (Remote Dictionary Service) 是高性能的缓存应用。作者是意大利人 Salvatore Sanfilippo ，他出生于非英语系国家，英语能力长期以来是短板。他已经 40 多岁了，依然在为 Redis 代码做贡献。

## 基础

### 基本数据结构

Redis 基本数据类型字符串是动态字符串，预分配更多的内存来避免重复分配。

### 过期时间

Redis 所有的数据结构都可以设置过期时间。

### 分布式锁

注意：锁有超时限制，分布式锁不应该用来做比较耗时的任务。 

### HyperLogLog 

提供不精准的统计方案。

注意其可能要 12kb 的存储空间。

原理：一组随机数 n，根据随机数低位为 0 有 k 位，根据 k 估算出 n。

### 布隆过滤

出重。

### GeoHash

附近的人。


---

## 原理

### IO

Redis 是单线程的，采用多路复用处理 IO。用 select，epoll（linux），kqueue（FreeBSD 哈 macosx）函数处理。

### 持久化

* 快照

Redis 用系统多进程 COW （copy on write）机制来实现快照。子进程创建后，与父进程共享同数据。当父进程要修改某页数据时，会先复制其页，再修改。子进程从创建，其数据段就不会变化的。

* AOF 日志

存储 Redis 对内存修改的顺序指令。

## 集群

### CAP 原理

CAP 是分布式存储理论基石。

* C：Consistent 一致性

* A：Availability 可用性

* P：Partition tolerance 分区容忍性