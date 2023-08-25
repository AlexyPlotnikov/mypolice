//
//  ViewInfoOsago.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 15/05/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewInfoOsago: UIView {

    var headerLabel: UILabel?
    var infoLabel: UILabel?

    
    init() {
        super.init(frame: CGRect.zero)
        initialization()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
//
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    func initialization() {
        self.backgroundColor = .clear
        
        headerLabel = UILabel()
        headerLabel?.font = UIFont(name: headerLabel!.font.fontName, size: 10)
        headerLabel?.textColor = .lightGray
        headerLabel?.font = UIFont(name: "SFUIDispaly-Regular", size: 15)
        headerLabel?.textColor = UIColor.init(rgb: 0xABABAB)
        
        infoLabel = UILabel()
        infoLabel?.backgroundColor = .white
        infoLabel?.text = ""
        infoLabel?.font = UIFont(name: "SFUIDispaly-Regular", size: 17)
        infoLabel?.textColor = UIColor.init(rgb: 0x343434)
        infoLabel?.layer.cornerRadius = 8
        infoLabel?.layer.masksToBounds = true
        infoLabel?.layer.borderWidth = 1
        infoLabel?.layer.borderColor = UIColor.init(rgb:0xE3E4E6).cgColor
        
        self.addSubview(headerLabel!)
        self.addSubview(infoLabel!)
       
    }
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
//        let heightIndicator = rect.height * 0.4
    
        self.headerLabel?.frame = CGRect(x: 16,
                                    y: 0,
                                    width: rect.width * 0.5 + 4,
                                    height: rect.height - 45)

        self.infoLabel?.frame = CGRect(x: 16,
                                         y: self.headerLabel!.frame.height,
                                         width: rect.width - 16 * 2,
                                         height: rect.height - self.headerLabel!.frame.height)
        
//        self.loadingIndicator?.frame = CGRect(x: rect.midX - heightIndicator * 0.5,
//                                              y: rect.midY - heightIndicator * 0.5,
//                                              width: heightIndicator,
//                                              height: heightIndicator)
    }
    
}

