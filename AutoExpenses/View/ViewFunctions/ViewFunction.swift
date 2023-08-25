//
//  ViewFunction.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewFunction: UIView {
    
    var labelText: UILabel?
    var icon: UIImageView?
    
    init(text: String, image: UIImage?) {
        super.init(frame: CGRect.zero)
        setup(text: text, image: image)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(text: String, image: UIImage?) {
        let color: UIColor = .white
        self.backgroundColor = color.withAlphaComponent(0.1)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        labelText = UILabel()
        labelText?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        labelText?.textColor = .white
        labelText?.text = text
        self.addSubview(labelText!)
        
        icon = UIImageView()
        icon?.image = image
        icon?.contentMode = .scaleAspectFit
        self.addSubview(icon!)
    }
    

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
       
        
        let heightIconWithSpacings: CGFloat = (18 + 7 * 2)
        labelText?.frame = CGRect(x: 10, y: 0, width: self.bounds.width - heightIconWithSpacings - 10, height: self.bounds.height)
        
        icon?.frame = CGRect(x: self.bounds.width - heightIconWithSpacings, y: self.bounds.midY - 18 * 0.5, width: 18, height: 18)
        
    }
    
    
}
