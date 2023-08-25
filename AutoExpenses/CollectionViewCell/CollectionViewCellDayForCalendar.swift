//
//  CollectionViewCellDayForCalendar.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 29.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class CollectionViewCellDayForCalendar: UICollectionViewCell {

    @IBOutlet private weak var label: UILabel!
    
    func setup (text: String?) {
        self.label.text = text ?? ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
