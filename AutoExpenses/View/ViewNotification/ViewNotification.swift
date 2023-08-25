//
//  ViewNotification.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewNotification: UIView {

    private var labelHeader: UILabel!
    private var labelMonthToEndPolicy: UILabel!
    private var lineImageView: UIImageView!
    private var labelDate: UILabel!
    private weak var delegate: DelegateOpenAdditionalScreen?
    
    init(textHeader: String, countMonth: Int, dateStartAndEnd: String, delegate: DelegateOpenAdditionalScreen) {
        super.init(frame: CGRect.zero)
        
        self.delegate = delegate
        self.layer.cornerRadius = 13
        self.layer.borderColor = UIColor.init(rgb: 0xDADADA).cgColor
        self.layer.borderWidth = 1
        
        labelHeader = UILabel()
        labelHeader.text = textHeader
        labelHeader.font = UIFont(name: "SFProDisplay-Medium", size: 22)
        self.addSubview(labelHeader)
        
        labelMonthToEndPolicy = UILabel()
        labelMonthToEndPolicy.backgroundColor = UIColor.init(rgb: 0xFECC56)
        labelMonthToEndPolicy.textColor = .white
        labelMonthToEndPolicy.textAlignment = .center
        labelMonthToEndPolicy.font = UIFont(name: "SFProDisplay-Medium", size: 15)
        labelMonthToEndPolicy.layer.cornerRadius = 5
        labelMonthToEndPolicy.layer.masksToBounds = true
        labelMonthToEndPolicy.text = countMonth >= 12 ? "1 год" : countMonth.toString("мес")
        self.addSubview(labelMonthToEndPolicy)
        
        labelDate = UILabel()
        labelDate.textAlignment = .center
        labelDate.textColor = UIColor.init(rgb: 0x373737)
        labelDate.font = UIFont(name: "SFProDisplay-Regular", size: 15)
        labelDate.text = dateStartAndEnd
        self.addSubview(labelDate)
        
        lineImageView = UIImageView(image: UIImage(named: "line_OSAGO"))
        lineImageView.contentMode = .scaleAspectFill
        self.addSubview(lineImageView)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPolicy)))
    }
    
    @objc private func openPolicy() {
        PolicyOSAGOService().presentVC(vc: (delegate as! UIViewController))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelMonthToEndPolicy.frame = CGRect(x: self.frame.width - 15 - 60, y: 17, width: 60, height: 25)
       
        labelHeader.frame = CGRect(x: 13.5, y: 17, width: self.frame.width - 15 - 60 - 13.5, height: 25)
        
        lineImageView.frame = CGRect(x: 0, y: labelMonthToEndPolicy.frame.maxY + 15, width: self.frame.width, height: 12)
        
        labelDate.frame = CGRect(x: 0, y: lineImageView.frame.maxY + 14, width: self.frame.width, height: 18)
    }
    
}
