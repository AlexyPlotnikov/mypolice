//
//  PhotoAuto.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 13/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class AvatarAuto: Object, IRealmProtocol {
    
    
    var sizeViewToPhoto = CGSize()              // размер фрейма для обрезки
    @objc dynamic var id = LocalDataSource.identificatorUserCar
    var photoImage = UIImage()
    @objc dynamic var imageData  = Data()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func checkData() -> Bool {
        return getAllDataFromDB().count>0
    }
    
    
    func getDataFromDBCurrentID() -> [AvatarAuto] {
        let database = try! Realm()
        let results: Results<AvatarAuto> = database.objects(AvatarAuto.self)
        var tempArray: [AvatarAuto] = []
        for item in results where item.id == id {
            tempArray.append(item)
        }
        return tempArray
    }
    
    func getAllDataFromDB() -> Results<AvatarAuto> {
        let database = try! Realm()
        let results: Results<AvatarAuto> = database.objects(AvatarAuto.self)
        return results
    }
    
    func deleteFromDB(id: Int) {
        let database = try! Realm()
        try!   database.write {
            for object in getDataFromDBCurrentID() {
                database.delete(object)
            }
        }
    }
    
    func addData() {
        let database = try! Realm()
        try! database.write {
             database.add(self, update: .all)
            print("Added new object EntityCarUser")
        }
    }
    
  
    init(index: Int) {
        super.init()
        
        if checkData() {
            self.id = getAllDataFromDB()[index].id
        }
//
        for item in getDataFromDBCurrentID() {
            self.photoImage = (item.imageData.isEmpty ? UIImage() :  UIImage(data: item.imageData))!
        }
    }
    
    init(size : CGSize, photo : UIImage?) {
        super.init()
        self.sizeViewToPhoto = size
        self.photoImage = photo!
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init() {
        super.init()
    }
}


