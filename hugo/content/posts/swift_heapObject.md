---
title: swift HeapObject
date: 2024-09-06T09:10:39+08:00
draft: true
tags: ["swift"]
categories: ["编程"]

---

我们看以下的问题：

Swift 是如何管理对象以及内部结构是怎样的？

HeadObject 在代码中如何体现？

struct 和 class 是 HeadObject 吗？

## HeadObject

HeadObject 顾名思义就是程序空间堆里的对象。从 Swift 源代码中，可以看到其定义。

```
// HeadObject 伪代码
// 目录：../swift/stdlib/public/SwiftShims/swift/shims/HeadObject.h
struct HeadObject {
	HeapMetaData metadata;
	InlineRefCount refcounts;
}

```

### 引用计数

```
// 引用计数用位域表示
InlineRefCount
// RefCounts 处理并发
typedef RefCounts<InlineRefCountBits> InlineRefCounts;
// InlineRefCountBits 定义如下：
// RefCountIsInline = ture
typedef RefCountBitsT<RefCountIsInline> InlineRefCountBits;

/// 伪代码
struct InlineRefCountBits {
	uintptr_t bits;
}

// 位域 
// RefCountBitOffsets
typedef RefCountBitOffsets<sizeof(BitsType)>
    Offsets;

PureSwiftDealloc(纯 Swift 释放)：是否需要 ObjC 运行时释放。
IsImmortal：是否程序运行就一直存在的对象
IsDeiniting：是否正在释放中
UseSlowRC：是否加锁
SideTableMark：是否有 SideTable

```


### 元数据

```
HeapMetadata
using HeapMetadata = TargetHeapMetadata<InProcess>;

// InProcess
// include/swift/ABI/TargetLayout.h

// TargetHeapMetadata
// include/swift/ABI/Metadata.h
// 伪代码
struct TargetHeapMetadata: TargetMetadata {}

// TargetMetadata
// 伪代码
struct TargetMetadata {
	// 只对 non-class 元数据有效
	// MetadataKind or ISA (TargetAnyClassMetadata)
	uintptr_t kind;
}

// MetadataKind
// include/swift/ABI/MetadataKind.def

// TargetTypeMetadataHeader
// TargetMetadata 地址 - 1 

```


## 参考

[Immortal Reference Types](https://www.swift.org/documentation/cxx-interop/#immortal-reference-types)

