//
//  ViewScheduleLinear.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 12/09/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewScheduleLinear: UIView {

    private var arrayLabelPoint: [UILabel]?
    private var dataForScheludeArray: [DataForSchedule]?
    private var backColor: UIColor?
    private var layers: [CAShapeLayer]?
    private var type: TypeVisual = .todDay
    
    enum TypeVisual {
        case toMonth
        case todDay
    }
    
    private func textLabelToDay(textForLabel: String, index: Int) -> String {
        if dataForScheludeArray!.count > 16 {
            return index % 3 == 0 ? textForLabel : ""
        } else {
            return textForLabel
        }
    }
    
    func setup(dataForScheludeArray: [DataForSchedule], color: UIColor?, type: TypeVisual) {
        self.type = type
        self.dataForScheludeArray = dataForScheludeArray
        self.backColor = color

        if self.dataForScheludeArray!.count < 2 {
                   return
               } else {
                   if let array = arrayLabelPoint {
                       for label in array where array.contains(label) && self.subviews.contains(label) {
                           label.removeFromSuperview()
                       }
                   }
                   
                   if let array = self.layer.sublayers {
                       for lay in array {
                           lay.removeFromSuperlayer()
                       }
                   }
               }
        
        self.arrayLabelPoint = [UILabel]()
        
        for element in self.dataForScheludeArray! {
        let indexElement = self.dataForScheludeArray!.firstIndex { (elem) -> Bool in
            element.point! == elem.point!
        }
            
            let formatter = DateFormatter()
            let monthComponents = formatter.shortStandaloneMonthSymbols
            
            let textLabel = self.type == .todDay ? Calendar.current.component(.day, from: element.point!).toString() : monthComponents![Calendar.current.component(.month, from: element.point!)-1]
            
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont(name: "SFUIDisplay-Regular", size: 12)
            label.text = textLabelToDay(textForLabel: textLabel, index: indexElement!)
            label.textColor = .white
            label.alpha = 0
            self.arrayLabelPoint?.append(label)
            self.addSubview(label)
        }
        
        setNeedsDisplay()
    }
    
    private func getCenterForPoint(indexPoint: Int) -> CGPoint {
        let heightScaleView = (self.frame.height / 1.5) - (arrayLabelPoint![0].frame.height + 10)
        let valueOneInView = heightScaleView / CGFloat(self.dataForScheludeArray!.max(by: {$0.value! < $1.value!})?.value ?? 1)
        return CGPoint(x: self.arrayLabelPoint![indexPoint].frame.midX,
                       y: heightScaleView - valueOneInView * CGFloat(self.dataForScheludeArray![indexPoint].value!) + 10)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
        guard let arrayLabelPoint = arrayLabelPoint, self.dataForScheludeArray!.count > 1 else {
            return
        }
        
        let centerYView = ((self.frame.height) - self.arrayLabelPoint![0].frame.height) * 0.5
        let bottomPointY = ((self.frame.height) - self.arrayLabelPoint![0].frame.height)
        
        // начальная позиция
        let line = UIBezierPath()
        line.move(to: CGPoint(x: 0,
                              y: centerYView))
        
        
        let pointY = (getCenterForPoint(indexPoint: 0).y) * (getCenterForPoint(indexPoint: 1).y > centerYView ? -1.1 : 1.1)
        let centrX = getCenterForPoint(indexPoint: 0).x / 2
       
        line.addQuadCurve(to: getCenterForPoint(indexPoint: 0), controlPoint: CGPoint(x: centrX,
        y: pointY))
        
//        line.addLine(to: getCenterForPoint(indexPoint: 0))
        
        // построение других точек
        for j in 0..<arrayLabelPoint.count {
            //  проверка, что бы вывести линию за край экрана
            if j + 1 < arrayLabelPoint.count {
//                line.addLine(to: getCenterForPoint(indexPoint: j+1))
                
                let pointX = getCenterForPoint(indexPoint: j).x + (getCenterForPoint(indexPoint: j+1).x - getCenterForPoint(indexPoint: j).x) / 2
                
                let pointY_1 = getCenterForPoint(indexPoint: j).y
                let pointY_2 = getCenterForPoint(indexPoint: j+1).y
                
                line.addCurve(to: getCenterForPoint(indexPoint: j+1),
                              controlPoint1: CGPoint(x: pointX, y: pointY_1),
                              controlPoint2: CGPoint(x: pointX, y: pointY_2))
            } else {
                // линия к правому краю
                line.addLine(to: CGPoint(x: self.frame.width,
                                         y: centerYView))
            }
        }
        
        
        // добавление градиента
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = UIColor.clear.cgColor
        lineShape.strokeColor = UIColor.white.cgColor
        lineShape.lineWidth = 2
        self.layer.insertSublayer(lineShape, at: 0)
        
        
        line.addLine(to: CGPoint(x: self.frame.width,
                                 y: bottomPointY))
        line.addLine(to: CGPoint(x: 0,
                                 y: bottomPointY))
        line.close()
        
        let gradientShape = CAShapeLayer()
        gradientShape.path = line.cgPath
        gradientShape.fillColor = UIColor.white.cgColor
        gradientShape.strokeColor = UIColor.clear.cgColor
        gradientShape.lineWidth = 2

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.3).cgColor, backColor!.withAlphaComponent(0.1).cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = CGRect(x: 0,
                                     y: 0,
                                     width: self.frame.width,
                                     height: bottomPointY)
        gradientLayer.mask = gradientShape
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        
        
        for i in 0..<arrayLabelPoint.count {
            let circle = UIBezierPath(arcCenter: getCenterForPoint(indexPoint: i), radius: 4, startAngle: 0, endAngle:
                .pi * 2, clockwise: true)
            let shapeCircle = CAShapeLayer()
            shapeCircle.path = circle.cgPath
            shapeCircle.fillColor = self.backColor!.cgColor
            shapeCircle.strokeColor = UIColor.white.cgColor
            shapeCircle.lineWidth = 2
            self.layer.addSublayer(shapeCircle)
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if arrayLabelPoint != nil {
            let sizeLabel = CGSize(width: self.frame.width/(arrayLabelPoint?.count ?? 1).toCGFloat(),
                                   height: (self.frame.height) * 0.2)
            
            for point in self.arrayLabelPoint! {
                let index = self.arrayLabelPoint?.firstIndex(of: point) ?? 0
                point.frame = CGRect(origin: CGPoint(x: sizeLabel.width * index.toCGFloat(),
                                                     y: (self.frame.height) - sizeLabel.height),
                                     size: sizeLabel)
                point.alpha = 0.6
            }
        }
    }
}


