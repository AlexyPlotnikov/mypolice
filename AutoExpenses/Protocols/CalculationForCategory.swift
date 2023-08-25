//
//  CalculationForCategory.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20/09/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

struct CalculationStruct: ICalculation {
    var value: Float
    var typeCalculation: TypeCalculation
    var newAttr: NewAttrChar
}

class CalculationForCategory {
    
    private var arrayCalculations: [CalculationStruct]?
    private var consuptionFuel: FuelConsumption?
    private var manager: ManagerCategory!
    
    private func arrayDataBase(period: StructDateForSelect) -> [BaseCategory] {
        var array = [BaseCategory]()
        for i in 0..<manager.getCount(year_month: period) {
            let expese = manager.getDataBaseToIndex(index: i, year_month: period)
            array.append(expese)
        }
        
        return array
    }
    
    deinit {
        consuptionFuel = nil
        manager = nil
        arrayCalculations?.removeAll()
        arrayCalculations = nil
    }
    
    init(category: BaseCategory, period: StructDateForSelect) {
        arrayCalculations = [CalculationStruct]()
        
        self.manager = ManagerCategory(category: category)
        
        var _period = period
        
        if consuptionFuel == nil {
            self.consuptionFuel = FuelConsumption()
        }
        
        var array = arrayDataBase(period: period)
        
        // gavno
        if period.month == 1 {
            _period = StructDateForSelect(year: period.year-1, month: 1)
        } else {
            _period = StructDateForSelect(year: period.year, month: period.month-1)
        }

        let arrayTemp = arrayDataBase(period: _period)
        
        if let nextExpense = arrayTemp.sorted(by: {$0.dateField!.date! > $1.dateField!.date!}).first {
            array.append(nextExpense)
        }
        
        array = array.sorted(by: {$0.dateField!.date! > $1.dateField!.date!})
        
        let mileage: Float = array.count > 0 ?
        Float((array[0].mileageField?.info.toInt() ?? 0) - (array[array.count-1].mileageField?.info.toInt() ?? 0)) : 0 //manager.getCommonMileage(year_month: period)
        
        let groupSorted = array.sorted(by: {$0.sumField!.sum > $1.sumField!.sum}).group(by:{($0).sumField!.sum})
        var topValue: Float = 0
        
        for dictonary in groupSorted where dictonary.value.count > 1 && dictonary.value.count > Int(topValue) {
            topValue = Float(dictonary.key)
        }
 
        let attrAddCharRub = NewAttrChar(color: UIColor.white.withAlphaComponent(0.6), font: UIFont(name: "SFUIDisplay-Bold", size: 13)!, char: " ₽")
                
        var allSum: Float = 0
        for i in 0..<array.count {
            if i > 0 {
                allSum += array[i].sumField!.sum
            }
        }
        
        let costOneKM = allSum / (mileage <= 0 ? 1 : mileage)
        
        let daysCount = array.count > 1 ? Int().dayBeetweenTwoDates(startDate: array[array.count-1].dateField!.date!, endDate: array[0].dateField!.date!) ?? 1 : 1
        
        let rubDay = allSum / Float(daysCount > 0 ? daysCount : 1)
        
        if category.id == "Fuel" {
            let consuption = self.consuptionFuel!.getConsuptionToPeriod(array: array as! [Fuel])
            arrayCalculations?.append(CalculationStruct(value: consuption, typeCalculation: .ConsuptionFuel, newAttr: NewAttrChar(color: UIColor.white.withAlphaComponent(0.6), font: UIFont(name: "SFUIDisplay-Bold", size: 13)!, char: " л")))
        }
        
        arrayCalculations?.append(CalculationStruct(value: rubDay, typeCalculation: .RubInDay, newAttr: attrAddCharRub))
        arrayCalculations?.append(CalculationStruct(value: costOneKM, typeCalculation: .CostOneKM, newAttr: attrAddCharRub))
    }
    
    func getArrayCalculation() -> [CalculationStruct]? {
        return self.arrayCalculations
    }
 

    
}
