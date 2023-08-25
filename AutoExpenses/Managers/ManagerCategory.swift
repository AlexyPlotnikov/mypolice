//
//  ManagerCategory.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 10/10/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import RealmSwift

class ManagerCategory {

    private var manager: ManagerDataBaseFromRealm!
    var category: BaseCategory?
    private var typeView = TypeView.Additional
    
    
    init(category: BaseCategory) {
        self.category = category
        
        
        
       switch category {
             case is Fuel:
//                category = Fuel()
                manager = ManagerDataBaseFromRealm(typeEntity: .EntityFuelCategory)
             case is Parts:
//                category = Parts()
                manager = ManagerDataBaseFromRealm(typeEntity: .EntityPartsCategory)
             case is Policy:
//                category = Policy()
                manager = ManagerDataBaseFromRealm(typeEntity: .EntityPolicyInsurent)
             case is Other:
//                category = Other()
                manager = ManagerDataBaseFromRealm(typeEntity: .EntityOtherCategory)
             case is Tuning:
//                category = Tuning()
                manager = ManagerDataBaseFromRealm(typeEntity: .EntityTuningCategory)
             case is Parking:
//                category = Parking()
                manager = ManagerDataBaseFromRealm(typeEntity: .EntityParkingCategory)
             case is CarWash:
//                category = CarWash()
                manager = ManagerDataBaseFromRealm(typeEntity: .EntityCarWashCategory)
             case is TechnicalService:
//                category = TechnicalService()
                manager = ManagerDataBaseFromRealm(typeEntity: .EntityTechnicalServiceCategory)
            default:
                manager = ManagerDataBaseFromRealm(typeEntity: .EntityOtherCategory)
        }
    
    }
    
    
    deinit {
        print("deinit ManagerCategory")
        category = nil
        manager = nil
    }
    
