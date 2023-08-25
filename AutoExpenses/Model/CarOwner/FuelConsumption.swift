//
//  FuelConsumption.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class FuelConsumption: NSObject, IAddInfoProtocol {
    
    var id: String = "FuelConsumption"
    var info = "Нет данных"
    var headerField: String = ""
    var icon: UIImage?
    var heightFields: CGFloat = 71
    var editional: Bool{
        get { return false }
    }
    
    override init() {
        super.init()
        self.headerField = "Расход"
        self.icon = UIImage(named: "consuption_info")
        self.updateInfo()
    }
    
    func updateInfo() {
        
        let manager = ManagerDataBaseFromRealm(typeEntity: .EntityFuelCategory)
        
        if manager.getDataFromDBCurrentID().count > 1 {
        
            let array = manager.getDataFromDBCurrentID().sorted(by: {($0 as! EntityFuelCategory).mileage > ($1 as! EntityFuelCategory).mileage}) as! [EntityFuelCategory]
            
           var countLiters: Float = 0
             for item in array where array.firstIndex(of: item) != array.count-2 {
                 countLiters += (item.sum / item.priceToLiter)
             }
                 
                 
             let directionMileage = (Float(array[0].mileage) - Float(array[array.count-1].mileage))
            
             if directionMileage <= 0 || countLiters <= 0 {
                 return 
             }
                 
             let consuption = (countLiters / directionMileage * 100).roundTo(places: 2)
            
            self.info = consuption.toString("л / 100 км")
        } else {
            self.info = "Нет данных"
        }
        
    }
    
    func getConsuptionToPeriod(array: [Fuel]) -> Float {
//        let manager = ManagerDataBaseFromRealm(typeEntity: .EntityFuelCategory)
//            if manager.getDataFromDBCurrentID(year_month: period).count > 1 {
//                let array = manager.getDataFromDBCurrentID(year_month: period).sorted(by: {($0 as! EntityFuelCategory).date > ($1 as! EntityFuelCategory).date}) as! [EntityFuelCategory]
//
        var countLiters: Float = 0
        for i in 1..<array.count where array[i].priceLiterField.price > 0 {
            print((array[i].sumField!.sum / array[i].priceLiterField.price))
            countLiters += (array[i].sumField!.sum / array[i].priceLiterField.price)
        }
                    
        let endMileage = Float(array[array.count-1].mileageField?.info ?? "0") ?? 0
        let startMileage = Float(array[0].mileageField?.info ?? "0") ?? 0
        
        let directionMileage = startMileage - endMileage
               
        if directionMileage <= 0 || countLiters <= 0 {
            return 0
        }
                    
        let consuption = (countLiters / directionMileage * 100).roundTo(places: 2)
                    
        return consuption
    }
    
}
