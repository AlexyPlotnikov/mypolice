//
//  SumInMonth.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class SumInMonth: NSObject, IAddInfoProtocol {
    var heightFields: CGFloat = 71
    

    var id: String = "SumInMonth"
    var info: String = ""
    var headerField: String = ""
    var icon: UIImage?
    
    override init() {
        super.init()
        self.headerField = "Стоимость в месяц"
        self.info = "Нет данных"
//        self.icon = UIImage()
    }
    
    
    func updateInfo() {
        
        var allSum : Float = 0.0
        let indexMonth = Calendar.current.component(.month, from: Date())
        let year = Calendar.current.component(.year, from: Date())
        let structSelDate = StructDateForSelect(year: year, month: indexMonth)
        
        
//        LocalDataSource.clearCategory()
        for category in LocalDataSource.arrayCategory {
            allSum += ManagerCategory(category: category as! BaseCategory).getAllSum(year_month:structSelDate)
        }
        
        self.info = allSum > 0 ? allSum.toString("₽") : "Нет данных"
        
    }
    
   
}
