//
//  ViewTableViewCellHeader.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewTableViewCellHeader: UITableViewCell {
    
    @IBOutlet weak private var viewBack: UIView!
    @IBOutlet weak private var labelText: UILabel!
    @IBOutlet weak private var indicatorPoint: UIView!
    
    func setup(text: String, colorPoint: UIColor) {
        labelText.text = text
        indicatorPoint.backgroundColor = colorPoint
        viewBack.backgroundColor = colorPoint.withAlphaComponent(0.06)
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
        indicatorPoint.layer.cornerRadius = indicatorPoint.bounds.width / 2
    }
    
}
