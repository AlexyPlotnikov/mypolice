//
//  CollectionViewCellAutoInfo.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 13/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class CollectionViewCellAutoInfo: UICollectionViewCell {
    
    private var dataUser : IAddInfoProtocol?
    private var gradient : CAGradientLayer!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var InfoLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
//    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.indicatorLoading.insertSubview(blurEffectView, at: 0)
//        self.indicatorLoading.startAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.95
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2
        self.layer.cornerRadius = 10
    }
    
    func animationShow() {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }) { (Bool) in
            UIView.animate(withDuration: 0.1,
                           animations: {
                            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    }
    
    func initilization(dataUser : IAddInfoProtocol) {
        self.dataUser = dataUser
        self.headerLabel.text = self.dataUser!.headerField
        self.InfoLabel.text = self.dataUser?.info
        self.icon.image = self.dataUser!.icon
        self.icon.contentMode = .scaleAspectFit
//        self.indicatorLoading.startAnimating()
        
     // Установка цвета
//        if self.InfoLabel.text == "Нет данных" {
//            self.backgroundColor = UIColor.init(rgb: 0xFFE766)      // если не заполнено
//        }
//        else {
//            self.backgroundColor = UIColor.init(rgb: 0xDCFFA7)      // если заолнено
//        }
//
//        if self.dataUser?.addInfo == nil {
//             self.backgroundColor = .lightGray                      // если не редактируемое
//        }
//
//
//        if self.gradient != nil {
//            self.gradient.removeFromSuperlayer()
//        }
//
//        self.gradient = CAGradientLayer()
//        self.gradient.colors = [UIColor.white.cgColor, self.backgroundColor!.cgColor]
//        self.gradient.locations = [0.0,1.0]
//        self.gradient.frame = self.bounds
//        self.layer.insertSublayer(self.gradient, at: 0)
        
//        self.animationShow()
    }
    
    func click() {
        if self.dataUser!.addInfo != nil
        {
            print("You can click")
            self.dataUser!.addInfo?(comletion: { (info) in
                self.InfoLabel.text = info
            })
        }
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                 click()
            }
        }
    }
    
}
