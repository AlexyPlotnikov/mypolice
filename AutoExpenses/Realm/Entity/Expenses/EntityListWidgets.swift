//
//  EntityListWidgets.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 06/06/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class EntityListWidgets: Object {

    @objc dynamic var id = "0"
    @objc dynamic var widgetKey = String()
    @objc dynamic var keyID = String()

    
    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    
    func getAllDataFromDB() -> [EntityListWidgets]? {
        let database = try! Realm()
        let results: Results<EntityListWidgets> = database.objects(EntityListWidgets.self)
        var tempArray: [EntityListWidgets] = []
        for item in results where item.keyID == keyID {
            tempArray.append(item)
        }
        return tempArray
    }
    
    func addData() {
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
