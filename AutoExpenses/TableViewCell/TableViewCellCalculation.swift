//
//  TableViewCellCalculation.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 02/10/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellCalculation: UITableViewCell {

    @IBOutlet private weak var viewCalculation: ViewSecondaryParamentrCaregory!
    
    func initialization(calculateCategory: CalculationForCategory, color: UIColor) {
        viewCalculation.calculationCategoryData = calculateCategory
        self.backgroundColor = color
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
