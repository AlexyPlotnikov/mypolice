//
//  ViewTwoCell.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 12/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


class ViewTwoCell: UIView {
    
    private var arrayCell : [ViewCalculation] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for _ in 0..<2 {
            let view = ViewCalculation()
            self.addSubview(view)
            self.arrayCell.append(view)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        for _ in 0..<2 {
            let view = ViewCalculation()
            self.addSubview(view)
            self.arrayCell.append(view)
        }
    }
    
    func updating() {
        let arrayCalculation: [IAddInfoProtocol] = [SumInMonth(), SumInOneKilometer()]
        for i in 0..<arrayCalculation.count {
            arrayCalculation[i].updateInfo!()
            self.arrayCell[i].labelHeader?.text = arrayCalculation[i].headerField
            self.arrayCell[i].labelInfo?.text = arrayCalculation[i].info
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        for view in arrayCell {
            let widthCell = rect.width * 0.5
            let indexView = arrayCell.lastIndex(of: view)
            view.frame = CGRect(x: widthCell * indexView!.toCGFloat(),
                                y: 0,
                                width: widthCell,
                                height: rect.height)
            
        }
        
        let settingsLines: [SettingDrawLine] = [SettingDrawLine(pointStart: CGPoint(x: 0,
                                                                                    y: self.bounds.height),
                                                                pointEnd: CGPoint(x: self.bounds.width,
                                                                                  y: self.bounds.height),
                                                                color: UIColor.init(rgb: 0xF4F4F4),
                                                                lineWidth: 1.18),
                                                SettingDrawLine(pointStart: CGPoint(x: self.bounds.midX - 1.18 * 0.5,
                                                                                    y: 0),
                                                                pointEnd: CGPoint(x: self.bounds.midX - 1.18 * 0.5,
                                                                                  y: self.frame.height),
                                                                color: UIColor.init(rgb: 0xF4F4F4),
                                                                lineWidth: 1.18)]
        
        for setting in settingsLines {
            let draw = DrawLine(view: self, setting: setting)
            draw.drawLine()
        }
    }
}
