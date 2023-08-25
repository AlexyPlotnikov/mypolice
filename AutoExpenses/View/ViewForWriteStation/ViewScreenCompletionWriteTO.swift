//
//  ViewScreenCompletionWriteTO.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 08.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//


import UIKit

protocol DelegateEndSessionWriting: class {
    func exit(text:String)
}


class ViewScreenCompletionWriteTO: UIView {

    private var icon: UIImageView?
    private var label: UILabel?
    private var buttonDone: UIButton?
    private weak var delegate: DelegateEndSessionWriting?
    
    init(frame: CGRect, delegate: DelegateEndSessionWriting & DelegateSetDate) {
        super.init(frame: frame)
        self.delegate = delegate
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        icon = UIImageView()
        icon?.contentMode = .scaleAspectFit
        icon?.image = UIImage(named: "ok")
        self.addSubview(icon!)
        
        label = UILabel()
        label?.textAlignment = .center
        label?.setNewChar(newArrayAttr:
            [NewAttrChar(color: .black, font: UIFont(name: "SFProDisplay-Medium", size: 17)!, char: "Заявка принята\n\n"),
             NewAttrChar(color: UIColor.init(rgb: 0x959595), font: UIFont(name: "SFProDisplay-Regular", size: 15)!, char: (delegate as! DelegateSetDate).dateSelected!.toString(format: "d MMMM yyyy \n на H:mm") + "\n"),
             NewAttrChar(color: UIColor.init(rgb: 0x959595), font: UIFont(name: "SFProDisplay-Regular", size: 15)!, char: "В ближайшее время с Вами свяжется сервисный консультант для уточнения деталей")])
        self.addSubview(label!)
        
        buttonDone = UIButton()
        buttonDone?.setTitle("Готово", for: .normal)
        buttonDone?.setTitleColor(.black, for: .normal)
        buttonDone?.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 17)!
        buttonDone?.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        self.addSubview(buttonDone!)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
         
        icon?.frame = CGRect(x: self.center.x - 54 / 2, y: self.frame.height * 0.2, width: 54, height: 54)
        
        label?.frame = CGRect(x: 16, y: icon!.frame.origin.y + icon!.frame.height + 27, width: self.frame.width - 32, height: self.frame.height * 0.3)
        
        buttonDone?.frame = CGRect(x: 0, y: label!.frame.origin.y + label!.frame.height + 30, width: self.frame.width, height: self.frame.height * 0.15)
    }
    
    @objc private func actionButton() {
        if delegate != nil {
            delegate?.exit(text: label?.text ?? "Нет данных")
        }
    }
    
    
    
}
