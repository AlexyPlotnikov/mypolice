//
//  Fuel.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 15/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

// MARK: класс категории топлива

class Fuel : BaseCategory {
    
    var priceLiterField = PricePerLiter()
    
    override init(typeEntity: ManagerDataBaseFromRealm.TypeEntity) {
        super.init(typeEntity: typeEntity)
        
        self.id = "Fuel"
        self.headerField = "Топливо"
        
        self.iconCategoryActivate = UIImage(named: "fuel_category")
        self.iconCategoryNotActivate = UIImage(named: "fuel_category_not_activate")
        
        self.colorHead = #colorLiteral(red: 0.6389183402, green: 0.2789767981, blue: 0.9130561352, alpha: 1)
        self.colorGradient = UIColor.white
        
        if  self.sumField == nil {
            self.sumField = Sum()
        }
        
    }
    
    func updateInfo() {
        if self.typeView == .Additional {
            self.priceLiterField.price = getPricePerLiter()
        }
    }

    func getPricePerLiter() -> Float {
        let manager = ManagerDataBaseFromRealm(typeEntity: .EntityFuelCategory)
            if manager.checkData() {
            let array = (manager.getDataFromDBCurrentID(year_month: SelectedDate.shared.getDate()) as! [EntityFuelCategory]).sorted(by: {$0.date > $1.date})
                    return array.count > 0 ? array[0].priceToLiter : 0.0
            }
        return 0.0
    }
    
}
