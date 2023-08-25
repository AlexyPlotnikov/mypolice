//
//  ICoreData.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 22/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

protocol IRealmProtocol {
    func addData()
    func checkData() -> Bool
}

