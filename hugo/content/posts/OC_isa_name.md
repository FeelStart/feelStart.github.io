---
title: OC isa 定义
date: 2024-09-09T09:03:47+08:00
tags: [""]
categories: [""]

---

看到 isa 比较有意思的定义，记录一下。

```

isa means “is a”. Every Objective-C object (including every class) has an isa pointer. The runtime follows this pointer to determine what class an object is, so it knows what selectors the object responds to, what its super class is, what properties the object has, and so on.

```

![/images/class_diagram.jpeg]()

## 参考

[What does isa mean in objective-c?](https://stackoverflow.com/questions/3405224/what-does-isa-mean-in-objective-c)

[ISA Pointer](https://medium.com/@paulsoham/isa-pointer-96a2ebf33baf)