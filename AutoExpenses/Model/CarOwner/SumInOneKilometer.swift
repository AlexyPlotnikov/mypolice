//
//  SumInOneKilometer.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class SumInOneKilometer: NSObject, IAddInfoProtocol {
    
    var heightFields: CGFloat = 0
    var id: String = "SumInOneKilometer"
    var info: String = ""
    var headerField: String = ""
    var icon: UIImage?

    override init() {
        super.init()
        self.headerField = "Стоимость на км"
        self.info = "Нет данных"
    }
    
    func updateInfo() {
        var commonSum: Float = 0.0
        let indexMonth = Calendar.current.component(.month, from: Date())
        let year = Calendar.current.component(.year, from: Date())
        let structSelDate = StructDateForSelect(year: year, month: indexMonth)
//        LocalDataSource.clearCategory()
       
        for category in LocalDataSource.arrayCategory where ManagerCategory(category: category as! BaseCategory).getCommonMileage(year_month: structSelDate) > 0 {
            let manager = ManagerCategory(category: category as! BaseCategory)
            commonSum += (manager.getAllSum(year_month: structSelDate) / manager.getCommonMileage(year_month: structSelDate))
            print("SumInOneKilometer = \(indexMonth) category = \(category) : sum = \(commonSum)")
        }
        self.info = commonSum > 0.0 ? commonSum.roundTo(places: 2).toString("₽/Км") : "Нет данных"
    }
}
