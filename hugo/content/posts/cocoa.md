---
title: "Cocoa"
date: 2024-02-01T09:03:02+08:00
draft: true

---

## 其它

* NSTableView 中使用 NSCell

```
// NSCell 中有绘制的方法。
// NSTableView 中返回 NSCell 对象。

- (id)tableView:(NSTableView *)tableView 
objectValueForTableColumn:(NSTableColumn *)tableColumn 
            row:(NSInteger)row {
            return NSCell....
            }
```

## 参考

[NSCell](https://comelearncocoawithme.blogspot.com/2011/09/custom-cells-in-nstableview-part-1.html)

[NSOutlineView](https://www.jianshu.com/p/80772f759989)