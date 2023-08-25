//
//  TableViewCellInfoWorkingRepair.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 25.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellInfoWorkingRepair: UITableViewCell {

    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var labelDescription: UILabel!
    @IBOutlet private weak var view: UIView!
    
    func setup(repair: RepairWorking? ) {
        labelName.text = repair?.nameWorking ?? ""
        labelDescription.text = repair?.itemDescription ?? ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.layer.cornerRadius = view.frame.height * 0.5
    }
    
}
