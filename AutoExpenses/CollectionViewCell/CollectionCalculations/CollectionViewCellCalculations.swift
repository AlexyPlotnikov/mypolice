//
//  CollectionViewCellCalculations.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 19/09/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class CollectionViewCellCalculations: UICollectionViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    
    func initialization(calculation: CalculationStruct, attrForLabelName: NewAttrChar) {
        let valueCalculationToFormat = !calculation.value.roundTo(places: 1).isZero ? String(format: "%.02f", calculation.value) : "-"
        
        labelName.text = calculation.typeCalculation.rawValue
        labelValue.text = valueCalculationToFormat
        
        if !calculation.value.roundTo(places: 1).isZero {
            labelValue.setNewChar(newAttr: attrForLabelName, standartColor: labelValue.textColor)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         self.backgroundColor = .clear
        // Initialization code
    }

    
}
