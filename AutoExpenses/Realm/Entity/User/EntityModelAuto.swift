//
//  EntityModelAuto.swift
//  
//
//  Created by Иван Зубарев on 25/03/2019.
//

import UIKit
import RealmSwift
import Realm

class EntityModelAuto: Object {

    @objc dynamic var id = LocalDataSource.identificatorUserCar
    @objc dynamic var nameModel = String()
    @objc dynamic var image = Data()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    init(nameModel : String) {
        super.init()
        self.nameModel = nameModel
    }
    
    init(id : Int) {
        super.init()
        self.id = id
        self.nameModel = getDataFromDBCurrentID()[0].nameModel
        self.image = getDataFromDBCurrentID()[0].image
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
extension EntityModelAuto : IRealmProtocol {
   
    func checkData() -> Bool {
        return getDataFromDBCurrentID().count>0
    }
    
    func getObjectToIndex() -> Results<EntityModelAuto>? {
        let database = try! Realm()
        do {
            let results: Results<EntityModelAuto> = database.objects(EntityModelAuto.self)
            return results
        }
    }
    
    func checkPhoto(index: Int) -> Bool {
        return getObjectToIndex()?[index] != nil && !getObjectToIndex()![index].image.isEmpty
    }
    
    func getDataFromDBCurrentID() -> [EntityModelAuto] {
        let database = try! Realm()
        let results: Results<EntityModelAuto> = database.objects(EntityModelAuto.self)
        var tempArray: [EntityModelAuto] = []
        for item in results where item.id == id {
            tempArray.append(item)
        }
        return tempArray
    }
    
    func getAllDataFromDB() -> Results<EntityModelAuto> {
        let database = try! Realm()
        let results: Results<EntityModelAuto> = database.objects(EntityModelAuto.self)
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
