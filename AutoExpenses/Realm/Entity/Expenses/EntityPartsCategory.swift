//
//  EntityPartsCategory.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 05/04/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class EntityPartsCategory: Object {
    
    @objc dynamic var date = Date()
    @objc dynamic var comment = String()
    @objc dynamic var mileage = Int()
    @objc dynamic var sum = Float()
    var photos = List<EntityPhoto>()
    @objc dynamic var id = LocalDataSource.identificatorUserCar
    
    init(date: Date, comment: String, mileage: Int, sum: Float, photos: [Data]) {
        super.init()
        
        self.date = date
        self.comment = comment
        self.mileage = mileage
        self.sum = sum
        
        for photo in photos {
            let entityPhoto = EntityPhoto()
            entityPhoto.photo = photo
            self.photos.append(entityPhoto)
        }
        
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

    func addData() {
        let database = try! Realm()
        try! database.write {
            database.add(self, update: .all)
            print("Added new object EntityModelAuto")
        }
    }
}
