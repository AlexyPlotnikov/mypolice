//
//  Parking.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 05/04/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


// MARK: класс категории тех. обслуживание
class Parking: BaseCategory {
    
       override init(typeEntity: ManagerDataBaseFromRealm.TypeEntity) {
         super.init(typeEntity: .EntityPartsCategory)
        
        self.id = "Parking"
        self.headerField = "Парковка"

        self.iconCategoryActivate = UIImage(named: "parking_category")
        self.iconCategoryNotActivate = UIImage(named: "parking_category_not_activate")
        
        self.colorHead = #colorLiteral(red: 0, green: 0.8873860836, blue: 0.727417171, alpha: 1)
        self.colorGradient = UIColor.white
        
    }
    
}

