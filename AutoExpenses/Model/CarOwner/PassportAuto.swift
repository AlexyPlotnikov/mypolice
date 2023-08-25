//
//  PassportAuto.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 22/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class PassportAuto: BaseAutoInfo {
    
    override init() {
        super.init()
        self.headerField = "ПТС"
        self.icon = UIImage(named: "pts_info")
        self.updateInfo()
    }
    
    func updateInfo() {

        self.id = "PassportAuto"
        self.info = EntityPassportAuto().checkData() ?
            EntityPassportAuto(id: LocalDataSource.identificatorUserCar).number : "Нет данных"
        
    }
    
    override func addInfo(comletion: @escaping (String) -> Void) {
        super.addInfo {(info) in
             // save data in data base
            let entity = EntityPassportAuto(number: info)
            entity.addData()
        }
    }
    
    func deleteDataBase(index: Int) {
        let entity = EntityPassportAuto()
        for item in EntityPassportAuto().getDataFromDBCurrentID() {
            entity.deleteFromDb(object: item)
        }
    }
    
}

extension PassportAuto {
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.keyboardType = .default
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        
        let count = text.count + string.count - range.length
        return count<=10
    }
}
