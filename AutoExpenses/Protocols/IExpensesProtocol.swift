//
//  IExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 09/04/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import JMMaskTextField_Swift

protocol IExpenses: NSObject {
    var labelHeader : UILabel? {get set}
    var fieldInfo: IFieldInfo? {get set}
    var delegateViewExpenses : DelegateViewExpenses? {get set}
    func selectedField() -> Bool
    func createField()
    func reloadFrames(_ rect: CGRect)
    func loadData(category: BaseCategory)
}

protocol ITextField {
    var textInputField: JMMaskTextField? {get set}
    var obligatoryField: Bool{get}

}

// MARK: делегат отправляет высоту клавиатуры
protocol DelegateViewExpenses: NSObject {
    func showKeyboard(rect : CGRect)
    func hidenKeyboard()
    func setField(field: IFieldInfo)
}

