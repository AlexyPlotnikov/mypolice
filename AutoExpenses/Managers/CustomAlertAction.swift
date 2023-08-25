//
//  CustomAlertAction.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 30/04/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

//class button in view alert
class CustomAlertAction: UIButton {
    
    private var actionTemp: (() -> Void)?
    
    enum StyleAction {
        case delete
        case `default`
        case normal
        case black
    }
    
    init(title : String, styleAction: StyleAction, handler: (() -> Void)?) {
        super.init(frame: CGRect.zero)
        
        if handler != nil {
            self.actionTemp = handler
            self.addTarget(self, action: #selector (pressButton), for: .touchUpInside)
        }
        self.setStyleButton(styleAction, title: title)
    }
    
    @objc private func pressButton() {
        if self.actionTemp != nil {
            self.actionTemp!()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setStyleButton(_ style: StyleAction, title : String) {
        switch style {
        case .default:
            self.setTitleColor(UIColor.init(red: 0,green: 122,blue: 255), for: .normal)
            break
        case .delete:
            self.setTitleColor(.red, for: .normal)
            break
        case .normal:
            self.setTitleColor(UIColor.init(red: 0,green: 122,blue: 255), for: .normal)
            break
        case .black:
            self.titleLabel!.font = self.titleLabel!.font.toBold()
            self.setTitleColor(.black, for: .normal)
        }
        self.setTitle(title, for: .normal)
    }
    
    func drawLineFromPoint(rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.origin.x+10, y: rect.origin.y))
        path.addLine(to: CGPoint(x: rect.size.width-10, y: rect.origin.y))
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 0.15
        shape.strokeColor = UIColor.gray.cgColor
        self.layer.addSublayer(shape)
    }
    
    func createButton(_ rect: CGRect) {
        self.frame = rect
        self.drawLineFromPoint(rect: self.bounds)
    }
}

