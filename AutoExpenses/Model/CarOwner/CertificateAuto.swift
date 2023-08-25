//
//  CertificateAuto.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class CertificateAuto : BaseAutoInfo {
    
    override init() {
        super.init()
        self.headerField = "СРТС"
        self.icon = UIImage(named: "srts_info")
        self.updateInfo()
    }
   
    func updateInfo() {
        self.id = "CertificateAuto"
        self.info = EntityCertificateAuto().checkData() ?
                    EntityCertificateAuto(id: LocalDataSource.identificatorUserCar).number : "Нет данных"
    }
    
    
    
    override func addInfo(comletion: @escaping (String) -> Void) {
        super.addInfo { (info) in
             // save data in data base
            let entity = EntityCertificateAuto(number: info)
            entity.addData()
        }
    }
    
    func deleteDataBase(index: Int) {
        let entity = EntityCertificateAuto()
        for item in EntityCertificateAuto().getDataFromDBCurrentID() {
            entity.deleteFromDb(object: item)
        }
    }
}

extension CertificateAuto {
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.keyboardType = .default
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        
        let count = text.count + string.count - range.length
        return count<=10
    }
}

