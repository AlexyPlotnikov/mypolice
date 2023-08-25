//
//  TechnicalInspection.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 22/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TechnicalInspection : BaseAutoInfo {
    
    override init() {
        super.init()
        self.headerField = "Тех. осмотр"
        self.icon = UIImage(named: "to_info")
        self.updateInfo()
    }
    
    func updateInfo() {
        
        self.id = "TechnicalInspection"
        self.info = EntityTechnicalInspection().checkData() ?
            dateSelected(date: EntityTechnicalInspection(id: LocalDataSource.identificatorUserCar).dateEnd) : "Нет данных"
        
        
    }
    
    
    override func addInfo(comletion: @escaping (String) -> Void) {
        
        let vc = LocalDataSource.headViewController
        
        let alert = CustomDataPickerController(parentView: vc!.view, title: self.headerField, message: "", pickerMode: .date)
        let actionOk = CustomAlertAction(title: "Готово", styleAction: .normal) {
            self.info = self.dateSelected(date: alert.dataPicker.date)
            
            // save data in data base
            let entity = EntityTechnicalInspection(dateEnd: alert.dataPicker.date)
            entity.addData()
            
            comletion(self.info)
            self.delegateUpdateData?.updateData()
        }
        
        let actionCancel = CustomAlertAction(title: "Отмена", styleAction: .normal, handler: nil)
        
        
        alert.addAction(actionCancel)
        alert.addAction(actionOk)
        
        
        alert.showAlert() // создает алерт и открывает
        if(EntityTechnicalInspection().checkData()){
            alert.dataPicker.date = EntityTechnicalInspection(id: LocalDataSource.identificatorUserCar).dateEnd  // выставляет дату из базы данных про открытие DataPicker
        }
    }
        
    func deleteDataBase(index: Int) {
        let entity = EntityTechnicalInspection()
        for item in EntityTechnicalInspection().getDataFromDBCurrentID() {
            entity.deleteFromDb(object: item)
        }
    }
    
    
    //selected date func
    func dateSelected(date : Date)->String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_MD")
        return dateFormatter.string(from: date)
    }
}
