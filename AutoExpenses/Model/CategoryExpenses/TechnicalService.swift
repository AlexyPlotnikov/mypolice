//
//  TechnicalService.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 19/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

// MARK: класс категории тех. обслуживание
class TechnicalService : BaseCategory {
    
    var technicalService = TechnicalServiceExpenses()
    
       override init(typeEntity: ManagerDataBaseFromRealm.TypeEntity) {
          super.init(typeEntity: .EntityPartsCategory)
    
        self.id = "TO"
        self.headerField = "Ремонт"
        
        self.iconCategoryActivate = UIImage(named: "to_category")
        self.iconCategoryNotActivate = UIImage(named: "to_category_not_activate")
        
        self.colorHead = #colorLiteral(red: 1, green: 0.719625175, blue: 0, alpha: 1)
        self.colorGradient = UIColor.white
    }

    
}
