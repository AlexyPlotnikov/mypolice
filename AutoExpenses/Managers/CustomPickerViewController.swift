//
//  CustomPickerViewController.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 30/04/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


struct ViewSettings {
    var elements : [String]?
    var title: String?
}

// class view alert
class CustomPickerViewController: UIView {
    
    enum StyleAlert {
        case DataPicker
        case ViewPicker
        case DefaultAlert
    }
    
    private var parentView: UIView?
    private var fadeView: UIView!
//    private var viewForFullTimeSwitcher: ViewFullTime?
    private var headView: UIView!
    private var titleLabel : UILabel!
    private var titleMessage: UILabel!
    private var actions: [CustomAlertAction] = []
    private var arrayElementsInPicker: [ViewSettings] = []
    private var pickerView: UIPickerView?
    
    var monthIndex: Int = Calendar.current.component(.month, from: Date()) + 1
    var year: Int = Calendar.current.component(.year, from: Date())
    
   
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(parentView: UIView, title: String?, message: String?,arrayElementsInPicker: [ViewSettings]) {
        super.init(frame: parentView.frame)

        self.parentView = parentView
        self.arrayElementsInPicker = arrayElementsInPicker
        
        fadeView = UIView()
        fadeView.backgroundColor = .black
        fadeView.alpha = 0.0
        self.addSubview(fadeView)

        headView = UIView()
        headView.backgroundColor = .white
        headView.layer.masksToBounds = true
        headView.layer.cornerRadius = 15
        self.addSubview(headView)
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = titleLabel.font.toBold()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        self.headView.addSubview(titleLabel)

//        viewForFullTimeSwitcher = ViewFullTime()
//        self.headView.addSubview(viewForFullTimeSwitcher!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAlert))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeAlert))
        swipeDown.direction = .down
        self.fadeView.addGestureRecognizer(tap)
        self.fadeView.addGestureRecognizer(swipeDown)
        
        self.parentView!.addSubview(self)
        
        for action in actions {
            let index = self.actions.firstIndex(of: action)! + 1
            action.frame = CGRect(x: 0,
                                y: self.headView.frame.height - (self.headView.frame.height * 0.15) * index.toCGFloat(),
                                width: self.headView.frame.width,
                                height: self.headView.frame.height * 0.15)
        }
        
        self.pickerView = UIPickerView()
        self.pickerView!.delegate = self
        self.pickerView!.dataSource = self
        self.pickerView?.showsSelectionIndicator = true
        self.headView.addSubview(self.pickerView!)
        
        self.layoutSubviews()
    }
    
    
    func addAction(_ action: CustomAlertAction) {
        
        self.actions.append(action)
        let index = self.actions.firstIndex(of: action)! + 1
        let actionTemp = action
        
        actionTemp.createButton(CGRect(x: 0,
                                       y: self.headView.frame.height - (self.headView.frame.height * 0.15) * index.toCGFloat(),
                                       width: self.headView.frame.width,
                                       height: self.headView.frame.height * 0.15))
    
        actionTemp.addTarget(self, action: #selector(closeAlert) , for: .touchUpInside) // закрытие алерта
        self.headView.addSubview(action)
    }
    
    func showAlert(year_month: StructDateForSelect) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.fadeView.alpha = 0.7
            self.headView.frame.origin.y -= self.parentView!.frame.height - self.headView.frame.height + 10
        })
        
        self.year = year_month.year
        self.monthIndex = year_month.month
        self.pickerView?.selectRow(year_month[.YearIndex] as? Int ?? 0, inComponent: 1, animated: false)
        self.pickerView?.selectRow(self.monthIndex, inComponent: 0, animated: false)
    }
    
    @objc func closeAlert() {
        UIView.animate(withDuration: 0.15, animations: {
            self.fadeView.alpha = 0.0
            self.headView.frame.origin.y += self.parentView!.frame.height
        }) { (complete) in
            for item in self.actions {
                item.removeFromSuperview()
            }
            self.actions.removeAll()
            self.removeFromSuperview()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        fadeView.frame = self.parentView!.frame
       
        let sizeView = CGSize(width: self.parentView!.bounds.width - 20, height: self.parentView!.bounds.height * 0.5 + 20)
        
        headView.frame = CGRect(x: 10,
                                y: self.parentView!.bounds.height - sizeView.height - 15,
                                width: sizeView.width,
                                height: sizeView.height)
        
        titleLabel.frame = CGRect(x: 0,
                                  y: self.headView.bounds.origin.y,
                                  width: self.parentView!.frame.width,
                                  height: self.parentView!.frame.height * 0.06)
               
        let pointViewFullTimeY = titleLabel.bounds.origin.y + titleLabel.bounds.height
        
//        self.viewForFullTimeSwitcher!.frame = CGRect(x: -5,
//                                                     y: pointTitleY,
//                                                     width: self.parentView!.bounds.width + 10,
//                                                     height: titleLabel.bounds.height)
//        self.viewForFullTimeSwitcher?.layer.borderColor = UIColor.black.cgColor
//        self.viewForFullTimeSwitcher?.layer.borderWidth = 0.5
        
//        let pointViewFullTimeY = self.viewForFullTimeSwitcher!.frame.origin.y + self.viewForFullTimeSwitcher!.frame.height
       
        
        let actionHeight = self.actions.count > 0 ? self.actions[0].frame.height : 0
        
       self.pickerView!.frame = CGRect(x: 0,
                                       y: pointViewFullTimeY + 5,
                                       width: headView.bounds.width - 10,
                                       height: self.headView.bounds.height - (self.actions.count).toCGFloat() * actionHeight - 10 - pointViewFullTimeY)
    }

}

extension CustomPickerViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return arrayElementsInPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: self.arrayElementsInPicker[component].elements![row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrayElementsInPicker[component].elements![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayElementsInPicker[component].elements!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 1:
            self.year = Int(arrayElementsInPicker[component].elements![row])!
        case 0:
            self.monthIndex = row
        default:
            break
        }
    }


    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.headView.frame.width * 0.5
    }
}

