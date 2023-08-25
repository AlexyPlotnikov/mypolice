//
//  CarWash.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 05/04/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


// MARK: класс категории тех. обслуживание
class CarWash: BaseCategory {
    
       override init(typeEntity: ManagerDataBaseFromRealm.TypeEntity) {
          super.init(typeEntity: .EntityPartsCategory)

        self.id = "CarWash"
        self.headerField = "Мойка авто"
       
        self.iconCategoryActivate = UIImage(named: "car_wash_category")
        self.iconCategoryNotActivate = UIImage(named: "car_wash_category_not_activate")
        
        self.colorHead = #colorLiteral(red: 1, green: 0.5475119948, blue: 0.1665211022, alpha: 1)
        self.colorGradient = UIColor.white
      
    }

 
    
}

