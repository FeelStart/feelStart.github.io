# TODO 

- 学习 [lexical-ios](https://github.com/facebook/lexical-ios),[Comparison of executable file formats](https://en.wikipedia.org/wiki/Comparison_of_executable_file_formats)

-  学习 [Executable and Linkable Format](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)

- 学习 DSYM 

- MEPG 

[guide](https://download.tek.com/document/25W-11418-10.pdf)

- 学习 otool 命令行工具

[Swift metadata](https://knight.sc/reverse%20engineering/2019/07/17/swift-metadata.html)

- [isa和Class](https://cloud.tencent.com/developer/article/1198887)

- OC Tagged Pointer 

```
关于参数的说明：

第一位index，代表是否开启isa指针优化。index = 1，代表开启isa指针优化。

在2013年9月，苹果推出了iPhone5s，与此同时，iPhone5s配备了首个采用64位架构的A7双核处理器，为了节省内存和提高执行效率，苹果提出了Tagged Pointer的概念。对于64位程序，引入Tagged Pointer后，相关逻辑能减少一半的内存占用，以及3倍的访问速度提升，100倍的创建、销毁速度提升。

在WWDC2013的《Session 404 Advanced in Objective-C》视频中，苹果介绍了 Tagged Pointer。 Tagged Pointer的存在主要是为了节省内存。我们知道，对象的指针大小一般是与机器字长有关，在32位系统中，一个指针的大小是32位（4字节），而在64位系统中，一个指针的大小将是64位（8字节）。

假设我们要存储一个NSNumber对象，其值是一个整数。正常情况下，如果这个整数只是一个NSInteger的普通变量，那么它所占用的内存是与CPU的位数有关，在32位CPU下占4个字节，在64位CPU下是占8个字节的。而指针类型的大小通常也是与CPU位数相关，一个指针所占用的内存在32位CPU下为4个字节，在64位CPU下也是8个字节。如果没有Tagged Pointer对象，从32位机器迁移到64位机器中后，虽然逻辑没有任何变化，但这种NSNumber、NSDate一类的对象所占用的内存会翻倍。如下图所示：


```

- 读书笔记《计算机网络》

- 苹果推送 APNS

# Doing

- 读书笔记《数据结构与算法分析-C语言描述》

- swift_heapObject.md


# Done
- 配置主题

- 支持展示图片

- 读书笔记《Redis深度历险》.md

- [Metal cumpute Demo](https://developer.apple.com/documentation/metal/performing_calculations_on_a_gpu
)


