//
//  ManagerDataBaseFromRealm.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 09/10/2019.
//  Copyright © 2019 rx. All rights reserved.
//
import Foundation
import Realm
import RealmSwift

//MARK: Struct for compare elements in array
struct DataForCompareInDataBase {
    var id: Int
    var date: Date
    var sum: Float
    var comment: String
    var mileage: Int
    var photos: List<EntityPhoto>
}

//MARK: Manager working database Realm
class ManagerDataBaseFromRealm {

    enum TypeEntity: String {
        case EntityFuelCategory
        case EntityPartsCategory
        case EntityPolicyInsurent
        case EntityOtherCategory
        case EntityTuningCategory
        case EntityParkingCategory
        case EntityCarWashCategory
        case EntityTechnicalServiceCategory
    }
    
    let typeEntity: TypeEntity
    
    init(typeEntity: TypeEntity) {
        self.typeEntity = typeEntity
    }
    
    init() {
        self.typeEntity = .EntityOtherCategory
    }
    
    func dataForCompareInDataBase(item: Object) -> DataForCompareInDataBase {
        switch self.typeEntity {
        case .EntityFuelCategory:
            let entity = (item as! EntityFuelCategory)
            return DataForCompareInDataBase(id: entity.id, date: entity.date, sum: entity.sum, comment: entity.comment, mileage: entity.mileage, photos: entity.photos)
        case .EntityPartsCategory:
            let entity = (item as! EntityPartsCategory)
            return DataForCompareInDataBase(id: entity.id, date: entity.date, sum: entity.sum, comment: entity.comment, mileage: entity.mileage, photos: entity.photos)
        case .EntityPolicyInsurent:
            let entity = (item as! EntityPolicyInsurent)
            return DataForCompareInDataBase(id: entity.id, date: entity.date, sum: entity.sum, comment: entity.comment, mileage: entity.mileage, photos: entity.photos)
        case .EntityOtherCategory:
            let entity = (item as! EntityOtherCategory)
            return DataForCompareInDataBase(id: entity.id, date: entity.date, sum: entity.sum, comment: entity.comment, mileage: entity.mileage, photos: entity.photos)
        case .EntityTuningCategory:
            let entity = (item as! EntityTuningCategory)
            return DataForCompareInDataBase(id: entity.id, date: entity.date, sum: entity.sum, comment: entity.comment, mileage: entity.mileage, photos: entity.photos)
        case .EntityParkingCategory:
            let entity = (item as! EntityParkingCategory)
            return DataForCompareInDataBase(id: entity.id, date: entity.date, sum: entity.sum, comment: entity.comment, mileage: entity.mileage, photos: entity.photos)
        case .EntityCarWashCategory:
            let entity = (item as! EntityCarWashCategory)
            return DataForCompareInDataBase(id: entity.id, date: entity.date, sum: entity.sum, comment: entity.comment, mileage: entity.mileage, photos: entity.photos)
        case .EntityTechnicalServiceCategory:
            let entity = (item as! EntityTechnicalServiceCategory)
            return DataForCompareInDataBase(id: entity.id, date: entity.date, sum: entity.sum, comment: entity.comment, mileage: entity.mileage, photos: entity.photos)
        }
    }
    
    private func checkToPeriod(itemDate: Date, structDate: StructDateForSelect?) -> Bool {
        
        if structDate == nil {
            return true
        }
        
        let checkDateToPeriod = structDate!.month == 0 ?
            (Calendar.current.component(.year, from: itemDate) == structDate!.year) :
            (Calendar.current.component(.month, from: itemDate) == structDate!.month && Calendar.current.component(.year, from: itemDate) == structDate!.year)
     
        return checkDateToPeriod
    }
    
    
    func checkData() -> Bool {
        return getAllDataFromDB().count > 0
    }
    
    func getDataFromDBCurrentID(year_month: StructDateForSelect?) -> [Object] {
           let database = try! Realm()
           let results: Results<DynamicObject> = database.dynamicObjects(typeEntity.rawValue)
           var tempArray: [Object] = []
        
            for item in results where dataForCompareInDataBase(item: item).id == LocalDataSource.identificatorUserCar &&
                checkToPeriod(itemDate: dataForCompareInDataBase(item: item).date, structDate: year_month) {
                   tempArray.append(item)
           }
           return tempArray.sorted(by: { dataForCompareInDataBase(item: $0).date > dataForCompareInDataBase(item: $1).date })
       }
    
    

    
    func getDataFromDBCurrentID() -> [Object] {
        let database = try! Realm()
        let results: Results<DynamicObject> = database.dynamicObjects(typeEntity.rawValue)
        
        var tempArray: [Object] = []
        for item in results where dataForCompareInDataBase(item: item).id == LocalDataSource.identificatorUserCar {
            tempArray.insert(item, at: 0)
        }
        return tempArray
    }
    
 
    func addData(obj: Object) {
        let database = try! Realm()
        try! database.write {
            database.add(obj)
            print("Added new object " + typeEntity.rawValue)
        }
    }

    func deleteFromDb(obj: Object) {
        let database = try! Realm()
        try! database.write {
            database.delete(obj)
        }
    }
    
    func getAllDataFromDB() -> [Object] {
        let database = try! Realm()
            let results: Results<DynamicObject> = database.dynamicObjects(typeEntity.rawValue)
               
            var tempArray: [Object] = []
            for item in results {
                tempArray.insert(item, at: 0)
            }
        return tempArray
    }
    
}
