//
//  ViewSelectedToStep.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 23.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


protocol DelegateSelectedToIndex: class {
    func setIndex(index: Int)
}

class ViewSelectedPicker: UIView {
    
    private var indexMileage: Int = 0
    private var picker: UIPickerView?
    private var arrayTypes = [String]()
    private weak var delegate: DelegateSelectedToIndex?
    
    init(frame: CGRect, array: [String], delegate: DelegateSelectedToIndex, indexMileage: Int) {
        super.init(frame: frame)
        
        self.indexMileage = indexMileage
        
        picker = UIPickerView()
        picker?.delegate = self
        picker?.dataSource = self
        self.addSubview(picker!)
        
        self.arrayTypes = array
        self.delegate = delegate

        
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        picker?.frame = bounds
        self.picker?.selectRow(indexMileage, inComponent: 0, animated: false)
        picker?.reloadAllComponents()
    }
    
}

extension ViewSelectedPicker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        if delegate != nil {
            delegate?.setIndex(index: row)
        }
    }
}

extension ViewSelectedPicker: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let v = view as? UILabel {
            label = v
        } else {
            label = UILabel()
        }
        label.textAlignment = .center
        label.font = UIFont(name: "SFProDisplay-Regular", size: 23)
        label.text = self.arrayTypes[row]
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.arrayTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
}
 
