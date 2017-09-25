//
//  CircularTransition.swift
//  BomberMan
//
//  Created by AndreOsip on 9/25/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class CircularTransition: NSObject {
    var circle = UIView()
    
    var startingPoint = CGPoint.zero {
        didSet {
        circle.center = startingPoint
        }
    }
    
    var circleColor = UIColor.white
    
    var duration = 0.5
    
    enum CircularTransitionMode { case present, dismiss }
    
    var transitionMode: CircularTransitionMode = .present
    

}

extension CircularTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            if let presentedView = transitionContext.view(forKey: .to) {
            let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                circle = UIView()
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                circle.backgroundColor = circleColor
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                containerView.addSubview(circle)
                
                presentedView.center = startingPoint
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentedView.alpha = 0
                containerView.addSubview(presentedView)
                
                UIView.animate(withDuration: duration, animations: {
                self.circle.transform = CGAffineTransform.identity
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    presentedView.center = viewCenter
                }, completion: { success in
                    transitionContext.completeTransition(success)
                })
                
            }
            
        
        } else {
            if let fromView = transitionContext.view(forKey: .from) {
            let viewCenter = fromView.center
                let viewSize = fromView.frame.size
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint

                UIView.animate(withDuration: duration, animations: {
                self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    fromView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    fromView.center = self.startingPoint
                    fromView.alpha = 0
                }, completion: { success in
                    fromView.center = viewCenter
                    fromView.removeFromSuperview()
                    
                    self.circle.removeFromSuperview()
                    
                    transitionContext.completeTransition(success)
                
                })
            
            }
        }
    }

}

func frameForCircle(withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
    let xLenght = fmax(startPoint.x,viewSize.width - startPoint.x)
    let yLenght = fmax(startPoint.y,viewSize.height - startPoint.y)
    
    let offsetVector = sqrt(xLenght * xLenght + yLenght * yLenght) * 2
    let size = CGSize(width: offsetVector, height: offsetVector)
    
    return CGRect(origin: CGPoint.zero, size: size)
}
