//
//  CollectionViewCellForEnter.swift
//  Widget
//
//  Created by Иван Зубарев on 17/10/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class CollectionViewCellForEnter: UICollectionViewCell {

        
    @IBOutlet weak var number: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.number.contentMode = .scaleAspectFit
        self.backgroundColor = UIColor.white.withAlphaComponent(0.34)
        self.layer.cornerRadius = 4
    }
}
