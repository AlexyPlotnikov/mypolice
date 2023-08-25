//
//  PricePerLiter.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

// MARK: класс Model для добавления цены за литр
class PricePerLiter : IFieldInfo {

    var headerField: String
    var icon: UIImage?
    var id: String = ""
    var price = Float()
    var heightFields: CGFloat = 71
    var placeholder: String = "Введите стоимость литра"
    func isEmpty() -> Bool {
        return price <= 0.0
    }
    
    init() {
        headerField = "Цена за литр"
        icon = UIImage(named: "gas")
        id = "Price Per Liter"
        let manager = ManagerDataBaseFromRealm(typeEntity: .EntityFuelCategory)
        if manager.checkData() {
            price = (manager.getAllDataFromDB()[0] as! EntityFuelCategory).priceToLiter
        }
    }
    
}

