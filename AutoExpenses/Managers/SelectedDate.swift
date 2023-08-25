//
//  SelectedDate.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 19/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class SelectedDate {
     
    static var shared: SelectedDate = SelectedDate()
    private var year_month: StructDateForSelect = StructDateForSelect()
    
// индекс выбранного месяца
    func getSelectedIndexMonth() -> Int {
        return self.year_month.month
    }
    
    // индекс выбранного года
    func getSelectedIndexYear() -> Int {
        return self.year_month.year
    }
    
    // массив имен всех месяцев
    func getArrayMonthName() -> [String] {
        return year_month[.ArrayMonth] as! [String]
    }
    
    // массив имен текущего и предыдущего года
    func getArrayYearName() -> [String] {
        return year_month[.ArrayYear] as! [String]
    }
    
    // имя выбранного месяца
    func getStringMonth() -> String {
        return year_month[.MonthString] as! String
    }
    
    // имя выбранного года
    func getStringYear() -> String {
        return year_month[.YearString] as! String
    }
    
    // сохранение даты
    func saveDate(date: StructDateForSelect) {
        // TODO: Analytics
        AnalyticEvents.logEvent(.SelectedDateStatistic, params: ["MonthAndYear": "\(date.month)-\(date.year)"])
        self.year_month = date
    }
    
    func getDate() -> StructDateForSelect {
        return StructDateForSelect(year: self.year_month.year, month: self.year_month.month)
    }
   
}
