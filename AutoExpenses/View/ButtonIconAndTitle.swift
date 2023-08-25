//
//  ButtonScanQR.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 05/08/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ButtonIconAndTitle: UIButton {

    
    private var imageViewIcon: UIImageView?
    private var title: UILabel?
    private var category: BaseCategory!
    private var manager: ManagerCategory!
    
    init(frame: (CGRect?) = nil, category: BaseCategory) {
        super.init(frame: frame ?? CGRect.zero)
    
        self.category = category
        self.manager = ManagerCategory(category: category)
        
        self.backgroundColor = .clear

        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.imageViewIcon = UIImageView()
        self.imageViewIcon!.image = category.iconCategoryActivate
        self.imageViewIcon?.isUserInteractionEnabled = false
        self.addSubview(self.imageViewIcon!)
        
        self.title = UILabel()
        self.title?.text = category.headerField
        self.title?.textColor = category.colorHead
        self.title?.isUserInteractionEnabled = false
        self.title?.textAlignment = .center
        self.title?.font = UIFont(name: "SFUIDisplay-Medium", size: 11 )
    
        self.addSubview(self.title!)
    }
    
    func setStateBtn(select: Bool) {
        self.title?.textColor = select ? UIColor.init(rgb: 0x3B3B3B) : UIColor.init(rgb: 0xBCBCC0)
        self.imageViewIcon?.image = select ? category.iconCategoryActivate : category.iconCategoryNotActivate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.imageViewIcon != nil {
            let widthIcon = rect.width * 0.7
            self.imageViewIcon?.frame = CGRect(x: rect.midX - widthIcon * 0.5,
                                               y: 5,
                                               width: widthIcon,
                                               height: widthIcon)
        }
        
        if self.title != nil {
            let widthTitle = self.frame.width * 0.9
            self.title?.frame = CGRect(x: rect.midX - widthTitle * 0.5,
                                       y: self.imageViewIcon!.frame.origin.y + self.imageViewIcon!.frame.height,
                                       width: widthTitle,
                                       height: self.frame.height - (self.imageViewIcon!.frame.origin.y + self.imageViewIcon!.frame.height))
        }
    }
}
