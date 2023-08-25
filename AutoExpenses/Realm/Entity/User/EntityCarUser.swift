//
//  EntityCarUser.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 01/04/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class EntityCarUser: Object {
    
    @objc dynamic var id = LocalDataSource.identificatorUserCar
    @objc dynamic var select = Bool()
    @objc dynamic var token = String()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    init(id : Int) {
        super.init()
        self.id = id
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
    

    func checkData() -> Bool {
        return getAllDataFromDB().count>0
    }
    
    func getDataFromDBCurrentID() -> [EntityCarUser] {
        let database = try! Realm()
        let results: Results<EntityCarUser> = database.objects(EntityCarUser.self)
        var tempArray: [EntityCarUser] = []
        for item in results where item.id == id {
            tempArray.append(item)
        }
        return tempArray
    }
    
    func getAllDataFromDB() -> Results<EntityCarUser> {
        let database = try? Realm()
        let results: Results<EntityCarUser> = database!.objects(EntityCarUser.self)
        return results
    }
    
    func getCurrentAuto() -> EntityCarUser {
        for item in getAllDataFromDB() where item.select {
            return item
        }
        
        let entityCar = EntityCarUser()
        entityCar.select = true
        entityCar.token = ""
        self.addData()
        AvatarAuto().addData()
        return entityCar
    }
    
    func addData() {
        let database = try! Realm()
        var tempMaxValue = 0
        for item in getAllDataFromDB() where item.id > tempMaxValue {
            tempMaxValue = item.id
        }
        id = checkData() ? tempMaxValue + 1 : 0
        select = true
        token = ""
        try! database.write {
             database.add(self, update: .all)
            print("Added new object car User")
        }
        
        self.changeState(item: self)
    }
    
    func addToken() {
        let database = try! Realm()
        try! database.write {
            database.add(self, update: .all)
            print("Added new object car Token")
        }
    }
    
     func changeState(item : EntityCarUser) {
        for object in getAllDataFromDB() {
            let entityCar = EntityCarUser(id: object.id)
            entityCar.select = object == item
            entityCar.token = object.token
            let database = try! Realm()
            try! database.write {
                 database.add(entityCar, update: .all)
            }
        }
        LocalDataSource.identificatorUserCar = item.id
    }
    
    func deleteFromDb() {
        let database = try! Realm()
        try!   database.write {
            for object in getAllDataFromDB() where object.select {
                database.delete(object)
            }
        }
        
        //        for category in LocalDataSource.arrayCategory {
        //            for _ in 0..<SelectedDate.shared.getArrayMonthName().count {
        //                (category as! BaseCategory).deleteDataBase(year_month: SelectedDate.shared.getDate())
        //            }
//    }
        
        for info in LocalDataSource.fullListInformationAuto {
            if (info as! IAddInfoProtocol).deleteDataBase != nil {
                (info as! IAddInfoProtocol).deleteDataBase!(index: LocalDataSource.identificatorUserCar)
            }
        }
        
        AvatarAuto().deleteFromDB(id: id)
        LocalDataSource.identificatorUserCar = getAllDataFromDB()[getAllDataFromDB().count-1].id
        changeState(item: getAllDataFromDB()[getAllDataFromDB().count-1])
    }
}
