//
//  BaseInfoUser.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

 @objc protocol IAddInfoProtocol : IFieldInfo {
    
     var info: String {get set}
     @objc optional func updateInfo()
     @objc optional func addInfo(comletion: @escaping (String) -> Void)
     @objc optional func deleteDataBase(index: Int)
}


