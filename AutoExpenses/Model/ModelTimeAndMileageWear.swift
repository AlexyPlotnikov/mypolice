//
//  ModelTimeAndMileageWear.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20.01.2020.
//  Copyright © 2020 rx. All rights reserved.
//

import UIKit

//MARK: Struct WEAR to TIME & Wear TO MILEAGE
struct ModelTimeAndMileageWear {
    var modelTime: IModelWear
    var modelMileage: IModelWear
    var nameHeader: String?
    var typeWearView: TypeWearView!
    
    mutating func updateViewWear(viewForUpdate: UIView, typeIfNeedReplace: (TypeWearView?) = nil) {
        switch viewForUpdate {
        case is ViewWearBig:
            typeWearView = typeIfNeedReplace ?? TypeWearView.Big
            
            let view = (viewForUpdate as! ViewWearBig)
            view.wearToMileage.updateData(model: modelMileage, typeWear: typeWearView)
            view.headerLabel.text = nameHeader
            view.headerLabel.addSpacing(countSpace: 5)
            
        case is ViewWearSmall:
            typeWearView = typeIfNeedReplace ?? TypeWearView.Small
            
            let view = (viewForUpdate as! ViewWearSmall)
            view.wearToMileage.updateData(model: modelMileage, typeWear: typeWearView)
            view.wearToTime.updateData(model: modelTime, typeWear: typeWearView)
            view.headerLabel.text = nameHeader
            
        case is ViewPanelAlert:
            typeWearView = typeIfNeedReplace ?? TypeWearView.Alert
            
            let view = (viewForUpdate as! ViewPanelAlert)
            view.wearMileage!.updateData(model: modelMileage, typeWear: typeWearView)
            view.wearTime!.updateData(model: modelTime, typeWear: typeWearView)
            view.labelHeader!.text = nameHeader
            view.labelSubHeader?.text = "Входит в ТО - 10 000"
            view.labelMini?.text = "Осталось"
            
        case is ViewPanelAlertTable:
            
            typeWearView = typeIfNeedReplace ?? TypeWearView.Alert
            let view = (viewForUpdate as! ViewPanelAlertTable)
            view.labelHeader!.setNewChar(newArrayAttr: [NewAttrChar(color: UIColor.init(rgb: 0xFF4647), font: UIFont(name: "SFProDisplay-Bold", size: 25)!, char: "\u{2022} "),
                                                        NewAttrChar(color: UIColor.black, font: view.labelHeader!.font, char: nameHeader!)])
        default:
            break
        }
        
    }
}
