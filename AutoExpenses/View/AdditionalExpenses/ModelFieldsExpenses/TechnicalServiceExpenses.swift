//
//  TypeTechnicalWorks.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 19/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

// MARK: класс Model для добавления типа работы
class TechnicalServiceExpenses : IFieldInfo {
    
    var heightFields: CGFloat = 71
    var headerField: String
    var icon: UIImage?
    var type = String()
    var id: String
    
    let typesTechnicalWorking = ["Шиномонтаж", "Эвакуатор", "Кузовные работы", "Замена ремней", "Диагностика подвески", "Ремонт подвески", "Диагностика электрики", "Ремонт электрики", "Диагностика ДВС", "Ремонт ДВС", "Замена ДВС", "Ремонт КПП", "Замена КПП", "Заправка кондиционера", "Ремонт кондиционера", "Замена масла", "Замена тормозной жидкости", "Замена охлаждающей жидкости"]
    
    init() {
        self.headerField = "Тип технических работ"
        self.icon = UIImage(named: "tyre")
        self.type = typesTechnicalWorking[0]
        self.id = "Technical works"
    }

    
}
