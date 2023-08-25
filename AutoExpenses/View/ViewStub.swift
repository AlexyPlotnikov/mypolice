//
//  ViewStub.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 02.12.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewStub: UIView {
    
    private weak var icon: UIImageView?
    private weak var label: UILabel?
    
    
    init(frame: CGRect, image: UIImage, text: String) {
        super.init(frame: .zero)
        
        let _icon = UIImageView(image: image)
        _icon.contentMode = .scaleAspectFit
        icon = _icon
        self.addSubview(icon!)
        
        let _label = UILabel()
        _label.text = text
        _label.textColor = UIColor.init(rgb: 0x63697C)
        _label.textAlignment = .center
        _label.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        _label.numberOfLines = 4
        label = _label
        self.addSubview(label!)
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width: CGFloat = 52
        self.icon?.frame = CGRect(x: self.frame.midX - width * 0.5, y:  43, width: width, height: width)
        self.label?.frame = CGRect(x: 50, y: self.icon!.frame.maxY + 8, width: self.frame.width - 50 * 2, height: self.frame.height - (self.icon!.frame.maxY + 8))
    }
}
