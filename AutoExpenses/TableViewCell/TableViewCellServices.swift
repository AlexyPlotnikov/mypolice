//
//  TableViewCellServices.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 22.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellServices: UITableViewCell {

    @IBOutlet weak var iconServices: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 13
        self.layer.borderColor = UIColor.init(rgb: 0xCFCFCF).cgColor
        self.layer.borderWidth = 1
    }

  
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
