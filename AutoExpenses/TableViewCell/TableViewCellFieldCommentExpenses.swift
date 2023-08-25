//
//  TableViewCellFieldCommentExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 29/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellFieldCommentExpenses: UITableViewCell {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    private weak var delegate: DelegateViewExpenses?
    var fieldInfo: IFieldInfo? {
        willSet(_field) {
            delegate?.setField(field: _field!)
        }
    }
    
    func initialization (fieldInfo: IFieldInfo, delegate: DelegateViewExpenses) {
        self.delegate = delegate
        self.fieldInfo = fieldInfo
        
        self.header.textColor = UIColor.init(rgb: 0xABABAB)
        self.textView.delegate = self
        
        textView.text = (self.fieldInfo as! Comment).comment
        textView.textContainerInset = UIEdgeInsets(top: 13, left: 18, bottom: 13, right: 18)
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.init(rgb: 0xE3E4E6).cgColor
        textView.checkerPlaceholder(textPlaceholder: "Добавьте комментарий", stayPlaceholder: true)
        
        addDoneButtonOnKeyboard()
    }
    
    
    // вынести в отдельный ксласс
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let bottom: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace,bottom]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.textView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.textView.endEditing(true)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension TableViewCellFieldCommentExpenses : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.showKeyboard(rect:  self.frame)
        self.textView.checkerPlaceholder(textPlaceholder: "Добавьте комментарий", stayPlaceholder: false)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.hidenKeyboard()
        self.textView.checkerPlaceholder(textPlaceholder: "Добавьте комментарий", stayPlaceholder: true)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.delegate?.hidenKeyboard()
        self.textView.checkerPlaceholder(textPlaceholder: "Добавьте комментарий", stayPlaceholder: true)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        (self.fieldInfo as! Comment).comment = textView.text ?? ""
    }
}

extension UITextView {
    func checkerPlaceholder(textPlaceholder: String, stayPlaceholder: Bool) {
        
        let isEmpty = self.text.isEmpty || self.text == textPlaceholder
        self.textColor = stayPlaceholder && isEmpty ? UIColor.init(rgb: 0xD2D2D6) : UIColor.init(rgb: 0x272727)
        
        if !stayPlaceholder {
            self.text = isEmpty ? "" : self.text
        } else {
            self.text = isEmpty ? textPlaceholder : self.text
        }
    }
    
//    var textWithoutPlaceholder: String {
//        get {
//            return self.textColor == UIColor.init(rgb: 0xD2D2D6) ? "" : self.text
//        }
//        
//    }
    
}
