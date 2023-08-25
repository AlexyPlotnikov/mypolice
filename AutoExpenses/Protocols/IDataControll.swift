//
//  IDataControll.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 19/06/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol IDataControll {
    func checkData() -> Bool
    func getArrayDataBase() -> [Object]
    func addDataBase()
}
