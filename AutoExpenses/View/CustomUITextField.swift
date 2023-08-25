//
//  CustomUITextField.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 05/08/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


class CustomUITextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
