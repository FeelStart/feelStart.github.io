---
title: "Swift lazy collection"
date: 2024-01-17T13:49:47+08:00
tags: ["Swift"]

---


Swift lazy collections 会延迟操作。这对于大集合来说，可以减少内存的使用和提高性能。但是，对于简单的集合，我们使用数组的效率会更高。

```
let numbers = [1, 2, 3].lazy.map { $0 * $0 }
print(numbers) // LazyMapCollection<Array<Int>, Int>
```

## 参考

[Add a Lazy flatMap for Sequences of Optionals](https://github.com/apple/swift-evolution/blob/main/proposals/0008-lazy-flatmap-for-optionals.md)

[Use Lazy Collections in Swift](https://www.kodeco.com/books/swift-cookbook/v1.0/chapters/9-use-lazy-collections-in-swift)
