//
//  ViewProgress.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 24.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewProgress: UIView {

    private var viewFg: UIView?
    private var cornerRadius: CGFloat = 1.5
    private var percentages: Float = 0
    
    init(cornerRadius: CGFloat) {
        super.init(frame: CGRect.zero)
        self.cornerRadius = cornerRadius
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.init(rgb: 0xDFE4ED)
        self.layer.cornerRadius = cornerRadius
        
        viewFg = UIView()
        self.addSubview(viewFg!)
        viewFg?.layer.cornerRadius = cornerRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setPriogressInPercentages(percentages: self.percentages, colorForProgress: self.viewFg!.backgroundColor ?? .white)
    }
    
    func setPriogressInPercentages(percentages: Float, colorForProgress: UIColor) {
        let minWidth: CGFloat = 0
        self.percentages = percentages
        let widthValue = self.frame.width / 100 * CGFloat(percentages)
        viewFg?.backgroundColor = colorForProgress
        viewFg?.frame.size.height = self.frame.height
        UIView.animate(withDuration: 0.25) {
            self.viewFg?.frame = CGRect(x: 0, y: 0, width: widthValue <= minWidth ? minWidth : widthValue, height: self.frame.height)
        }
    }
    
}
