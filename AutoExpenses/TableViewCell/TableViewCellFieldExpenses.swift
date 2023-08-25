//
//  TableViewCellFieldExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 26/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellFieldExpenses: UITableViewCell {
   
    @IBOutlet weak var additionalInfo: UILabel!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var field: UITextField!
    weak var delegate: (DelegateViewExpenses & DelegateReloadData)?
    
    var fieldInfo: IFieldInfo? {
        willSet(_field) {
            if delegate != nil {
                delegate!.setField(field: _field!)
            }
        }
    }
    
    private var obligatoryField: Bool = false {
        willSet (obligatory) {
            self.header.textColor = UIColor.init(rgb: 0xABABAB)
            if obligatory {
                self.header.text! += "*"
                let myAttribute = [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0xABABAB)]
                let myAttrString = NSMutableAttributedString(string: header.text ?? "", attributes: myAttribute)
                
                
                myAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: (header.text?.count ?? 0)))
                
                myAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value:  UIColor.init(rgb: 0xABABAB), range: NSRange(location: 0, length:(header.text?.count ?? 0)-1))
                
                header.attributedText = myAttrString
            }
        }
    }
    
    func initialization (fieldInfo: IFieldInfo, delegate: DelegateViewExpenses & DelegateReloadData, obligatoryField: Bool) {
        self.delegate = delegate
        self.obligatoryField = obligatoryField
        self.fieldInfo = fieldInfo
        
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height:  field.frame.height))
        indentView.backgroundColor = .white
        field.leftView = indentView
        field.placeholder = fieldInfo.placeholder
        field.leftViewMode = .always
        field.delegate = self
        field.clearButtonMode = .whileEditing
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.init(rgb: 0xE3E4E6).cgColor
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        field.removeTarget(self, action: nil, for: .allEvents)
        field.addTarget(self, action: #selector(uploadData), for: .editingChanged)
        
        loadData()
        addDoneButtonOnKeyboard()
    }
    
    // вынести в отдельный ксласс
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let bottom: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(self.doneButtonAction))
//        let up: UIBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(self.doneButtonAction))
//        bottom.image = UIImage(named: "arrow_bottom")
//        up.image = UIImage(named: "arrow_up")
        let items = [flexSpace,bottom]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.field.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.field.endEditing(true)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension TableViewCellFieldExpenses: UITextFieldDelegate {
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.hidenKeyboard()

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         delegate?.showKeyboard(rect:  self.frame)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = textField.text?.replacingOccurrences(of: ".", with: "").description
        guard let _text = str else { return false }
        let count = _text.count + string.count - range.length

        var aSet = NSCharacterSet(charactersIn:"0123456789,.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        switch self.fieldInfo {
            
        case is Sum:
            return count <= 8 && string == numberFiltered
        case is Mileage:
            aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            return count <= 8 && string == numberFiltered
        case is PricePerLiter:
            return count <= 4 && string == numberFiltered
            
        default:
            return true
        }
    }
    
   
    private func checkCommaFromText() {
        field.text = field.text?.replacingOccurrences(of: ",", with: ".")
        let moreOneComma = field.text!.numberOfOccurrences(".") > 1
        if moreOneComma {
            let newStr = field.text!.dropLast()
            field.text = newStr.description
        }
    }
    
    @objc func uploadData() {
        switch self.fieldInfo {
        case is Sum:
            checkCommaFromText()
            
            (self.fieldInfo as! Sum).sum = Float(self.field.text!) ?? Float(0.0)
             self.delegate?.updateData()
        case is Mileage:
    
            (self.fieldInfo as! Mileage).info = self.field.text ?? ""
        case is PricePerLiter:
            checkCommaFromText()
            (self.fieldInfo as! PricePerLiter).price = Float(self.field.text!) ?? Float(0.0)
             self.delegate?.updateData()
        default:
            break
        }
    }
    
    func loadData() {
        switch self.fieldInfo {
        case is Sum:
            field.keyboardType = .decimalPad
            self.field.text = (self.fieldInfo as! Sum).isEmpty() ? "" : (self.fieldInfo as? Sum)?.sum.toString()
        case is Mileage:
            field.keyboardType = .numberPad
            self.field.text = (self.fieldInfo as! Mileage).isEmpty() ? "" : (self.fieldInfo as! Mileage).info
        case is PricePerLiter:
            field.keyboardType = .decimalPad
            self.field.text = (self.fieldInfo as! PricePerLiter).isEmpty() ? "" : (self.fieldInfo as! PricePerLiter).price.toString()
        default:
            break
        }
    }
    
}
