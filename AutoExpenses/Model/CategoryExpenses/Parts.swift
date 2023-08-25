//
//  Parts.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 05/04/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


// MARK: класс категории тех. обслуживание
class Parts: BaseCategory {
    
   override init(typeEntity: ManagerDataBaseFromRealm.TypeEntity) {
        super.init(typeEntity: .EntityPartsCategory)
       
        self.id = "Parts"
        self.headerField = "Запчасти"
        
        self.iconCategoryActivate = UIImage(named: "parts_category")
        self.iconCategoryNotActivate = UIImage(named: "parts_category_not_activate")
        
        self.colorHead = #colorLiteral(red: 0, green: 0.6175935268, blue: 0.984972775, alpha: 1)
        self.colorGradient = UIColor.white
    }
    

}

