//
//  TableViewCellFieldDateExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 29/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellFieldDateExpenses: TableViewCellFieldExpenses {
    
    var datePicker: UIDatePicker?
    private var toolBar: UIToolbar?
//    var oldDateForFind: Date?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

   
    override func initialization(fieldInfo: IFieldInfo, delegate: DelegateReloadData & DelegateViewExpenses, obligatoryField: Bool) {
        
        self.fieldInfo = fieldInfo
        self.delegate = delegate
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height:  field.frame.height))
        indentView.backgroundColor = .white
        
        field.leftView = indentView
        field.leftViewMode = .always
        field.delegate = self
        field.tintColor = .clear
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.init(rgb: 0xE3E4E6).cgColor
        field.autocorrectionType = .no
        
        if (self.fieldInfo as! DataExpenses).dateOld == nil {
           (self.fieldInfo as! DataExpenses).dateOld = (self.fieldInfo as! DataExpenses).date
        }
        
        datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                y: (delegate as! UIViewController).view.bounds.midY,
                                                width: (delegate as! UIViewController).view.frame.width,
                                                height: (delegate as! UIViewController).view.frame.height * 0.35))
        datePicker?.backgroundColor = .white
        datePicker?.datePickerMode = .date
        datePicker?.date = (self.fieldInfo as! DataExpenses).date ?? Date()
        
        toolBar = UIToolbar()
        toolBar!.sizeToFit()
        toolBar!.backgroundColor = .white
        let doneButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: #selector(done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Отмена", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancel))
        toolBar!.setItems([cancelButton, spaceButton, doneButton], animated: true)
        
        
        self.field.inputView = datePicker
        self.field.text = ((self.fieldInfo as! DataExpenses).date ?? Date()).toString()
        self.field.inputAccessoryView = self.toolBar
    }
    

    @objc func cancel() {
        self.field?.endEditing(true)
    }
    
    @objc func done() {
        self.field.text = self.datePicker?.date.toString()
        (self.fieldInfo as! DataExpenses).date = self.datePicker!.date
        self.field?.endEditing(true)
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        
        delegate?.showKeyboard(rect:  self.frame)
        self.datePicker?.date = (self.fieldInfo as! DataExpenses).date ?? Date()
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        
        self.delegate?.hidenKeyboard()
    }

}

