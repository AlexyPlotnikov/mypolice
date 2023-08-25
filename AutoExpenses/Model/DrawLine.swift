//
//  DrawLine.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 12/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import UIKit

class DrawLine {
    
    private var view: UIView?
    private var setting: SettingDrawLine?
    
    
    init(view: UIView, setting: SettingDrawLine?) {
        self.view = view
        self.setting = setting
    }
    
    func drawLine() {
        
        let path = UIBezierPath()
        path.move(to: self.setting!.pointStart!)
        path.addLine(to: self.setting!.pointEnd!)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = self.setting!.color!.cgColor
        shapeLayer.lineWidth = self.setting!.lineWidth
        self.view!.layer.addSublayer(shapeLayer)
       
    }
}
