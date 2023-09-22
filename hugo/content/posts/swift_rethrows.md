---
title: "Swift_rethrows"
date: 2023-09-20T08:07:06+08:00
tags: ["swift"]

---

# swift rethrows

rethrows 顾名思义是传递异常的意思。

使用场景：当函数参数为异常函数时，函数本身不会抛出异常，可以用 rethrows。

比如：

```
func log(complete: ( ( () throws -> Void ) )) -> rethrows {
  try complete()
}
```

用法：

```
log() {
}

try log() {
try ...
}
```