    func isEmptyField() -> UIAlertController? {
        let array = [self.category?.sumField!] as! [IFieldInfo]
        var message = "Введите "
        for field in array where field.isEmpty != nil && field.isEmpty!() {
            switch field {
            case is Sum:
                message += "сумму"
            case is Mileage:
                message += "пробег"
            default:
                return nil
            }
            
            let alert = UIAlertController(title: "Не заполено поле", message: message, preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alert.addAction(actionOk)
            return alert
        }
        return nil
    }
    
    func getTypeView() -> TypeView {
        return self.typeView
    }
    
    func setDateFromCategory() -> Date {
        return self.category?.dateField?.date ?? Date()
    }
    
    init() {
        manager = ManagerDataBaseFromRealm(typeEntity: .EntityOtherCategory)
    }
    
    func addDataeBase(arrayFields: [IFieldInfo]) {
        
        let calendarComponents : Set<Calendar.Component> = [.year, .month, .day]
        let oldDate = Calendar.current.dateComponents(calendarComponents, from: self.category!.dateField!.date ?? Date())
        let newDate = Calendar.current.dateComponents(calendarComponents, from: Date())
        self.category!.dateField!.date = oldDate == newDate ? Date() : self.category!.dateField!.date ?? Date()
        
        let entityArray = manager.getDataFromDBCurrentID()
        
      
            if self.typeView == .Editional {
                    self.deleteDataBaseFindToDate(date: self.category!.dateField!.date!)
            }
                             
                             
                             // TODO: Analytic
                             var params = Dictionary <String, String>()
                             for item in arrayFields {
                                 switch item {
                                 case is Sum:
                                     params["Cost"] = (item as! Sum).sum.toString("₽")
                                 case is Mileage:
                                     params["Mileage"] = (item as! Mileage).info
                                 case is PricePerLiter:
                                     params["CostPerLiter"] = (item as! PricePerLiter).price.toString("₽")
                                 case is DataExpenses:
                                     params["DateExpenses"] = (item as! DataExpenses).date?.toString()
                                 case is TechnicalService:
                                     params["TechnicalService"] = (item as! TechnicalService).technicalService.type
                                 case is Comment:
                                     params["Comment"] = (item as! Comment).comment
                                 case is Photo:
                                     params["Photo"] = (item as! Photo).arrayPhotos?.count.toString("photo")
                                 default:
                                     break
                                 }
                             }
                             AnalyticEvents.logEvent(.AddedNewExpense, params: params)
                             //
                             
                    for item in entityArray {
                        if manager.dataForCompareInDataBase(item: item).date == self.category!.dateField!.dateOld {
                            manager.deleteFromDb(obj: item)
                        }
                    }
                
            
                
                manager.addData(obj: entity)
                category!.updateMileage()
      
    }
    
    private var entity: Object {
        
        let date = self.category!.dateField!.date ?? Date()
        let comment = self.category!.commentField.comment
        let mileage = Int(self.category!.mileageField!.info) ?? 0
        let sum = self.category!.sumField!.sum
        let photos = self.category!.photo!.dataImages()
        
        switch self.category {
        case is Fuel:
            return EntityFuelCategory(date: date,
                                      priceToLiter: (self.category as! Fuel).priceLiterField.price,
                                      comment: comment,
                                      mileage: mileage,
                                      sum: sum,
                                      photos: photos)
            
        case is Parts:
            return EntityPartsCategory(date: date,
                                       comment: comment,
                                       mileage: mileage,
                                       sum: sum,
                                       photos: photos)
        
        case is Policy:
            return EntityPolicyInsurent(date: date,
                                        comment: comment,
                                        mileage: mileage,
                                        sum: sum,
                                        photos: photos)
            
        case is Other:
            return EntityOtherCategory(date: date,
                                             comment: comment,
                                             mileage: mileage,
                                             sum: sum,
                                             photos: photos)
            
        case is Tuning:
            return EntityTuningCategory(date: date,
                                             comment: comment,
                                             mileage: mileage,
                                             sum: sum,
                                             photos: photos)
            
        case is Parking:
            return EntityParkingCategory(date: date,
                                               comment: comment,
                                               mileage: mileage,
                                               sum: sum,
                                               photos: photos)
        case is CarWash:
            return EntityCarWashCategory(date: date,
                                                comment: comment,
                                                mileage: mileage,
                                                sum: sum,
                                                photos: photos)
            
        case is TechnicalService:
            return EntityTechnicalServiceCategory(date: date,
                                                  typesTechnicalWorking: (self.category as! TechnicalService).technicalService.type,
                                                  comment: comment,
                                                  mileage: mileage,
                                                  sum: sum,
                                                  photos: photos)
        default:
            return EntityOtherCategory(date: date,
                                       comment: comment,
                                       mileage: mileage,
                                       sum: sum,
                                       photos: photos)
        }
    }
    

    
    func getYearDataBase() -> [Int] {
        var arrayYear: [Int] = [Calendar.current.component(.year, from: Date())]
        for item in manager.getAllDataFromDB() where !arrayYear.contains(Calendar.current.component(.year, from: manager.dataForCompareInDataBase(item: item).date)) {
            let newYear = Calendar.current.component(.year, from: manager.dataForCompareInDataBase(item: item).date)
            arrayYear.append(newYear)
        }

        return arrayYear
    }
    
    
    func getCommonMileage(year_month: StructDateForSelect) -> Float {
        if manager.getDataFromDBCurrentID(year_month: year_month).count > 1 {
            let array = manager.getDataFromDBCurrentID(year_month: year_month).sorted(by: { manager.dataForCompareInDataBase(item: $0).date > manager.dataForCompareInDataBase(item: $1).date})
            
            let min = manager.dataForCompareInDataBase(item:array[array.count-1]).mileage
            let max = manager.dataForCompareInDataBase(item:array[0]).mileage
            return Float(max - min)
        }
        return 0.0
    }
    
    
    func getDataBaseToIndex(index: Int, year_month: StructDateForSelect) -> BaseCategory {
        
        let entity = manager.getDataFromDBCurrentID(year_month: year_month)[index]
        
        var category: BaseCategory?
        
        switch manager.typeEntity {
        case .EntityFuelCategory:
            category = Fuel(typeEntity: manager.typeEntity)
            (category as! Fuel).priceLiterField.price = (entity as! EntityFuelCategory).priceToLiter
            
        case .EntityCarWashCategory:
            category = CarWash(typeEntity: manager.typeEntity)
        
        case .EntityOtherCategory:
            category = Other(typeEntity: manager.typeEntity)
       
        case .EntityParkingCategory:
            category = Parking(typeEntity: manager.typeEntity)
        
        case .EntityPartsCategory:
            category = Parts(typeEntity: manager.typeEntity)
        
        case .EntityPolicyInsurent:
            category = Policy(typeEntity: manager.typeEntity)
            
        case .EntityTechnicalServiceCategory:
            category = TechnicalService(typeEntity: manager.typeEntity)
            (category as! TechnicalService).technicalService.type = (entity as! EntityTechnicalServiceCategory).typesTechnicalWorking
            
        case .EntityTuningCategory:
            category = Tuning(typeEntity: manager.typeEntity)
        }
        
        category!.dateField!.date = manager.dataForCompareInDataBase(item: entity).date
        category!.sumField!.sum = manager.dataForCompareInDataBase(item: entity).sum
        category!.mileageField!.info = String(manager.dataForCompareInDataBase(item: entity).mileage)
        category!.commentField.comment = manager.dataForCompareInDataBase(item: entity).comment
        
        for photo in manager.dataForCompareInDataBase(item: entity).photos {
            category!.photo!.arrayPhotos?.append(photo.photo)
        }
        return category!
    }
    
    func getCount(year_month: StructDateForSelect) -> Int {
        return manager.getDataFromDBCurrentID(year_month: year_month).count
    }
    
    func getAllSum(year_month: StructDateForSelect) -> Float {
        var allSum : Float = 0.0
        for item in manager.getDataFromDBCurrentID(year_month: year_month) {
            allSum += manager.dataForCompareInDataBase(item:item).sum.roundTo(places: 1)
        }
       return allSum
    }
    
    func deleteDataBase(year_month: StructDateForSelect, index: (Int?) = nil) {
        let array = manager.getDataFromDBCurrentID(year_month: year_month)
        if index == nil {
            for item in array {
                manager.deleteFromDb(obj: item)
            }
        } else {
            manager.deleteFromDb(obj:array[index!])
        }
    }
    
    func getDataBaseIndexElementToDate(date: Date) -> Int? {
        let array = manager.getDataFromDBCurrentID()
        for i in 0..<array.count where manager.dataForCompareInDataBase(item: array[i]).date == date {
            return i
        }
         return nil
    }
    
    func deleteDataBaseFindToDate(date: Date) {
        for item in manager.getAllDataFromDB() where manager.dataForCompareInDataBase(item: item).date == date {
            manager.deleteFromDb(obj: item)
        }
    }
}
