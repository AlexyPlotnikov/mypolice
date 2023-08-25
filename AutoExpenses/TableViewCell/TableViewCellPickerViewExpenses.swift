//
//  TableViewCellPickerView.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 05/08/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellPickerViewExpenses: TableViewCellFieldExpenses {
    
    private var  viewPicker: UIPickerView?
    private var toolBar: UIToolbar?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func initialization(fieldInfo: IFieldInfo, delegate: DelegateReloadData & DelegateViewExpenses, obligatoryField: Bool) {
        
        self.fieldInfo = fieldInfo
        self.delegate = delegate
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height:  field.frame.height))
        indentView.backgroundColor = .white
        field.leftView = indentView
        field.leftViewMode = .always
        field.delegate = self
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.init(rgb: 0xE3E4E6).cgColor
        field.autocorrectionType = .no

        viewPicker = UIPickerView(frame: CGRect(x: 0,
                                                y: (delegate as! UIViewController).view.bounds.midY,
                                                width: (delegate as! UIViewController).view.frame.width,
                                                height: (delegate as! UIViewController).view.frame.height * 0.35))
        viewPicker?.backgroundColor = .white
        toolBar = UIToolbar()
        toolBar!.sizeToFit()
        toolBar!.backgroundColor = .white
        let doneButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: #selector(done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar!.setItems([spaceButton, spaceButton, doneButton], animated: true)
        
        
        self.field.inputView = viewPicker
        self.viewPicker?.delegate = self
        self.field.text = (self.fieldInfo as! TechnicalServiceExpenses).type
        self.field.inputAccessoryView = self.toolBar
        let index = (self.fieldInfo as! TechnicalServiceExpenses).typesTechnicalWorking.firstIndex(of: (self.fieldInfo as! TechnicalServiceExpenses).type)
        self.viewPicker?.selectRow(index ?? 0, inComponent: 0, animated: true)
    }
    
}

extension TableViewCellPickerViewExpenses: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return (self.fieldInfo as! TechnicalServiceExpenses).typesTechnicalWorking[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.fieldInfo as! TechnicalServiceExpenses).typesTechnicalWorking.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        (self.fieldInfo as! TechnicalServiceExpenses).type = (self.fieldInfo as! TechnicalServiceExpenses).typesTechnicalWorking[row]
        self.field!.text = (self.fieldInfo as! TechnicalServiceExpenses).typesTechnicalWorking[row]
        
    }
    
    @objc func done()
    {
        self.field!.endEditing(true)
    }
    
    @objc func cancel()
    {
        self.field!.endEditing(true)
    }
    
    
    // делегат открытия клавиатуры
    override func textFieldDidBeginEditing(_ textField: UITextField) {
       delegate?.showKeyboard(rect:  self.frame)
    }
    
    // делегат закрытия клавиатуры
    override func textFieldDidEndEditing(_ textField: UITextField) {
        (self.fieldInfo as! TechnicalServiceExpenses).type = self.field!.text!
        delegate?.hidenKeyboard()
    }
    
    // делегат тап enter на клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.hidenKeyboard()
        return true
    }
}


