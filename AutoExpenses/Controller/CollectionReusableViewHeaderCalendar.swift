//
//  CollectionReusableViewHeaderCalendar.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 30.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class CollectionReusableViewHeaderCalendar: UICollectionReusableView {

    var array: [UILabel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(arrayWeekdays: [String]?) {
        
        if self.array != nil {
            return
        }
        
        self.array = [UILabel]()
        
        for weekDay in arrayWeekdays! {
            let label = UILabel()
            label.text = weekDay
            label.textAlignment = .center
            label.textColor = .white
            self.array?.append(label)
            self.addSubview(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.frame.width / 7
        for label in array! {
            let index = array?.firstIndex(of: label) ?? 0
            label.frame = CGRect(x: index.toCGFloat() * width, y: 0, width: width, height: self.frame.height)
        }
    }
    
}
