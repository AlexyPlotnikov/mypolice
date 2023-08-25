//
//  ChartDiagrammExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 22/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ChartDiagrammExpenses: UIView {

    enum TypeChart {
        case Line
        case Circle
    }
    private var type: TypeChart = .Line
    private var fullValue: Float = 0.0
    private var arraySegments: [ModelSegment] = []
    private var labelFullCost: UILabel?
    
    init(frame: CGRect, segments: [ModelSegment], type: TypeChart) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    
        self.arraySegments = segments
        self.type = type
        self.fullValue = 0.0
        for i in 0..<self.arraySegments.count {
            self.fullValue += self.arraySegments[i].value
        }
        
        self.labelFullCost = UILabel()
        self.labelFullCost?.text = Float(self.fullValue.roundTo(places: 0)).formattedWithSeparator
        self.labelFullCost?.textAlignment = .center
        self.labelFullCost?.font = UIFont(name: "SFUIDisplay-Bold", size: 17)
        self.addSubview(self.labelFullCost!)
        self.labelFullCost?.setNewChar(newAttr: NewAttrChar(color: UIColor.white.withAlphaComponent(0.45),
                                                            font: UIFont(name: "SFUIDisplay-Medium", size: 15)!,
                                                            char: " ₽"), standartColor: .white)
    }
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let one: Float = (type == .Circle ? (360 / fullValue) : (Float(rect.width) / fullValue))
        var startAngle: Float = 0.0
        var endAngle: Float = 0.0
        
        func nextStartAngle(index: Int) -> Float {
            var sum : Float = 0
            for i in 0...index {
                sum += arraySegments[i].value * one
            }
            return sum
        }
        
        for segm in arraySegments {
            
            let index: Int = arraySegments.firstIndex { (segment) -> Bool in
                return segment.value == segm.value && segment.color == segm.color
            }!
            
            let path: UIBezierPath?
            
            switch type {
            case .Circle:
                endAngle = nextStartAngle(index: index)                                   
                path = UIBezierPath(arcCenter: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: (rect.height - 41)/2, startAngle: CGFloat(rad2deg(Double(startAngle))), endAngle: CGFloat(rad2deg(Double(endAngle))), clockwise: true)
                
            case .Line:
                path = UIBezierPath()
                endAngle = nextStartAngle(index: index)

                path?.move(to: CGPoint(x: Double(startAngle),
                                       y: Double(self.frame.origin.y)))
                
                path?.addLine(to: CGPoint(x: Double(endAngle),
                                             y: Double(self.frame.origin.y)))
            }
            
            
            
            // Setup the CAShapeLayer with the path, colors, and line width
            let circleLayer = CAShapeLayer()
            circleLayer.path = path!.cgPath
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.strokeColor = arraySegments[index].color!.cgColor
            circleLayer.lineWidth = type == .Line ? 10 : 41
            // Don't draw the circle initially
            circleLayer.strokeEnd = 0.0
//          layers.append(circleLayer)
            startAngle = endAngle
            // Add the circleLayer to the view's layer's sublayers
            layer.addSublayer(circleLayer)
            
            animateCircle(duration: 0.25, width: 10, name: "animateCircle", _layer: circleLayer)
        }
       
        self.labelFullCost!.frame = CGRect(x: type == .Circle ? rect.midX - (rect.width * 0.5 - 41) * 0.5 : rect.midX - rect.width * 0.25,
                                           y: type == .Circle ? rect.midY - (rect.height * 0.5 - 41) * 0.5 : 10,
                                           width: type == .Circle ? rect.width * 0.5 - 41 : rect.width * 0.5,
                                           height: type == .Circle ? rect.height * 0.5 - 41 : 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func animateCircle(duration: TimeInterval, width: CGFloat, name: String, _layer: CAShapeLayer) {

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = duration
     
        animation.fromValue = 0
        animation.toValue = 1

        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        _layer.strokeEnd = width
        
        _layer.add(animation, forKey: name)
    }
    
    func rad2deg(_ number: Double) -> Double {
        return (number * .pi) / 180
    }
    
}

