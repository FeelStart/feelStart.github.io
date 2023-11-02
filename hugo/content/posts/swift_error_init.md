---
title: "Swift_error_init"
date: 2023-10-31T09:23:29+08:00
draft: true

# Swift 的 NSError 不能直接初始化

---

```
Thread 1: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)

-[NSError init] called; this results in an invalid NSError instance. It will raise an exception in a future release. Please call errorWithDomain:code:userInfo: or initWithDomain:code:userInfo:. This message shown only once.
```
