//
//  ButtonCallNumber.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 14.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ButtonCallNumber: ViewSimpleIconAndLabel {
  
    private var arrayNumbers: [String]?
    private weak var vc: UIViewController?
    
    init(frame: CGRect, imageSetting: (UIImage, UIColor?), arrayNumbers: [String], vc: UIViewController) {
        
        self.vc = vc
        var text = ""
        for str in arrayNumbers {
            text += String(format: "%@;  ", str)
        }
        super.init(frame: frame, imageSetting: imageSetting, text: text)
        self.arrayNumbers = arrayNumbers
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(call)))
        
        self.label?.textColor = UIColor.init(rgb: 0xFFB830)
    }
    
    
    deinit {
        print("deinit ButtonCallNumber")
        arrayNumbers?.removeAll()
        arrayNumbers = nil
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    @objc private func call() {
        let alert = UIAlertController(title: "Звонок оператору", message: nil, preferredStyle: .actionSheet)
        
        for number in arrayNumbers! {
            let actionNumber = UIAlertAction(title: number, style: .default) { (action) in
                if let url = NSURL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.open(url as URL)
                }
            }
            alert.addAction(actionNumber)
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        vc?.present(alert, animated: true, completion: nil)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon?.frame = CGRect(x: 8,
                             y: self.frame.height * 0.5 - (self.frame.height * 0.9) * 0.5,
                             width: self.frame.height * 0.9,
                             height: self.frame.height * 0.9)
    }
}
