//
//  ViewFunctionsForEveryViewController.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewFunctionsForEveryViewController: UIView {

    private var arrayFunctions: [ViewFunction]?
    
    init(arrayFunctions: [ViewFunction]) {
        super.init(frame: CGRect.zero)
        self.arrayFunctions = arrayFunctions
        self.backgroundColor = UIColor.init(rgb: 0x111624)
        for function in self.arrayFunctions! {
            self.addSubview(function)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let widthView = (self.frame.width / arrayFunctions!.count.toCGFloat())
        
        for i in 0..<arrayFunctions!.count {
            let view = arrayFunctions![i]
            let spacing: CGFloat = i < arrayFunctions!.count ? 11 : 0
            view.frame = CGRect(x: (widthView + spacing) * i.toCGFloat(), y: 0, width: widthView - spacing, height: self.frame.height)
        }
    }
    
}
