---
title: "Swift_codable"
date: 2023-10-20T16:53:56+08:00
draft: true

---

日常开发时，我们常常要把服务端返回的数据转换为 model。

Objective-C 中，我们用 [Manle](https://github.com/Mantle/Mantle) 库转换 model。

Swift 本身提供 Codable 机制，更加方便转换 model 数据。

## 应用

## 类型

## 错误处理

如果类型不匹配，Codable 会抛出异常。这种机制让我们容易辨别不合法的数据，编写更安全的代码。

## 扩展思考

### 属性的转换

怎么才能把 String 类型转换为 Date 类型呢？

方法 1: 属性包装器

方法 2: 自定义编码器，类型转换时，替换相应的类型。

如 [CodableProxies](https://forums.swift.org/t/introducing-codableproxies-enhancing-encoding-and-decoding-flexibility-in-swift/67590)

### 自定义类型

方法：利用 Swift 的宏实现自定义的 Codable 方法。

