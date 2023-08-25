//
//  TableViewCellFieldPhotoExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 29/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellFieldPhotoExpenses: UITableViewCell, DelegateReloadData {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    private weak var delegate: DelegateViewExpenses?
    private var photoExpenses: PhotoExpenses?
    
    weak var fieldInfo: IFieldInfo? {
        willSet(_field) {
            self.delegate?.setField(field: _field!)
        }
    }
    
    func initialization (fieldInfo: IFieldInfo?, delegate: DelegateViewExpenses) {
       
        self.fieldInfo = fieldInfo
        
        if self.photoExpenses == nil {
            self.photoExpenses = PhotoExpenses(scroll: self.scroll, vc: delegate as! UIViewController)
            
            for ph in (self.fieldInfo as! Photo).arrayPhotos! {
                self.photoExpenses?.addNewCell(image: ph)
            }
        } else {
            self.photoExpenses?.delegate?.updateData()
        }
    
        self.photoExpenses?.delegate = self
       
        self.header.textColor = UIColor.init(rgb: 0xABABAB)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickView)))
    }
    
    func updateData() {
        
        (self.fieldInfo as! Photo).arrayPhotos?.removeAll()
        
        for photo in self.photoExpenses!.imagesView {
            (self.fieldInfo as! Photo).arrayPhotos?.append(photo.image!)
        }
        
        if delegate != nil {
            delegate!.setField(field: self.fieldInfo!)
        }
    }
    
    
    func deleteAll() {
        for item in self.photoExpenses!.imagesView {
            item.photoView?.removeFromSuperview()
        }
        
        self.photoExpenses!.imagesView.removeAll()
        self.photoExpenses!.reloadFrame()
        
        self.photoExpenses = nil
        self.delegate = nil
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.photoExpenses?.reloadFrame()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @objc private func clickView() {
        self.delegate?.hidenKeyboard()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
//extension TableViewCellFieldPhotoExpenses: UITextFieldDelegate {
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        delegate?.showKeyboard(rect:  self.bounds)
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        delegate?.hidenKeyboard()
//    }
//    
//}
