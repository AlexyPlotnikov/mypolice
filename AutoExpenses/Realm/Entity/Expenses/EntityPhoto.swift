//
//  EntityPhoto.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 16/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class EntityPhoto: Object {
    @objc dynamic var photo: Data = Data()
}
