//
//  EntityFuelCategory.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 26/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class EntityFuelCategory: Object {
    
    @objc dynamic var date = Date()
    @objc dynamic var priceToLiter = Float()
    @objc dynamic var comment = String()
    @objc dynamic var mileage = Int()
    @objc dynamic var sum = Float()
    @objc dynamic var id = LocalDataSource.identificatorUserCar
    var photos = List<EntityPhoto>()
    
    
    init(date: Date, priceToLiter: Float, comment: String, mileage: Int, sum: Float, photos: [Data]) {
        super.init()
        self.date = date
        self.priceToLiter = priceToLiter
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
}
