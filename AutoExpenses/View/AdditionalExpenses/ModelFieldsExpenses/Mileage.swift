//
//  Mileage.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import Foundation

// MARK: класс Model для добавления пробега
class Mileage : BaseAutoInfo {
    
    var placeholder: String = "Введите пробег"
    
    override init() {
        super.init()
        self.heightFields = 71
        headerField = "Пробег"
        updateInfo()
    }

    
    override func isEmpty() -> Bool {
        return self.info.isEmpty || Float(self.info)! <= 0.0
    }
    
    func updateInfo() {
        self.id = "Mileage"
        self.info = EntityMileageAuto().checkData() ?
            EntityMileageAuto(id: LocalDataSource.identificatorUserCar).mileage.toString() : ""
        icon = UIImage(named: "mileage_info")
    }
    
    
    override func addInfo(comletion: @escaping (String) -> Void) {
        super.addInfo { (textInfo) in
            let entity = EntityMileageAuto(mileage: Int(textInfo) ?? 0)
            if entity.mileage > 0 {
                entity.addData()
                // TODO: Analytics
                AnalyticEvents.logEvent(.AddedMileage)
                self.updateInfo()
            }
        }
    }
    
    func deleteDataBase(index: Int) {
        for item in EntityMileageAuto().getDataFromDBCurrentID() {
            item.deleteFromDb()
        }
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        textField.keyboardType = .numberPad
    }
}

