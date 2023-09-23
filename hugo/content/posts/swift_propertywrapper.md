---
title: "Swift_propertywrapper"
date: 2023-09-22T21:04:23+08:00
tags: ["swift"]

---

# swift propertyWrapper

日常的开发之前，我们常常要对属性做一下限制。比如考试的分数最高分是 100 分，因此我们的分数不能大于 100。

为此，我们要写为：

```
class Exam {
    private var _score: Float = 0
    var score: Float {
        set(score) {
            if score < 0 {
                _score = 0
            } else if score > 100 {
                _score = 100
            } else {
                _score = score
            }
        }
        get { _score }
    }
}
```
这样我们编写大量的代码去处理这些相同的情况，不够简洁和不易理解。

propertyWrapper 提供这样的一种机制：在属性存取上加一层，可以方便地处理这些情况。

## propertyWrapper 的使用

```
@propertyWrapper
struct ExamWrapper {
    private var value: Float = 0.0

    var wrappedValue: Float {
        set {
            if newValue < 0 {
                value = 0
            } else if newValue > 100 {
                value = 100
            } else {
                value = newValue
            }
        }
        get { value }
    }

    init(wrappedValue: Float) {
        self.value = wrappedValue
    }
}
```

注意：这里的初始化的名称要是 ``` init(wrappedValue:) ``` 的形式。

然后，上面的例子我们就可以这样写了。

```
class Exam {
    @ExamWrapper
    var score = 0
}
```

## 定义参数

propertyWrapper 可以允许你传递参数到内部。如上面的情况，要更改它的初始化函数。

```
init(wrappedValue: Float, _ maxScore: CGFloat) {
    self.value = wrappedValue
}
```

然后，使用是这样的：

```
class Exam {
    @ExamWrapper(100)
    var score = 0
}
```

## wrappedValue

包装的值，其类型与属性的一致。

注意：其名称要是 ``` wrappedValue ```

## projectedValue

projectedvalue 提供额外的方式获取其它值，其类型可以与属性的不一致。

其值的获取如:

```
let man = Man()
man.$age // 获取 projectedValue
```

比如，利用 combine 库就利用其特性实现属性修改的监控。

我们也可以这样实现：

```
@propertyWrapper
struct ValueWillChangePublisher<T> {

    private let subject = PassthroughSubject<T, Never>()

    var wrappedValue: T {
        willSet {
            subject.send(newValue)
        }
    }

    var projectedValue: any Publisher {
        subject.eraseToAnyPublisher()
    }

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

class Man {
    @ValueWillChangePublisher
    var age = 1
}

let man = Man()
man.$age.sink { _ in
}
```


## 参考

[propertyWrapper](https://github.com/apple/swift-evolution/blob/main/proposals/0258-property-wrappers.md)