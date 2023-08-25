//
//  ViewAddress.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 14.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewSimpleIconAndLabel: UIView {
 
    internal var icon: UIImageView?
    internal var label: UILabel?
    
    init(frame: CGRect, imageSetting: (UIImage, UIColor?), text: String) {
        super.init(frame: frame)
        setup(text: text, imageSetting: imageSetting)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setup(text: String, imageSetting: (UIImage, UIColor?)) {
        icon = UIImageView()
        let image = imageSetting.1 != nil ? imageSetting.0.withRenderingMode(.alwaysTemplate) : imageSetting.0
        icon?.contentMode = .scaleAspectFit
        icon!.tintColor = imageSetting.1 ?? icon?.tintColor
        icon!.image = image
        self.addSubview(icon!)
        
        label = UILabel()
        label?.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        label?.textColor = UIColor.init(rgb: 0x373737)
        label?.text = text
        self.addSubview(label!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon?.frame = CGRect(x: 8,
                             y: self.frame.height * 0.5 - (self.frame.height * 0.7) * 0.5,
                             width: self.frame.height * 0.7,
                             height: self.frame.height * 0.7)
        
        
        let pointLableToX = icon!.frame.origin.x + icon!.frame.width + 8
        label?.frame = CGRect(x: pointLableToX,
                              y: 0,
                              width: self.frame.width - pointLableToX - 8,
                              height: self.frame.height)
    }
}
