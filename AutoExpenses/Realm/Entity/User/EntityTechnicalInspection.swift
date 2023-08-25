//
//  EntityTechnicalInspection.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 25/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class EntityTechnicalInspection: Object {
    
    @objc dynamic var id = LocalDataSource.identificatorUserCar
    @objc dynamic var dateEnd = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    init(dateEnd : Date) {
        super.init()
        self.dateEnd = dateEnd
    }
    
    init(id : Int) {
        super.init()
        
        self.id = id
        self.dateEnd = getDataFromDBCurrentID()[0].dateEnd
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
extension EntityTechnicalInspection : IRealmProtocol {
    
    func checkData() -> Bool {
        return getDataFromDBCurrentID().count>0
    }
    
    func getDataFromDBCurrentID() -> [EntityTechnicalInspection] {
        let database = try! Realm()
        let results: Results<EntityTechnicalInspection> = database.objects(EntityTechnicalInspection.self)
        var tempArray: [EntityTechnicalInspection] = []
        for item in results where item.id == id {
            tempArray.append(item)
        }
        return tempArray
    }
    
    func getAllDataFromDB() -> Results<EntityTechnicalInspection> {
        let database = try! Realm()
        let results: Results<EntityTechnicalInspection> = database.objects(EntityTechnicalInspection.self)
        return results
    }
    
    func addData()   {
        let database = try! Realm()
        try! database.write {
             database.add(self, update: .all)
            print("Added new object EntityTechnicalInspection")
        }
    }
    
    func deleteFromDb(object: Object)   {
        let database = try! Realm()
        try!   database.write {
            database.delete(object)
        }
        
    }
}
