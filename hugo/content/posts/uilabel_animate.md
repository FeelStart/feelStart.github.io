---
title: "Uilabel_animate"
date: 2023-11-03T08:11:02+08:00
draft: true

---

# UILabel 文本变化的动画

```
extension UILabel {
    class AnimationDelegate: NSObject, CAAnimationDelegate {
        var startHandler: ( () -> Void )?
        var stopHandler: ( (Bool) -> Void )?

        func animationDidStart(_ anim: CAAnimation) {
            startHandler?()
        }

        func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            stopHandler?(flag)
        }
    }

    var animation: CATransition {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.type = .push
        animation.subtype = .fromTop
        animation.duration = 0.3
        animation.delegate = animationDelegate
        return animation
    }

    static let AnimationDelegateKey = "UILabelAnimationDelegateKey"

    var animationDelegate: AnimationDelegate? {
        guard let key = UnsafeRawPointer(bitPattern: Self.AnimationDelegateKey.hashValue) else { return nil }

        if let animationDelegate = objc_getAssociatedObject(self, key) as? AnimationDelegate {
            return animationDelegate
        }

        let animationDelegate = AnimationDelegate()
        objc_setAssociatedObject(self, key, animationDelegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return animationDelegate
    }

    static let AnimationTaskKey = "UILabelAnimationTaskKey"

    var animationTask: Task<Void, Never>? {
        get {
            guard let key = UnsafeRawPointer(bitPattern: Self.AnimationTaskKey.hashValue) else { return nil }
            return objc_getAssociatedObject(self, key) as? Task<Void, Never>
        }
        set(task) {
            guard let key = UnsafeRawPointer(bitPattern: Self.AnimationTaskKey.hashValue) else { return }
            objc_setAssociatedObject(self, key, task, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    static let LoopingAttributedTexts = "UILabelLoopingAttributedTexts"

    @objc
    public var loopingAttributedTexts: [NSAttributedString]? {
        get {
            guard let key = UnsafeRawPointer(bitPattern: Self.LoopingAttributedTexts.hashValue) else { return nil }
            return objc_getAssociatedObject(self, key) as? [NSAttributedString]
        }
        set(loopingTextList) {
            guard let key = UnsafeRawPointer(bitPattern: Self.LoopingAttributedTexts.hashValue) else { return }
            objc_setAssociatedObject(self, key, loopingTextList, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: - Public

    @objc
    public func setAttributeTextAnimated(_ attributeText: NSAttributedString?,
                                         animations: ( (_ attributeText: NSAttributedString?) -> Void )?,
                                         completion: ( (_ finished: Bool) -> Void )?) {
        animationDelegate?.stopHandler = completion

        alpha = 0
        layer.add(animation, forKey: "UILabel-Transition")
        self.attributedText = attributeText
        alpha = 1
        animations?(attributeText)
    }

    @objc
    public func loopingAttributedTexts(_ attributedTexts: [NSAttributedString],
                                                                              nextDelay: ( () -> Float )?,
                                       animations: ( (_ attributeText: NSAttributedString?) -> Void )?,
                                       handler: ( (_ attributeText: NSAttributedString) -> Bool)?) {
        if attributedTexts.count <= 1 {
            self.attributedText = attributedTexts.first
            stopLoopingAttributedTexts()
            return
        }

        if loopingAttributedTexts == attributedTexts {
            return
        }

        loopingAttributedTexts = attributedTexts

        func doNextAnimation() {
            animationTask = Task.detached { [weak self] in
                try? await Task.sleep(nanoseconds: UInt64(1_000_000_000 * (nextDelay?() ?? 4)))
                if !Task.isCancelled {
                    await MainActor.run { [weak self] in
                        guard let _ = self else { return }
                        doAnimation()
                    }
                }
            }
        }

        var iterator = attributedTexts.makeIterator()
        func doAnimation() {
            let text: NSAttributedString
            if let _text = iterator.next() {
                text = _text
            } else {
                iterator = attributedTexts.makeIterator()
                text = iterator.next() ?? NSAttributedString(string: "")
            }

            if let handler, handler(text) {
                loopingAttributedTexts = nil
                return
            }

            if self.attributedText == nil {
                self.attributedText = text
                doNextAnimation()
                return
            }

            setAttributeTextAnimated(text, animations: animations) { _ in
                doNextAnimation()
            }
        }

        doAnimation()
    }

    @objc
    public func stopLoopingAttributedTexts() {
        loopingAttributedTexts = nil
        animationTask?.cancel()
    }
}

```
