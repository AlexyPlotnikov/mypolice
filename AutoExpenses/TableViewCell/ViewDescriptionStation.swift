//
//  ViewDescriptionStation.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 14.01.2020.
//  Copyright © 2020 rx. All rights reserved.
//

import UIKit



protocol DelegateStateDesciptionForStation: class {
    var show: Bool {get set}
}

class ViewDescriptionStation: UIView {

    private var longDescription: String?
    private var shortDescription: String?
    
    private var headerButton: ViewHeader?
    private var labelDescription: UILabel?
    private weak var delegate: DelegateStateDesciptionForStation?
    
    init(longDescription: String, shortDescription: String, delegate: DelegateStateDesciptionForStation) {
        super.init(frame: .zero)
        self.longDescription = longDescription
        self.shortDescription = shortDescription
        self.delegate = delegate
        
        headerButton = ViewHeader(leftLabelSettings: TextStruct(font: UIFont(name: "SFProDisplay-Semibold", size: 15.6)!,
                                                                text: "Описание",
                                                                colorText: .black),
                                  rightLabelSettings: TextStruct(font: UIFont(name: "SFProDisplay-Medium", size: 15.6)!,
                                                                 text: "См.  полностью",
                                                                 colorText: UIColor.init(rgb: 0xFFB830)))
        headerButton?.addTarget(self, action: #selector(show), for: .touchUpInside)
        self.addSubview(headerButton!)
        
        labelDescription = UILabel()
        labelDescription?.numberOfLines = 10
        labelDescription?.textColor = UIColor.init(rgb: 0x373737)
        labelDescription?.font = UIFont(name: "SFProDisplay-Regular", size: 13.7)!
        labelDescription?.text = shortDescription
        self.addSubview(labelDescription!)
    }

    
    @objc private func show() {
        self.delegate?.show = !(self.delegate?.show ?? true)
        let text = self.delegate?.show ?? true ? "Свернуть" : "См.  полностью"
        labelDescription?.text = !(self.delegate?.show ?? true) ? shortDescription : longDescription
        self.headerButton?.updateHeaderButton(text: text)
        setNeedsLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerButton?.frame = CGRect(x: 0,
                                     y: 0,
                                     width: self.frame.width,
                                     height: 36)
        
        let heightLabel = labelDescription?.text?.heightNeededForLabel(labelDescription!) ?? 0
        
        labelDescription?.frame = CGRect(x: 9,
                                         y: headerButton!.frame.height,
                                         width: self.frame.width - 9,
                                         height: heightLabel)
        
        self.frame.size.height = headerButton!.frame.height + labelDescription!.frame.height
    }
    
}


