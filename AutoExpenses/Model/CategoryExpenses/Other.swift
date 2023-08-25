//
//  Other.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 15/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

// MARK: класс категории другие
class Other : BaseCategory {
    
       override init(typeEntity: ManagerDataBaseFromRealm.TypeEntity) {
          super.init(typeEntity: .EntityPartsCategory)
       
        self.id = "Other"
        self.headerField = "Другие"
    
        self.iconCategoryActivate = UIImage(named: "other_category")
        self.iconCategoryNotActivate = UIImage(named: "other_category_not_activate")
        
        self.colorHead = #colorLiteral(red: 0, green: 0.7471761107, blue: 0.9914408326, alpha: 1)
        self.colorGradient = UIColor.white

    }
 
}
