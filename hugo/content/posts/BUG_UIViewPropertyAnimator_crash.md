---
title: "[UIViewPropertyAnimator dealloc] 崩溃"
date: 2024-01-10T12:50:28+08:00
tags: ["Bug"]

---

# -[UIViewPropertyAnimator dealloc] 崩溃

## 崩溃信息 
 ```
It is an error to release a paused or stopped property animator. Property animators must either finish animating or be explicitly stopped and finished before they can be released.
```

## 崩溃处理

UIViewPropertyAnimator 重新赋值时，先完成动画。
