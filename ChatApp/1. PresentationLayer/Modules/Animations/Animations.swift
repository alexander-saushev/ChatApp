//
//  Animations.swift
//  ChatApp
//
//  Created by Александр Саушев on 25.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ButtonAnimation {
    public class func shake(_ view: UIView) {
        
        let animationX = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animationX.values = [0, -5, 0, 5]
        animationX.isAdditive = true
        
        let animationY = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animationY.values = [0, -5, 0, 5]
        animationY.isAdditive = true
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [0, NSNumber(value: Double.pi / 10), 0, NSNumber(value: -Double.pi / 10), 0]
        rotation.isCumulative = true
        
        let group = CAAnimationGroup()
        group.animations = [animationX, animationY, rotation]
        group.duration = 0.3
        group.repeatCount = .infinity
        group.autoreverses = true
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        view.layer.add(group, forKey: "shake")
    }

    public class func stopShake(_ view: UIView) {
        view.layer.removeAnimation(forKey: "shake")

        guard let currentLayer = view.layer.presentation() else { return }

        let positionAnimationX = CABasicAnimation(keyPath: "transform.translation.x")
        positionAnimationX.fromValue = currentLayer.value(forKeyPath: "transform.translation.x")
        positionAnimationX.toValue = 0

        let positionAnimationY = CABasicAnimation(keyPath: "transform.translation.y")
        positionAnimationY.fromValue = currentLayer.value(forKeyPath: "transform.translation.y")
        positionAnimationY.toValue = 0

        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = currentLayer.value(forKeyPath: "transform.rotation.z")
        rotate.toValue = 0

        let group = CAAnimationGroup()
        group.animations = [
            positionAnimationX,
            rotate,
            positionAnimationY
        ]
        group.duration = 0.3

        view.layer.add(group, forKey: "stab")
    }
}

class LogoAnimation {
    private static var logoCell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "logo")?.cgImage
        cell.scale = 0.05
        cell.emissionRange = .pi
        cell.lifetime = 0.7
        cell.birthRate = 10
        cell.velocity = 50
        cell.spin = -0.5
        return cell
    }()

    private static var logoLayer: CAEmitterLayer = {
        let logoLayer = CAEmitterLayer()
        logoLayer.emitterSize = CGSize(width: 10, height: 10)
        logoLayer.emitterShape = .circle
        logoLayer.beginTime = CACurrentMediaTime()
        logoLayer.timeOffset = CFTimeInterval(1)
        logoLayer.emitterCells = [logoCell]
        return logoLayer
    }()

    static func addToLayer(_ layer: CALayer) {
        layer.addSublayer(logoLayer)
    }

    static func remove() {
        logoLayer.removeFromSuperlayer()
    }

    static func moveToPosition(_ position: CGPoint) {
        logoLayer.emitterPosition = position
    }
}

extension UIView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first, let window = self.window else { return }
        LogoAnimation.moveToPosition(touch.location(in: window))
        LogoAnimation.addToLayer(window.layer)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first, let window = self.window else { return }
        LogoAnimation.moveToPosition(touch.location(in: window))
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        LogoAnimation.remove()
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        LogoAnimation.remove()
    }
}

class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let dismissing: Bool

    init(dismissing: Bool) {
        self.dismissing = dismissing
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if dismissing {
            dismiss(using: transitionContext)
        } else {
            present(using: transitionContext)
        }
    }

    private func dismiss(using context: UIViewControllerContextTransitioning) {
        guard let fromVC = context.viewController(forKey: .from) else { return }

        let containerView = context.containerView

        containerView.addSubview(fromVC.view)

        UIView.animate(withDuration: transitionDuration(using: context),
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                            fromVC.view.alpha = 0
                       }, completion: { _ in
                            context.completeTransition(true)
                       })
    }

    private func present(using context: UIViewControllerContextTransitioning) {
        guard let toVC = context.viewController(forKey: .to),
              let fromVC = context.viewController(forKey: .from) else { return }

        let containerView = context.containerView

        toVC.view.alpha = 0
        toVC.view.frame = fromVC.view.frame
        containerView.addSubview(toVC.view)

        UIView.animate(withDuration: transitionDuration(using: context),
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                            toVC.view.alpha = 1
                       }, completion: { _ in
                        context.completeTransition(true)
                       })
    }
}
