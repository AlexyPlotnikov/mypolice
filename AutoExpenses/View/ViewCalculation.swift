//
//  ViewCalculation.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 12/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewCalculation: UIView {
    
    var labelHeader: UILabel?
    var labelInfo: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
        
    }
        
    func initialization() {

        self.labelInfo = UILabel()
        self.labelInfo?.textColor = UIColor.init(rgb: 0x343434)
        self.labelInfo?.textAlignment = .center
        self.labelInfo?.font = UIFont(name: "SFUIDisplay-Bold", size: 17)
        
        self.labelHeader = UILabel()
        self.labelHeader?.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
        self.labelHeader?.textColor = UIColor.init(rgb: 0xABABAB)
        self.labelHeader?.textAlignment = .center
        self.addSubview(self.labelInfo!)
        self.addSubview(self.labelHeader!)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let heightLabel = rect.height * 0.25
        self.labelInfo?.frame = CGRect(x: 0,
                                       y: heightLabel,
                                       width: rect.width,
                                       height: heightLabel)
        
        self.labelHeader?.frame = CGRect(x: 0,
                                         y: heightLabel * 2,
                                         width: rect.width,
                                         height: heightLabel)
    }
}
