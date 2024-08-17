---
title: "IOS耳机控制音频"
date: 2024-01-30T10:37:16+08:00
tags: ["iOS"]

---

## 代码

```
import MediaPlayer

@objc
public protocol MediaPlayerCommandCenterObserver: NSObjectProtocol {

    @objc
    optional func mediaPlayerCommandCenterPlay(_ center: MediaPlayerCommandCenter)

    @objc
    optional func mediaPlayerCommandCenterPause(_ center: MediaPlayerCommandCenter)

}

public class MediaPlayerCommandCenter: NSObject {

    @objc
    public static let shared = MediaPlayerCommandCenter()

    private let observers = NSPointerArray.weakObjects()

    public override init() {
        super.init()

        let center = MPRemoteCommandCenter.shared()

        center.playCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }

            self.enumerateObservers { observer, _ in
                if let observer, observer.responds(to: #selector(MediaPlayerCommandCenterObserver.mediaPlayerCommandCenterPlay)) {
                    observer.mediaPlayerCommandCenterPlay?(self)
                }

                return false
            }

            return .success
        }

        center.pauseCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }

            self.enumerateObservers { observer, _ in
                if let observer, observer.responds(to: #selector(MediaPlayerCommandCenterObserver.mediaPlayerCommandCenterPause)) {
                    observer.mediaPlayerCommandCenterPause?(self)
                }

                return false
            }

            return .success
        }
    }

    private func enumerateObservers(_ hander: ( (_ observer: MediaPlayerCommandCenterObserver?, _ index: Int) -> Bool)) {
        observers.compact()

        let count = observers.count
        if count == 0 {
            _ = hander(nil, 0)
        }

        for idx in 0...count-1 {
            let observer: MediaPlayerCommandCenterObserver?
            if let pointer = observers.pointer(at: idx) {
                observer = Unmanaged<MediaPlayerCommandCenterObserver>.fromOpaque(pointer).takeUnretainedValue()
            } else {
                observer = nil
            }

            if hander(observer, idx) {
                break
            }
        }
    }

    // MARK: - Public

    @objc
    public func setActive(_ active: Bool) {
        if active {
            UIApplication.shared.beginReceivingRemoteControlEvents()
        } else {
            UIApplication.shared.endReceivingRemoteControlEvents()
        }
    }

    @objc
    public func add(observer: MediaPlayerCommandCenterObserver) {
        observers.addPointer(Unmanaged.passUnretained(observer).toOpaque())
    }

    @objc
    public func remove(observer: MediaPlayerCommandCenterObserver) {
        enumerateObservers { oldObserver, index in
            if oldObserver?.isEqual(observer) == true {
                observers.removePointer(at: index)
                return true
            }

            return false
        }
    }

}

```

## 参考
https://developer.apple.com/library/archive/documentation/Audio/Conceptual/AudioSessionProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007875-CH1-SW1

https://cloud.tencent.com/developer/article/2342658

https://cloud.tencent.com/developer/article/2342658
