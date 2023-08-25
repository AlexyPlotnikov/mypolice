//
//  ChooseDateController.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 10/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import UIKit

class ChooseDateController: IViewControll {
    
    
    private var date = Date()
    
    private var view: UIView?   // head view
    
    private var viewParent: UIView?
    private var rect: CGRect?
    private var labelMonthAndYear: UILabel?
    
    private var viewIconArrow: UIImageView?
    
    private var button: UIButton?
    
    init(viewParent: UIView, rect: CGRect) {
        self.viewParent = viewParent
        self.rect = rect
    }

    
    func create() {
        
        if self.view != nil {   // защита от созданий копий
            delete()
        }
        
        self.view = UIView(frame: rect ?? CGRect.zero)
        self.viewParent?.addSubview(self.view!)
        
        self.labelMonthAndYear = UILabel(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: self.rect!.width - (self.rect!.width * 0.15),
                                                       height: self.rect!.height))
        self.view!.addSubview(self.labelMonthAndYear!)
        
        self.labelMonthAndYear!.text = date.toString()
        self.labelMonthAndYear?.font = UIFont(name:"SFUIDisplay-Regular",size:17)
        
        self.viewIconArrow = UIImageView(frame: CGRect(x: self.rect!.width - (self.rect!.width * 0.15),
                                                       y: 0,
                                                       width: (self.rect!.width * 0.15),
                                                       height: self.rect!.height))
        self.viewIconArrow?.image = UIImage(named: "bottom_arrow")
        self.viewIconArrow?.contentMode = .scaleAspectFit
        self.view!.addSubview(self.viewIconArrow!)
        
        self.button = UIButton(frame: self.view!.bounds)
        self.button!.addTarget(self, action: #selector(showDataPicker(_:)), for: .touchUpInside)
        self.view!.addSubview(self.button!)
    }
    
   @objc private func showDataPicker(_ sender: UIButton) {

    let arrayYears = [(Calendar.current.component(.year, from: Date())-1).toString(),Calendar.current.component(.year, from: Date()).toString()]
    
        let alert = CustomPickerViewController(parentView: UIApplication.shared.keyWindow!.rootViewController!.view!, title: "Выберите дату", message:  nil, arrayElementsInPicker:
            [ViewSettings(elements: LocalDataSource.arrayMonth, title: "Месяц"),
            ViewSettings(elements: arrayYears, title: "Год")])
    
  
    
        let choose = CustomAlertAction(title: "Выбрать", styleAction: .normal) {
//            self.labelMonthAndYear?.text = alert.dataPicker.date.toString()
        }
        
        let cancel = CustomAlertAction(title: "Отмена", styleAction: .default)
        
        alert.addAction(cancel)
        alert.addAction(choose)
        
        alert.showAlert()
    
        alert.pickerView!.selectRow(1, inComponent: 2, animated: true)
    }
    func delete() {
        if self.view != nil {
            self.view?.removeFromSuperview()
        }
    }
    
    
    func update() {
        
        if self.view != nil {
            self.view!.frame = rect ?? CGRect.zero
        }
        
//        if self.labelMonthAndYear != nil {
//            self.labelMonthAndYear!.frame = CGRect(x: 0,
//                                            y: 0,
//                                            width: self.rect!.width - (self.rect!.width / 18.3),
//                                            height: self.rect!.height)
//            self.labelMonthAndYear!.text = date.toString()
//        }
        
        if self.button != nil {
            self.button!.frame = self.view!.bounds
        }
        
//        if self.viewIconArrow != nil {
//            self.viewIconArrow!.frame = CGRect(x: self.rect!.width - (self.rect!.width / 18.3),
//                                              y: 0,
//                                              width: self.rect!.width / 18.3,
//                                              height: self.rect!.height)
//        }
    }
    
}
