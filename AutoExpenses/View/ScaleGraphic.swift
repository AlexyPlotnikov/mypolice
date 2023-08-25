//
//  ScaleGraphic.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 29/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ScaleGraphic: UIView {
    
    private var heightScale = CGFloat()
    private var heightIconCategory = CGFloat()
    private var iconView: UIImageView!
    private var scaleView: UIView!
    private var gradient: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    
    private func initialization() {

        self.heightIconCategory = self.frame.height * 0.1
        
        if self.scaleView == nil {
            self.scaleView = UIView(frame:CGRect(x: 5,
                                          y: self.frame.height,
                                          width: self.frame.width - 10,
                                          height: 0))
            self.addSubview(scaleView)
            
            if gradient == nil {
                gradient = CAGradientLayer()
                self.scaleView.layer.insertSublayer(gradient, at: 0)
            }
        }
        
        if self.iconView == nil {
            self.iconView = UIImageView(frame: CGRect(x: self.scaleView.center.x - heightIconCategory * 0.5,
                                                      y: 0,
                                                      width: heightIconCategory,
                                                      height: heightIconCategory))
            self.iconView.alpha = 0
            self.addSubview(self.iconView)
        }
    }
    
    
    func building(category: BaseCategory, length: CGFloat) {
        
        self.scaleView.backgroundColor = category.colorHead
        self.iconView.image = category.iconCategoryActivate
        
       
        
        self.heightScale = length - self.heightIconCategory * 1.5
        
        self.heightScale = self.heightScale < self.frame.height  * 0.01 ? self.frame.height * 0.01 : self.heightScale  // задаем минимальный размер для графика

        
       
        UIView.animate(withDuration: 0.5) {
            self.scaleView.frame = CGRect(x: 5,
                                           y: self.frame.height - self.heightScale,
                                           width: self.frame.width - 10,
                                           height: self.heightScale)
            self.iconView.alpha = 1
            
            self.gradient.colors = [category.colorHead.cgColor, category.colorGradient.cgColor]
            self.gradient.locations = [0.0, 1.0]
            self.gradient.frame = self.scaleView.bounds
        }
    }
    
}
