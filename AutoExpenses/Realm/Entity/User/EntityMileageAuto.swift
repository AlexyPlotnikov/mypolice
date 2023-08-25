//
//  EntityMileageAuto.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 26/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class EntityMileageAuto: Object {
    
    @objc dynamic var id = LocalDataSource.identificatorUserCar
    @objc dynamic var mileage: Int = 0
    
    init(mileage : Int) {
        super.init()
        self.mileage = mileage
        
    }
    
    init(id : Int) {
        super.init()
        let array = getDataFromDBCurrentID()//.sorted(by: { $0.mileage > $1.mileage })
        self.mileage = array.count>0 ? array[array.count-1].mileage : 0
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
}

// MARK: работа с базой данных
extension EntityMileageAuto : IRealmProtocol {
    
    func checkData() -> Bool {
        return getDataFromDBCurrentID().count>0
    }
    
    func getDataFromDBCurrentID() -> [EntityMileageAuto] {
        let database = try! Realm()
        let results: Results<EntityMileageAuto> = database.objects(EntityMileageAuto.self)
        var tempArray: [EntityMileageAuto] = []
        for item in results where item.id == id {
            tempArray.append(item)
        }

        return tempArray
    }
    
    func getAllDataFromDB() -> Results<EntityMileageAuto> {
        let database = try! Realm()
        let results: Results<EntityMileageAuto> = database.objects(EntityMileageAuto.self)
        return results
    }
    
    
    func addData() {
        let database = try! Realm()
        try! database.write {
            database.add(self)
            print("Added new object EntityMileageAuto")
        }
        
//        for item in getDataFromDBCurrentID() {
//            for itemCheck in getDataFromDBCurrentID() where item.mileage==itemCheck.mileage{
//                itemCheck.deleteFromDb(object: itemCheck)
//            }
//        }
    }
    
    func deleteFromDb() {
        let database = try! Realm()
        try!   database.write {
            database.delete(self)
        }
        
    }
}

