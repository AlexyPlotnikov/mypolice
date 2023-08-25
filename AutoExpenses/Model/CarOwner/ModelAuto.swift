//
//  ModelAuto.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift

class ModelAuto : BaseAutoInfo {
    
    override init() {
        super.init()
        updateInfo()
    }

    func updateInfo() {
        self.id = "ModelAuto"
        self.headerField = "Автомобиль"
        self.icon = UIImage(named: "car")
        self.info = EntityModelAuto().checkData() ?
            EntityModelAuto(id: LocalDataSource.identificatorUserCar).nameModel : "Модель авто"
    }
    
    override func addInfo(comletion: @escaping (String) -> Void) {
        super.addInfo { (info) in
            
            if !info.isEmpty {
                let entity = EntityModelAuto(nameModel: info)
                entity.addData()
                self.info = info
                // TODO: Analytics
                AnalyticEvents.logEvent(.AddedNameAuto)
                comletion(info)
            }
        }
    }
    
    func deleteDataBase(index: Int) {
        let entity = EntityModelAuto()
        for item in EntityModelAuto().getDataFromDBCurrentID() {
            entity.deleteFromDb(object: item)
        }
    }
}

extension ModelAuto {
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.keyboardType = .default
    }

    
}
