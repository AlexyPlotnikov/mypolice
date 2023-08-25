//
//  ViewSelectedProtectedEngine.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 07.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewSelectedProtectedEngine: UIView {

    
    private var switcherEngine: UISwitch?
    private var labelDescription: UILabel?
    private var delegate: DelegateInformationAditional!
    
    init(frame: CGRect, text: String, delegate: DelegateInformationAditional) {
        super.init(frame: frame)
        self.delegate = delegate
        setup(text: text)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(text: "")
    }
    
    private func setup(text: String) {
        self.layer.borderColor = UIColor.init(rgb: 0xCCCCCC).cgColor
        self.layer.borderWidth = 1
        
        switcherEngine = UISwitch()
        switcherEngine?.setOn(delegate.needSelectProtectEngine, animated: true)
        switcherEngine?.onTintColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0.2588235294, alpha: 1)
        switcherEngine?.addTarget(self, action: #selector(controllerSwither), for: UIControl.Event.valueChanged)
        self.addSubview(switcherEngine!)
        
        labelDescription = UILabel()
        labelDescription?.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        labelDescription?.textColor = .black
        labelDescription?.text = text
        self.addSubview(labelDescription!)
      
    }
    
    @objc private func controllerSwither(_ mySwitch: UISwitch) {
        delegate.needSelectProtectEngine = mySwitch.isOn
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelDescription?.frame = CGRect(x: 13,
                                         y: 0,
                                         width: self.frame.width - (switcherEngine!.frame.width + 16),
                                         height: self.frame.height)
        
        switcherEngine?.center = labelDescription!.center
        switcherEngine?.frame.origin.x = self.frame.width - (switcherEngine!.frame.width + 16)
        
    }
    
}
