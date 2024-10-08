---
title: "BUG：微信委托代扣，点“完成”按钮没返回 APP"
date: 2023-12-28T07:53:13+08:00
tags: ["BUG"]

---


最近，公司做个微信委托代扣功能。功能测试时，发现个问题，录屏下来。

从录屏中发现两个问题：

1 APP 调起微信后，状态栏没有返回 APP 的按钮。

2 微信委托代扣成功后，点 “完成” 按钮，没有返回 APP，要更换为 APP 的。

# 问题分析

问题 1:

网上查资料，其时苹果的特性，并且不能手动关闭。于是，找到出现问题的同事，验证一下。发现其机型录屏的时候，状态栏没有返回 APP 的按钮。录屏结束后，有返回 APP 的按钮。这是符号预期的。

问题 2:

之前，我们有接入过微信的 SDK，有分享的功能，APP 与微信时互通的。

查看网上的资料，发现也有人遇到相似的问题，但是并不符合我们的情况。

查看 [微信常见问题](https://developers.weixin.qq.com/community/pay/doc/0004aaa01e8908b165985d15e5bc08)，里面第 18 条，有提到可能有 4 种情况。

排除了情况 1，2，情况 3 其他同事排除了，情况 4 应该也不太可能。

计划重现下，看是否有哪些条件设置错了。

这时，大家一起聊这个问题，发现 Mweb，Android，iOS 都有这个问题。有个同事查看了微信的文档，发现预签约时，有个参数可以控制返回 APP。

最后，返回参数加上了，发现不行。

查看 kibana 的数据，后端传的 appid 是公众号号的。 


# 反思

1 做功能的时候，只关注自己的部分，没有对功能的全貌进行了解。

2 问题分析搜索的关键词不准。

3 问题分析的时候，没有把握整体，忽略细节。

# 参考



https://apple.stackexchange.com/questions/320596/disable-return-to-previous-app-button-in-ios

https://pay.weixin.qq.com/wiki/doc/api/wxpay_v2/papay/chapter3_1.shtml
