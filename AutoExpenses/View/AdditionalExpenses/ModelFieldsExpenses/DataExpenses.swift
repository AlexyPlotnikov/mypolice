//
//  DataExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

// MARK: класс Model для добавления даты
class DataExpenses : IFieldInfo {
    
    var headerField: String
    var heightFields: CGFloat = 71
    var icon: UIImage?
    var date: Date?
    var dateOld: Date?
    var id: String
    
    init() {
        headerField = "Дата"
        id = "Date"
//        textDescriptionPlacholder = "Выберите дату"
        icon = UIImage(named: "calendar")
    }
 
}
