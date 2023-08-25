//
//  ChooseDateController.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 10/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import UIKit

struct StructDateForSelect {
   
    enum TypeDate {
        case YearIndex
        case MonthIndex
        case YearString
        case MonthString
        case ArrayYear
        case ArrayMonth
        case CustomMonthAndYear
        case CurrentWeek
        case CurrentMonth
        case CurrentYear
        case AllTime
    }
    
    let arrayMonth = ["За год",
                      "Январь",
                      "Февраль",
                      "Март",
                      "Апрель",
                      "Май",
                      "Июнь",
                      "Июль",
                      "Август",
                      "Сентябрь",
                      "Октябрь",
                      "Ноябрь",
                      "Декабрь"]
    
    var arrayYear: [String] {
        var array = [Int]()
        
        for category in (LocalDataSource.arrayCategory as! [BaseCategory]) where ManagerCategory(category: category).getYearDataBase().count>0 {
            array.append(contentsOf: ManagerCategory(category: category).getYearDataBase())
        }
        
        array = array.removingDuplicates()
        array = array.sorted(by: {$0 > $1})
        return array.map {Optional(String($0))!}
    }
    
    var year: Int = Calendar.current.component(.year, from: Date())
    var month: Int = 0
    
    subscript(type: TypeDate) -> Any? {
        get {
            switch type {
                
            case .MonthIndex:
                return month
                
            case .YearIndex:
                return year
                
            case .YearString:
                if let index = arrayYear.firstIndex(of: year.toString()), arrayYear.count > index {
                    return year.toString()
                }
                return arrayYear[0]
            
            case .MonthString:
                return arrayMonth[month]
                 
            case .ArrayYear:
                return arrayYear
                
            case .ArrayMonth:
                return arrayMonth
                
            case .CustomMonthAndYear:
                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = month
                return dateComponents
                
            case .AllTime:
                return nil
                
            case .CurrentWeek:
                return Calendar.current.dateComponents([.month, .year, .weekOfMonth], from: Date())
                
            case .CurrentMonth :
                return Calendar.current.dateComponents([.month, .year], from: Date())
                
            case .CurrentYear :
                return Calendar.current.dateComponents([.year], from: Date())
            }
        }
    }
}


class ChooseDateController {
    
    weak var delegateUpdateGraphics: DelegateReloadData?
    weak var delegateUpdateLabel: DelegateReloadData?
    
    func showDataPicker() {
        let alert = CustomPickerViewController(parentView: UIApplication.shared.keyWindow!.rootViewController!.view!, title: "Выберите дату", message:  nil, arrayElementsInPicker:
            [ViewSettings(elements: SelectedDate.shared.getArrayMonthName(), title: "Месяц"),
             ViewSettings(elements: SelectedDate.shared.getArrayYearName(), title: "Год")])
    
        let choose = CustomAlertAction(title: "Выбрать", styleAction: .normal) {
            SelectedDate.shared.saveDate(date: StructDateForSelect(year: alert.year, month: alert.monthIndex))
            self.delegateUpdateGraphics?.updateData()
            self.delegateUpdateLabel?.updateData()
        }
        
        let cancel = CustomAlertAction(title: "Отмена", styleAction: .default, handler: nil)
        alert.addAction(cancel)
        alert.addAction(choose)
        alert.showAlert(year_month: StructDateForSelect(year: SelectedDate.shared.getDate().year, month: SelectedDate.shared.getDate().month))
    }
    
    
//    private func update() {
//        SelectedDate.shared.saveDate(date: StructDateForSelect(year: SelectedDate.shared.getDate().year, month: SelectedDate.shared.getDate().month))
//    }
}

extension Array where Element: Hashable {

    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}


