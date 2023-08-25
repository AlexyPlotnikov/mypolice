//
//  EntityAdditionally.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 27/08/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift

class EntityAdditionally: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var first = true
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func getAllDataFromDB() -> Results<EntityAdditionally> {
        let database = try! Realm()
        let results: Results<EntityAdditionally> = database.objects(EntityAdditionally.self)
        return results
    }
    
    func addData() {
        let database = try! Realm()
        try! database.write {
            database.add(self, update: .all)
            print("Added new object EntityModelAuto")
        }
    }
    
    func deleteFromDb(object: Object) {
        let database = try! Realm()
        try!   database.write {
            database.delete(object)
        }
        
    }
}
