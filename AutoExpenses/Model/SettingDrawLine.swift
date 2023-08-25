//
//  DrawLine.swift
//  
//
//  Created by Иван Зубарев on 12/07/2019.
//

import Foundation
import UIKit

class SettingDrawLine {
    
    var pointStart: CGPoint?
    var pointEnd: CGPoint?
    var color: UIColor?
    var lineWidth: CGFloat = 1
    
    
    init(pointStart: CGPoint, pointEnd: CGPoint, color: UIColor, lineWidth: CGFloat) {
        self.pointStart = pointStart
        self.lineWidth = lineWidth
        self.pointEnd = pointEnd
        self.color = color
    }
    
    
    
}
