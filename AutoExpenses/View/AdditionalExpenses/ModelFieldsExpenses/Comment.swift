//
//  Comment.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

// MARK: класс Model для добавления коментария
class Comment : IFieldInfo {
    
    var headerField: String
    var heightFields: CGFloat = 138
    var icon: UIImage?
    var comment = String()
    var placeholder: String = "Добавьте комментарий"
    var id: String
    
    init() {
        headerField = "Комментарий"
        icon = UIImage(named: "comment")
        id = "Comment"
    }    


}
