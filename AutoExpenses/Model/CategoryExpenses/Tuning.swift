//
//  Tuning.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 05/04/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


// MARK: класс категории тех. обслуживание
class Tuning: BaseCategory {
    
      override init(typeEntity: ManagerDataBaseFromRealm.TypeEntity) {
         super.init(typeEntity: .EntityPartsCategory)
        
        self.id = "Tuning"
        self.headerField = "Тюнинг"
        
        self.iconCategoryActivate = UIImage(named: "tuning_category")
        self.iconCategoryNotActivate = UIImage(named: "tuning_category_not_activate")
        
        self.colorHead = #colorLiteral(red: 0.4405456483, green: 0.788498342, blue: 0, alpha: 1)
        self.colorGradient = UIColor.white
       
    }
  
}

