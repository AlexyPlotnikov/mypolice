//
//  TableViewCellSchedule.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 02/10/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellSchedule: UITableViewCell {

    @IBOutlet private weak var viewSchedule: ViewScheduleLinear!
    
 
    func initialization(array: [DataForSchedule], color: UIColor, type: ViewScheduleLinear.TypeVisual) {
        self.backgroundColor = color
        viewSchedule.setup(dataForScheludeArray: array, color: color, type: type)
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
