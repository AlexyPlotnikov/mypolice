//
//  EntityPassportAuto.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 25/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class EntityPassportAuto: Object {
    
    @objc dynamic var id = LocalDataSource.identificatorUserCar
    @objc dynamic var number = String()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    init(number : String) {
        super.init()
        self.number = number
    }
    
    init(id : Int) {
        super.init()
        self.id = id
        self.number = getDataFromDBCurrentID()[0].number
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
extension EntityPassportAuto : IRealmProtocol {
    
    func checkData() -> Bool {
        return getDataFromDBCurrentID().count>0
    }
    
    func getDataFromDBCurrentID() -> [EntityPassportAuto] {
        let database = try! Realm()
        let results: Results<EntityPassportAuto> = database.objects(EntityPassportAuto.self)
        var tempArray: [EntityPassportAuto] = []
        for item in results where item.id == id {
            tempArray.append(item)
        }
        return tempArray
    }
    
    func getAllDataFromDB() -> Results<EntityPassportAuto> {
        let database = try! Realm()
        let results: Results<EntityPassportAuto> = database.objects(EntityPassportAuto.self)
        return results
    }
    
    func addData()   {
        let database = try! Realm()
        
        try! database.write {
            database.add(self, update: .all)
            print("Added new object EntityPassportAuto")
        }
    }
    
    func deleteFromDb(object: Object)   {
        let database = try! Realm()
        try!   database.write {
            database.delete(object)
        }
        
    }
}

