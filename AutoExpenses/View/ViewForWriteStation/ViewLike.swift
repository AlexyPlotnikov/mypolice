//
//  ViewLike.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 15.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

struct ModelLike {
    var countLikes: Int = 0
    var myLike: Bool = false
    var imageLogo: UIImage?
}

class ViewLike: UIView {
    private var icon: UIImageView?
    private var labelCounterLikes: UILabel?
    private var logo: UIImageView?
    private var modelLike: ModelLike! {
        didSet {
            updateCounterLikes(model: self.modelLike)
        }
    }
    
    init(frame: CGRect, modelLike: ModelLike) {
        super.init(frame: frame)
        self.modelLike = modelLike
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modelLike = ModelLike(countLikes: Int.random(in: 0..<100), myLike: Bool.random(), imageLogo: UIImage(named: "logoCars_Autoriyeki"))
        setup()
    }
    
    private func setup() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setLike)))
        
        icon = UIImageView()
        icon?.image = UIImage(named: "like")
        icon?.image = icon?.image?.withRenderingMode(.alwaysTemplate)
        self.addSubview(icon!)
        
        labelCounterLikes = UILabel()
        labelCounterLikes?.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        labelCounterLikes?.textColor = UIColor.init(rgb: 0x717171)
        self.addSubview(labelCounterLikes!)
        
        logo = UIImageView()
        logo?.contentMode = .scaleAspectFit
        logo?.image = modelLike.imageLogo
        self.addSubview(logo!)
        
        updateCounterLikes(model: self.modelLike!)
    }
    
    func updateCounterLikes(model: ModelLike) {
        
        if modelLike.myLike {
            labelCounterLikes?.text = model.countLikes <= 0 ? "нравится Вам" : "нравится Вам и еще \(model.countLikes)"
        } else {
            labelCounterLikes?.text = "нравится \(model.countLikes)"
        }
        
        icon?.tintColor = modelLike.myLike ? #colorLiteral(red: 1, green: 0.7764705882, blue: 0.2588235294, alpha: 1) : UIColor.init(rgb: 0xAEAEAE)
    }
    
    @objc private func setLike() {
        modelLike.myLike = !modelLike.myLike
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let widthLogo = self.frame.width * 0.15
        logo?.frame = CGRect(x: self.frame.width - widthLogo - 16, y: 0, width: widthLogo, height: self.frame.height)
        
        let heightIcon = self.frame.height * 0.4
        icon?.frame = CGRect(x: 16, y: self.bounds.midY - heightIcon * 0.5, width: heightIcon, height: heightIcon)
        
        labelCounterLikes?.frame = CGRect(x: icon!.frame.maxX + 16, y: 0, width: logo!.frame.origin.x - (icon!.frame.origin.x + icon!.frame.width)-16, height: self.frame.height)
        
        let draw = DrawLine(view: self, setting: SettingDrawLine(pointStart: CGPoint(x: 0, y: self.frame.height - 1),
                                                                 pointEnd: CGPoint(x: self.frame.width, y: self.frame.height - 1),
                                                                 color: UIColor.init(rgb: 0xF2F2F2),
                                                                 lineWidth: 1))
        draw.drawLine()
    }
    
}
