//
//  EntityHealthCar.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 11.12.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class EntityHealthCar: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var name = String()
    @objc dynamic var dateEndWear = Date()
//    @objc dynamic var dateStartWear = Date()
    @objc dynamic var mileageEndWear = Int()
    
    override class func primaryKey() -> String? {
           return "id"
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
    
    func getAllDataFromDB() -> Results<EntityHealthCar> {
        let database = try! Realm()
        let results: Results<EntityHealthCar> = database.objects(EntityHealthCar.self)
        return results
    }
    
    func addData() {
        let database = try! Realm()
        try! database.write {
            database.add(self, update: .all)
            print("Added new object EntityModelAuto")
        }
    }
    
    func deleteFromDb() {
        let database = try! Realm()
        try!   database.write {
            database.delete(self)
        }
        
    }
    
}
