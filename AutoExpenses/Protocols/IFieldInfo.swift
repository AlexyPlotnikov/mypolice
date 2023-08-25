//
//  IFieldInfo.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

@objc protocol IFieldInfo {
    
    var headerField : String {get set}
    var icon : UIImage? {get set}
    var heightFields: CGFloat{get}
    @objc optional var id : String {get set}
    @objc optional var placeholder: String {get}
    @objc optional func isEmpty() -> Bool
}
