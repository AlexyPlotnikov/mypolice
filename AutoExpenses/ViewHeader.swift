//
//  ViewHeader.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

struct TextStruct {
    var font: UIFont
    var text: String
    var colorText: UIColor
}

class ViewHeader: UIButton {
    
    private var headerLabel: UILabel?
    private var buttonHeader: UILabel?
    
    init(leftLabelSettings: TextStruct, rightLabelSettings: TextStruct) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        
        headerLabel = UILabel()
        headerLabel?.text = leftLabelSettings.text
        headerLabel?.font = leftLabelSettings.font
        headerLabel?.textColor = leftLabelSettings.colorText
        self.addSubview(headerLabel!)
        
        buttonHeader = UILabel()
        buttonHeader?.text = rightLabelSettings.text
        buttonHeader?.textAlignment = .right
        buttonHeader?.font = rightLabelSettings.font
        buttonHeader?.textColor = rightLabelSettings.colorText
        self.addSubview(buttonHeader!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateHeaderButton(text: String) {
        buttonHeader?.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        let widthHeader = self.frame.width * 0.5
        headerLabel?.frame = CGRect(x: 9, y: 0, width: widthHeader - 9, height: self.frame.height)
        buttonHeader?.frame = CGRect(x: headerLabel!.frame.maxX, y: 0, width: self.frame.width * 0.5 - 9, height: self.frame.height)
    }
}
