---
title: "Bug_ios_DispatchSource_EXC_BAD_INSTRUCTION"
date: 2024-01-22T09:55:46+08:00
draft: true

---

## DispatchSourceTimer 

## 问题
1、DispatchSourceTimer suspended 状态下不能释放

2、DispatchSourceTimer 的释放在同步线程进行

## 参考

1、libdispatch 源码 中的 ``_dispatch_queue_xref_dispose`` 方法。