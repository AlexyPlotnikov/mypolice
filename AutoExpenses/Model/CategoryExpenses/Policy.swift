//
//  Policy.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 15/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

// MARK: класс категории страховой полис
class Policy : BaseCategory {
    
       override init(typeEntity: ManagerDataBaseFromRealm.TypeEntity) {
         super.init(typeEntity: .EntityPartsCategory)
       
        self.id = "Policy"
        self.headerField = "ОСАГО"
        
        self.iconCategoryActivate = UIImage(named: "policy_category")
        self.iconCategoryNotActivate = UIImage(named: "policy_category_not_activate")
        
        self.colorHead = #colorLiteral(red: 0.9428817034, green: 0.2024185359, blue: 0.469422698, alpha: 1)
        self.colorGradient = UIColor.white
        
    }
    
   
    
    
}
