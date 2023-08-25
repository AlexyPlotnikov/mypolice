//
//  SegmentView.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class SegmentView: UIView {

    private var label: UILabel?
    var pointSelected: CGPoint = CGPoint.zero
    
    init(text: String) {
        super.init(frame: CGRect.zero)
        label = UILabel()
        label?.text = text
        label!.textAlignment = .center
        label!.textColor = .white
        self.addSubview(label!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label!.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 18)
        pointSelected = CGPoint(x: self.frame.midX, y: label!.frame.height + 7)
    }
    
    func selectedTab(select: Bool) {
        
        guard let myLabel = self.label else {
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            myLabel.font = select ? UIFont(name: "SFProDisplay-Bold", size: 16) : UIFont(name: "SFProDisplay-Medium", size: 16)
            myLabel.alpha = select ? 1 : 0.4
        }
    }
    
}
