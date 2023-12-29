---
title: "Ios_apple_intent"
date: 2023-11-17T18:48:53+08:00
tags: ["iOS"]

---

# iOS 开发 intents

## Intens

在主项目创建 Intent 目录。

创建打开的 Intent：

```

struct MainIntent: AppIntent {
    static var title: LocalizedStringResource = "MainIntent"

    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

/// 快捷指令（可以在 Shortcut APP 上展示）
struct OpenShortcutProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: MainIntent()
                    , phrases: ["Open \(.applicationName)"],
                    shortTitle: "Open App",
                    systemImageName: "")
    }
}
```

## 唤醒 APP

方案 1：通过 Intent 唤起 App 后，复用现有的链接打开页面逻辑，调用 OpenURL 打开对应的页面。

方案 2: 设计路由

## 问题

* 使用 Xcode 提供的 Apple Intents Extensions 模版创建的 Intent 会不成功。而在主项目直接创建的 Intent 可以。

## 参考
[docs](https://developer.apple.com/documentation/appintents)

[App Intents Spotlight integration using Shortcuts](https://www.avanderlee.com/swiftui/app-intents-spotlight-integration-using-shortcuts/)

[iOS-自定义Intent及ShortCut](https://blog.csdn.net/qq_43441647/article/details/133017285)

[Open App background](https://stackoverflow.com/questions/76500378/how-to-open-app-via-appintents-conditionally)

[](https://alexanderlogan.co.uk/blog/wwdc22/04-intents)

[](https://alexanderlogan.co.uk/blog/wwdc22/04-intents)

[](https://juejin.cn/post/6844903621839028232)

[](https://developer.apple.com/documentation/sirikit/intent_handling_infrastructure/creating_an_intents_app_extension)

[](https://openradar.appspot.com/FB11739659)

[extension](https://juejin.cn/post/6866250776281350157)

[直接创建 extension 错误](https://developer.apple.com/forums/thread/710552)

[autoShortcutProviderMangledName](https://developer.apple.com/forums/thread/717272)

[info.plist](https://developer.apple.com/documentation/bundleresources/information_property_list/uiapplicationshortcutitems/uiapplicationshortcutitemtitle)