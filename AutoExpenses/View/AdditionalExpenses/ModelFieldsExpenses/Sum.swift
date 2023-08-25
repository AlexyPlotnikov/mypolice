//
//  Sum.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

// MARK: класс Model для добавления суммы

class Sum : IFieldInfo {
    
    var heightFields: CGFloat = 71
    var placeholder: String = "Введите сумму"
    var headerField: String
    var icon: UIImage?
    var sum: Float = 0.0
    var id: String = ""
    
    init() {
        headerField = "Сумма"
        icon = UIImage()
        id = "Cost"
    }

    // проверка на пустое поле
    func isEmpty() -> Bool {
        return sum <= 0.0
    }
    
    
}
