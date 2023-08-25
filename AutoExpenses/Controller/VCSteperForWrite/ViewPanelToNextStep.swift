//
//  ViewPanelToNextStep.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 23.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

protocol DelegateSwitchStep: class {
    func nextStep()
    func prevStep()
}

class ViewPanelToNextStep: UIView {
    
    private var labelCost: UILabel?
    private var buttonNext: UIButton?
    
    var vc: UIViewController? {
        didSet {
            self.delegate = (vc as! DelegateSwitchStep)
        }
    }
    private weak var delegate: DelegateSwitchStep!
       
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        labelCost = UILabel()
        labelCost?.textColor = .white
        labelCost?.font = UIFont(name: "SFProDisplay-Heavy", size: 24)
        self.addSubview(labelCost!)
        
        buttonNext = UIButton()
        buttonNext?.backgroundColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0.2588235294, alpha: 1)
        buttonNext?.setTitleColor(.black, for: .normal)
        buttonNext?.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 17)
        buttonNext?.addTarget(self, action: #selector(nextButton), for: .touchDown)
        self.addSubview(buttonNext!)
    }
    
    
    @objc private func nextButton() {
        delegate.nextStep()
    }
    
    func setup(colorBack: UIColor, cost: String?, titleButton: String) {
        self.backgroundColor = colorBack
        buttonNext?.setTitle(titleButton, for: .normal)
        labelCost?.text = cost ?? ""
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.width// * 0.5
        
        self.labelCost?.frame = CGRect(x: 27, y: 20, width: width - 27 - 21 , height: 44)
        
        self.buttonNext?.frame = CGRect(x: 16, y: 16, width: width-16*2, height: 52)
        
        self.buttonNext?.layer.cornerRadius = 13
        
//        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 12))
//        let shape = CAShapeLayer()
//        shape.path = path.cgPath
//        self.layer.mask = shape
    }
    
}
