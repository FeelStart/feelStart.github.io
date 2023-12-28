---
title: "Swift_runtime_property"
date: 2023-11-03T09:50:20+08:00
draft: true

---

# Swift runtime 添加属性

```
    static var animationDelegateKey: String = "UILabelAnimationDelegateKey"

    var animationDelegate: AnimationDelegate {
        // 注意：这里如果直接用 animationDelegateKey，取回的值可能会为 nil，要转换为 UnsafeRawPointer。
        let key = UnsafeRawPointer(bitPattern: Self.animationDelegateKey.hashValue)
        if let animationDelegate = objc_getAssociatedObject(self, key!) as? AnimationDelegate {
            return animationDelegate
        }

        let animationDelegate = AnimationDelegate()
        objc_setAssociatedObject(self, key!, animationDelegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return animationDelegate
    }
```

## 参考

https://coderwong.com/2017/05/15/Swift-%E4%BD%BF%E7%94%A8runtime%E7%BB%99extension%E6%B7%BB%E5%8A%A0%E5%B1%9E%E6%80%A7/
