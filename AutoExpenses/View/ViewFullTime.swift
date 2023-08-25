//
//  ViewFullTime.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 24/09/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewFullTime: UIView {

    
    private var switherActivate: UISwitch?
    private var label: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup () {
        switherActivate = UISwitch()
        switherActivate?.isOn = false
        switherActivate?.onTintColor = UIColor.init(rgb: 0x447AFF)
        self.addSubview(switherActivate!)
        
        label = UILabel()
        label?.text = "За все время"
        self.addSubview(label!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.label?.frame = CGRect(x: 37,
                                   y: 0,
                                   width: self.frame.width * 0.5,
                                   height: self.frame.height)
        self.switherActivate?.frame.origin.x = self.bounds.width - (self.bounds.width * 0.2) - 37
        self.switherActivate?.center.y = self.frame.height * 0.5
    }
}
