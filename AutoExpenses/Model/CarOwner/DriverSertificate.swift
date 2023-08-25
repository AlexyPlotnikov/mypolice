//
//  DriverSertificate.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class DriverSertificate : BaseAutoInfo {
   
    override init() {
        super.init()
        self.headerField = "Права"
        self.icon = UIImage(named: "vu_info")
        self.updateInfo()
    }
    
    func updateInfo() {

        self.id = "DriverSertificate"
        self.info = EntityDriverCertificate().checkData() ?
                    dateSelected(date: EntityDriverCertificate(id: LocalDataSource.identificatorUserCar).dateEnd) : "Нет данных"
    }
    
    override func addInfo(comletion: @escaping (String) -> Void) {
        let vc = LocalDataSource.headViewController

        let alertDataPicker = CustomDataPickerController(parentView: vc!.view, title: "Дата окончания прав", message: "", pickerMode: .date)
        
       
        
        let actionOk = CustomAlertAction(title: "Готово", styleAction: .default) {
            self.info = self.dateSelected(date : alertDataPicker.dataPicker.date)
            let entity = EntityDriverCertificate(dateEnd: alertDataPicker.dataPicker.date)
            entity.addData()
            comletion(self.info)
            self.delegateUpdateData?.updateData()
        }
        
        let actionCancel = CustomAlertAction(title: "Отмена", styleAction: .default, handler: nil)
        
        alertDataPicker.addAction(actionCancel)
        alertDataPicker.addAction(actionOk)
        
        alertDataPicker.showAlert()
        
        if(EntityDriverCertificate().checkData()) {
            alertDataPicker.dataPicker.date = EntityDriverCertificate(id: LocalDataSource.identificatorUserCar).dateEnd  // выставляет дату из базы данных по открытию DataPicker
        }
    }
    
    func deleteDataBase(index: Int) {
        let entity = EntityDriverCertificate()
        for item in entity.getDataFromDBCurrentID() {
            entity.deleteFromDb(object: item)
        }
    }
    
    //selected date func
    func dateSelected(date : Date)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_MD")
        return dateFormatter.string(from: date)
    }

    
}

