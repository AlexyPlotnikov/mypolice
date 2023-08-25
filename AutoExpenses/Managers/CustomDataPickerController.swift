//
//  CustomAlertControllerViewController.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 26/04/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

// class view alert
class CustomDataPickerController: UIView {
    
    enum StyleAlert {
        case DataPicker
        case ViewPicker
        case DefaultAlert
    }
    
    var dataPicker = UIDatePicker()
    
    private var parentView: UIView?
    private var fadeView: UIView!
    private var headView: UIView!
    private var titleLabel : UILabel!
    private var titleMessage: UILabel!
    private var actions: [CustomAlertAction] = []
    
    private var mode: UIDatePicker.Mode?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(parentView: UIView, title: String?, message: String?, pickerMode: UIDatePicker.Mode) {
      super.init(frame: parentView.frame)
        
        
        self.mode = pickerMode
        self.parentView = parentView
        
        fadeView = UIView(frame: self.frame)
        fadeView.backgroundColor = .black
        fadeView.alpha = 0.0
        self.addSubview(fadeView)
        
        let sizeView = CGSize(width: self.frame.width - 20, height: self.frame.height * 0.5)
        headView = UIView(frame: CGRect(x: 10, y: self.frame.height , width: sizeView.width, height: sizeView.height))
        headView.backgroundColor = .white
        headView.layer.masksToBounds = true
        headView.layer.cornerRadius = 10
        self.addSubview(headView)
        
        titleLabel = UILabel(frame: CGRect(x: 0,
                                               y: 0,
                                               width: self.frame.width,
                                               height: self.frame.height * 0.1))
        titleLabel.text = title
        titleLabel.font = titleLabel.font.toBold()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        self.headView.addSubview(titleLabel)

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAlert))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeAlert))
        swipeDown.direction = .down
        self.fadeView.addGestureRecognizer(tap)
        self.fadeView.addGestureRecognizer(swipeDown)
    }
    
    
    func addAction(_ action: CustomAlertAction) {
        self.actions.append(action)
        let index = self.actions.firstIndex(of: action)!+1
        let actionTemp = action
        
        actionTemp.createButton(CGRect(x: 0,
                                       y: self.headView.frame.height - (self.headView.frame.height * 0.15) * index.toCGFloat(),
                                   width: self.headView.frame.width,
                                   height: self.headView.frame.height * 0.15))
        
        actionTemp.addTarget(self, action: #selector(closeAlert) , for: .touchUpInside) // закрытие алерта
        self.headView.addSubview(action)
    }
    
    func showAlert() {
        self.parentView!.addSubview(self)
        
        let pointTitleY = titleLabel.frame.origin.y + titleLabel.frame.height
        
        self.dataPicker = UIDatePicker(frame: CGRect(x: 0,
                                                     y: pointTitleY-10,
                                                     width: headView.frame.width,
                                                     height: self.actions[self.actions.count-1].frame.origin.y - pointTitleY))
        
        if #available(iOS 13.0, *) {
            self.dataPicker.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.dataPicker.datePickerMode = self.mode!
        self.dataPicker.locale = Locale(identifier: "ru_MD")
        self.headView.addSubview(dataPicker)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.fadeView.alpha = 0.7
            self.headView.frame.origin.y -= self.headView.frame.height + 25
        })
    }
    
    @objc func closeAlert() {
        UIView.animate(withDuration: 0.15, animations: {
            self.fadeView.alpha = 0.0
            self.headView.frame.origin.y += self.headView.frame.height - 25
        }) { (complete) in
            for item in self.actions {
                item.removeFromSuperview()
            }
            self.actions.removeAll()
            self.removeFromSuperview()
        }
    }
}



