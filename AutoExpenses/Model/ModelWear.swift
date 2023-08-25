//
//  StructWear.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20.01.2020.
//  Copyright © 2020 rx. All rights reserved.
//

import UIKit

//MARK: model WEAR
class ModelWear: IModelWear {
    
    var totalPoint: Float
    var currentPoint: Float
    var unit: String
    
    init(endDate: Date, unit: String) {
        let differenceMonth = Calendar.current.dateComponents([.month,.year], from: Date(), to: endDate).month ?? 0
        currentPoint = Float(Calendar.current.component(.month, from: Date()))
        totalPoint = Float(differenceMonth)
        self.unit = unit
    }
    
    init(totalPoint: Float, currentPoint: Float, unit: String) {
        self.totalPoint = totalPoint
        self.currentPoint = currentPoint
        self.unit = unit
    }
    
    var typeLevel: LevelWear {
        get {
            switch percentageFromCurrentValue {
                case 0...30:
                    return .High
                case 30...70:
                    return .Medium
                case 70...100:
                    return .Low
                default:
                    return .Low
            }
        }
    }
    
    var color: UIColor {
        get {
            switch typeLevel {
            case .High:
                return UIColor.init(rgb: 0xFF4444)
            case .Medium:
                return #colorLiteral(red: 1, green: 0.7764705882, blue: 0.2588235294, alpha: 1)
            case .Low:
                 return UIColor.init(rgb: 0x1CD194)
            }
        }
    }
    
    var percentageFromCurrentValue: Float {
        get {
            
            guard totalPoint > 0 else {
                return 0
            }
            
            return 100 - 100 / totalPoint * currentPoint
        }
    }
        
    func kitAttributesFromTypeView(typeWear: TypeWearView) -> [NewAttrChar] {
       
        switch typeWear {
        case .Big, .Alert:
                return [NewAttrChar(color: .black,
                                    font: UIFont(name: "SFProDisplay-Bold", size: 22)!,
                                    char: Int(totalPoint - currentPoint).formattedWithSeparator),
                                
                        NewAttrChar(color: UIColor.init(rgb: 0x8C8C8C),
                                    font: UIFont(name: "SFProDisplay-Medium", size: 14)!,
                                    char: " из \(Int(totalPoint).formattedWithSeparator) \(unit)") ]
            default:
                return [NewAttrChar(color: .black,
                                            font: UIFont(name: "SFProDisplay-Bold",
                                                         size: 17)!,
                                            char: "\((totalPoint - currentPoint).formattedWithSeparator) \(unit)" )]
        }
    }
}
