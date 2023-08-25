//
//  MyCar.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 15/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class MyCar: UIView {

    private var labelCar: UILabel?
    private var button: UIButton?
    lazy private var auto = ModelAuto()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let height = self.frame.height / 3
        let padding: CGFloat = 20
        self.labelCar?.frame = CGRect(x: padding,
                                      y: self.frame.midY - height,
                                      width: self.frame.width - padding * 2,
                                      height: height)
    }
    
    func initialization() {
        self.labelCar = UILabel()
        self.labelCar?.font = UIFont(name: "SFUIDisplay-Bold", size: 28)
        
        self.button = UIButton()
        self.button?.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc func actionButton() {
        auto.addInfo {(autoName) in
            self.labelCar?.text = autoName
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
