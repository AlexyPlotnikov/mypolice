//
//  ViewWearSmallEmpty.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 11.12.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewWearSmallEmpty: ViewWearSmall {

    private var plusIcon: UIImageView?
    
    override init(delegate: (DelegateOpenAdditionalScreen?) = nil, model: (ModelTimeAndMileageWear?) = nil) {
        super.init(delegate: delegate, model: nil)
        
        plusIcon = UIImageView(image: UIImage(named: "add button"))
        plusIcon?.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.headerLabel.frame.size.width = self.frame.width - self.headerLabel.frame.height
        
        plusIcon?.frame = CGRect(x: self.frame.width - 38, y: 0, width: self.headerLabel.frame.height, height: self.headerLabel.frame.height)
    }
    
    override func functionOpenAlert() {
        print("Open Alert for handing aditional")
//        self.delegate?.openAlert(PanelDropForWrite)
    }
}
