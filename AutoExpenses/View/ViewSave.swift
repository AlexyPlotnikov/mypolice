//
//  ViewSave.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 13/08/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewSave: UIView {
    
    var arrayBezier: [UIBezierPath] = []
    var numCurrent = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    
    
    func showScreenSave() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        }) {(state) in
            let circle = UIBezierPath(arcCenter: CGPoint(x: self.frame.midX,
                                                         y: self.frame.midY),
                                      radius: 40,
                                      startAngle: CGFloat(self.rad2deg(30)),
                                      endAngle: CGFloat(self.rad2deg(325)),
                                      clockwise: true)
            
            let pointX = cos(CGFloat(self.rad2deg(325))) * 40 + self.frame.midX
            let pointY = sin(CGFloat(self.rad2deg(325))) * 40 + self.frame.midY
            
            let lineOne = UIBezierPath()
            lineOne.move(to: CGPoint(x: pointX, y: pointY))
            lineOne.addLine(to: CGPoint(x: self.frame.midX,
                                        y: self.frame.midY+10))
            
            let lineTwo = UIBezierPath()
            lineTwo.move(to: CGPoint(x: self.frame.midX, y: self.frame.midY + 10))
            lineTwo.addLine(to: CGPoint(x: (cos(CGFloat(self.rad2deg(200))) * 15 + self.frame.midX),
                                        y: (sin(CGFloat(self.rad2deg(200))) * 15 + self.frame.midY)))
            
            
            let array: [UIBezierPath] = [circle, lineOne, lineTwo]
            
            self.arrayBezier = array
            
            self.playAnimation(num: 0, duration: 0.5)
        }
       
    }
    
    
    private func playAnimation (num: Int, duration: Float) {
        let circleLayer  = CAShapeLayer()
        circleLayer.path = arrayBezier[num].cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0.2588235294, alpha: 1).cgColor
        circleLayer.lineWidth = 12
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        circleLayer.lineCap = .round
        
        //          layers.append(circleLayer)
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
        
        
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = CFTimeInterval(duration)
        
        animation.fromValue = 0
        animation.toValue = 1
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        circleLayer.strokeEnd = 12
        circleLayer.add(animation, forKey:num.toString())
       
    }
    
    private func rad2deg(_ number: Double) -> Double {
        return (number * .pi) / 180
    }
}
extension ViewSave: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        switch numCurrent {
        case 0:
            playAnimation(num: 1, duration: 0.2)
            numCurrent = 1
        case 1:
            playAnimation(num: 2, duration: 0.1)
            numCurrent = 2
        default:
            UISelectionFeedbackGenerator().selectionChanged()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35) {
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0
               
            }) {(state) in
                for lay in self.layer.sublayers! {
                    lay.removeFromSuperlayer()
                }
                
                self.numCurrent = 0
                self.arrayBezier.removeAll()
            }
                return
                
            }
        }
    }
}
