//
//  StructWearEmpty.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20.01.2020.
//  Copyright © 2020 rx. All rights reserved.
//

import UIKit

class ModelWearEmpty: ModelWear {
    
    init(unit: String) {
        super.init(totalPoint: 0, currentPoint: 0, unit: unit)
    }
    
}
