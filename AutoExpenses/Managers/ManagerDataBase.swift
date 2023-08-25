//
//  ManagerDataBase.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 11.12.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class ManagerDataBase: IDataControll {
    
    private var entity: Object?

    
    init(entity: Object) {
        self.entity = entity
    }
    
    func checkData() -> Bool {
        return entity != nil && getArrayDataBase().count > 0
    }
    
    func getArrayDataBase() -> [Object] {
        let database = try! Realm()
        let results: Results<Object> = database.objects(Object.self)
        var tempArray: [Object] = []
        for item in results {
            tempArray.append(item)
        }
        return tempArray
    }
       
    func addDataBase() {
        let database = try! Realm()
        try! database.write {
        database.add(self.entity!)
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
