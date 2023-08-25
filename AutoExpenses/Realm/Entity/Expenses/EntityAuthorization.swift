//
//  EntityAuthorization.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 28/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

import UIKit
import RealmSwift
import Realm

class EntityAuthorization: Object {

    @objc dynamic var numberPhone = String()
    @objc dynamic var code = String()
    
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
        return  EntityAuthorization().getAllDataFromDB().count>0 &&  !EntityAuthorization().getAllDataFromDB()[0].numberPhone.isEmpty && !EntityAuthorization().getAllDataFromDB()[0].code.isEmpty
    }
    
    func getAllDataFromDB() -> Results<EntityAuthorization> {
        let database = try! Realm()
        let results: Results<EntityAuthorization> = database.objects(EntityAuthorization.self)
        return results
    }
    
    
    
    func addData() {
        
        for item in getAllDataFromDB() {
            item.deleteFromDb()
        }
        
        let database = try! Realm()
        try! database.write {
        
            database.add(self)
            print("Added new object EntityFuelCategory")
        }
    }
    
    func deleteFromDb() {
        let database = try! Realm()
        try!   database.write {
            database.delete(self)
        }
    }
    
}
