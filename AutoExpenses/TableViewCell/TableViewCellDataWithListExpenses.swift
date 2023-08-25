//
//  TableViewCellDataWithListExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 07/10/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellDataWithListExpenses: UITableViewCell {

    @IBOutlet weak var labelPeriod: UILabel!
    @IBOutlet weak var labelCost: UILabel!
    
    
    func initialization(color: UIColor, type: ViewScheduleLinear.TypeVisual, cost: String, structDate: StructDateForSelect) {
            self.backgroundColor = color
            self.labelCost.text = cost
            self.labelCost.setNewChar(newAttr: NewAttrChar(color: UIColor.white.withAlphaComponent(0.6), font: UIFont(name: self.labelCost.font.fontName, size: 16)!, char: " ₽"), standartColor: UIColor.white)
            let labelText = structDate.month == 0 ? "За \(structDate.year) год" : "\(structDate.arrayMonth[structDate.month]), \(structDate.year)"
            self.labelPeriod.text = labelText
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
