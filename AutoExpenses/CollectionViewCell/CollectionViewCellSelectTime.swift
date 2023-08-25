//
//  CollectionViewCellSelectTime.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 01.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class CollectionViewCellSelectTime: UICollectionViewCell {

    @IBOutlet private weak var labelTime: UILabel!
    private var model: ModelTimeSelected?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = false
    }
    
    func setup(time: String, type: ModelTimeSelected.SettingsTimeCell) {
        model = ModelTimeSelected()
        self.labelTime.text = time
        updateCell(type: type)
    }
    
    private func updateCell(type: ModelTimeSelected.SettingsTimeCell) {
        
        let iTimeCell = model?.getSettingType(settingType: type)
        
        self.backgroundColor = iTimeCell?.colorView
        self.labelTime.textColor = iTimeCell?.colorText
        
        switch iTimeCell {
        case is TimeCellColorAvilable:
            self.layer.borderColor = (iTimeCell as! TimeCellColorAvilable).parametrBorder.colorBorder.cgColor
            self.layer.borderWidth = (iTimeCell as! TimeCellColorAvilable).parametrBorder.heightBorder
        default:
            break
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateCell(type: isSelected ? .selectedSettings() : .notSelectedSettings())
        }
    }
    
}

