//
//  ModelTimeSelected.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 01.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

protocol ITimeCellColor {
    var colorView: UIColor { get set }
    var colorText: UIColor { get set }
}

struct TimeCellColorWithoutBorder: ITimeCellColor {
    var colorView: UIColor
    var colorText: UIColor
}

struct TimeCellColorAvilable: ITimeCellColor {
    var colorView: UIColor
    var colorText: UIColor
    var parametrBorder: (colorBorder: UIColor, heightBorder: CGFloat)
}

class Time {

    let timers: [Int] = Array(9...20)
    func getTimeToStringFromArray(index: Int) -> String {
        return String(format:"%02i : %02i", timers[index], 0)
    }
}

class ModelTimeSelected {
    
    var time: Time?
    
    init() {
        time = Time()
    }
    
    enum SettingsTimeCell {
          case notAvilableSettings((ITimeCellColor?) = nil)
          case selectedSettings((ITimeCellColor?) = nil)
          case notSelectedSettings((TimeCellColorAvilable?) = nil)
    }
      
    func getSettingType(settingType: SettingsTimeCell) -> ITimeCellColor {
        
        let settingsTimeCell: ITimeCellColor!
        
        switch settingType {
        case .notSelectedSettings:
            settingsTimeCell = TimeCellColorAvilable(colorView: .white, colorText: UIColor.init(rgb: 0x2E2E39), parametrBorder: (colorBorder: UIColor.init(rgb: 0xCFCFCF), heightBorder: 1))
        case .selectedSettings:
            settingsTimeCell = TimeCellColorWithoutBorder(colorView: #colorLiteral(red: 1, green: 0.7764705882, blue: 0.2588235294, alpha: 1), colorText: .black)
        case .notAvilableSettings:
            settingsTimeCell = TimeCellColorWithoutBorder(colorView: UIColor.init(rgb: 0xF2F2F2), colorText: UIColor.init(rgb: 0x8F8F95))
        }
        
        return settingsTimeCell
    }
    
    
}
