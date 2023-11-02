---
title: "C++_type_traits"
date: 2023-10-25T15:16:39+08:00
draft: true

---

enable_if 的定义：

```
template <bool, typename T=void>
struct enable_if {
};

template <typename T>
struct enable_if<true, T> { 
  using type = T;           
};
```

```
template<typename T, typename Enable = std::enable_if<std::is_integral<T>::value>::type>
constexpr auto add(T a, T b)
{
    return a + b;
}
```

如上面例子，enable_if 为 true，其 type 才有效，否则会报错。
 
 ## 参考
 
 https://juejin.cn/post/7027950165503770660

