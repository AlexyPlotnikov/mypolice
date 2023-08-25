//
//  ViewWearNotUrgently.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewWearSmall: ViewWearBase {
    
    weak var headerLabel: UILabel!
    weak var wearToTime: ViewShowWear!
    weak var wearToMileage: ViewShowWear!
    
    override init(delegate: (DelegateOpenAdditionalScreen?) = nil, model: (ModelTimeAndMileageWear?) = nil) {
        super.init(delegate: delegate, model: model)
        self.layer.cornerRadius = 13
        self.layer.borderColor = UIColor.init(rgb: 0xDADADA).cgColor
        self.layer.borderWidth = 1
        
        let header = UILabel()
        headerLabel = header
        headerLabel!.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        self.addSubview(headerLabel!)
        
        let wearTime = ViewShowWear()
        wearToTime = wearTime
        self.addSubview(wearToTime)
        
        let wearMileage = ViewShowWear()
        wearToMileage = wearMileage
        wearToMileage.textHeader?.text = "Осталось"
        self.addSubview(wearToMileage)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(functionOpenAlert)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let widthLine: CGFloat = 1
//             if lineHeader == nil {
                let lineH = DrawLine(view: self, setting:
                SettingDrawLine(pointStart:
                    CGPoint(x: 0,
                            y: headerLabel!.frame.height - widthLine), pointEnd:
                    CGPoint(x: self.frame.width,
                            y: headerLabel!.frame.height - widthLine),
                                                                       color: UIColor.init(rgb: 0xDADADA),
                                                                       lineWidth: widthLine))
 //                 lineHeader = lineH
                 lineH.drawLine()
//             }
             
//             if lineCenter == nil {
                let lineC = DrawLine(view: self, setting: SettingDrawLine(pointStart:
                        CGPoint(x: self.frame.width * 0.5,
                                y: wearToMileage!.frame.minY + 29.5), pointEnd:
                        CGPoint(x: self.frame.width * 0.5,
                                y: wearToMileage!.frame.maxY - 20.5),
                                                           color: UIColor.init(rgb: 0xDADADA), lineWidth: widthLine))
//                 lineCenter = lineC
                 lineC.drawLine()
//             }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let heightHeader = self.frame.height * 0.32
        headerLabel?.frame = CGRect(x: 13,
                                     y: 0,
                                     width: self.frame.width - 13,
                                     height: heightHeader)
         
        let heightCenter = self.frame.height - heightHeader - 18
        wearToMileage?.frame  = CGRect(x: 0,
                                        y: headerLabel!.frame.maxY,
                                        width: self.frame.width * 0.5 - 0.5,
                                        height: heightCenter)
         
        wearToTime?.frame  = CGRect(x: wearToMileage!.frame.maxX + 1,
                                     y: headerLabel!.frame.maxY,
                                     width: self.frame.width * 0.5 - 0.5,
                                     height: heightCenter)
    
    }
}