extension Sequence {
   func groupSort(ascending: Bool = false, byDate dateKey: (Iterator.Element) -> Date) -> [[Iterator.Element]] {
       var categories: [[Iterator.Element]] = []
       for element in self {
           let key = dateKey(element)
        guard let dayIndex = categories.firstIndex(where: { $0.contains(where: { Calendar.current.isDate(dateKey($0), inSameDayAs: key) }) }) else {
            guard let nextIndex = categories.firstIndex(where: { $0.contains(where: { dateKey($0).compare(key)
                == (ascending ? .orderedDescending : .orderedAscending) }) }) else {
                   categories.append([element])
                   continue
               }
               categories.insert([element], at: nextIndex)
               continue
           }
           
        guard let nextIndex = categories[dayIndex].firstIndex(where: { dateKey($0).compare(key)
== (ascending ? .orderedDescending : .orderedAscending) }) else {
               categories[dayIndex].append(element)
               continue
           }
           categories[dayIndex].insert(element, at: nextIndex)
       }
       return categories
   }
   
    
        func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
            var categories: [U: [Iterator.Element]] = [:]
            for element in self {
                let key = key(element)
                if case nil = categories[key]?.append(element) {
                    categories[key] = [element]
                }
            }
            return categories
    }

        
        func groupBy<G: Hashable>(closure: (Iterator.Element)->G) -> [G: [Iterator.Element]] {
            var results = [G: Array<Iterator.Element>]()
            
            forEach {
                let key = closure($0)
                
                if var array = results[key] {
                    array.append($0)
                    results[key] = array
                }
                else {
                    results[key] = [$0]
                }
            }
            
            return results
        }
}

