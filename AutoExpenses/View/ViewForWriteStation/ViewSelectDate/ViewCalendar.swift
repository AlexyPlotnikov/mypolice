//
//  ViewCalendar.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 29.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import Foundation
import FSCalendar

protocol DelegateSetDate: class {
    var dateSelected: Date? {set get}
}

class ViewCalendar: UIView {
    
    private var calendar: FSCalendar?
    private var buttonShow: UIButton?
    private weak var delegate: DelegateSetDate?
    private var viewTime: ViewSelectedTime?
    private var first = true
    
    private var startDate: Date {
        var dc = DateComponents()
        dc.day = Calendar.current.component(.day, from: Date()) + 1
        dc.month = Calendar.current.component(.month, from: Date())
        dc.year = Calendar.current.component(.year, from: Date())
        dc.hour = 9
        dc.second = 0
        dc.minute = 0
        dc.weekOfYear = Calendar.current.component(.weekOfYear, from: Date())
        return Calendar.current.date(from: dc)!
    }
    
    private var endDate: Date {
        let monthCur = Calendar.current.component(.month, from: Date())
        let yearCur = Calendar.current.component(.year, from: Date()) + (monthCur + 1 > 12 ? 1 : 0)
        
        var dateComponent = DateComponents()
        dateComponent.month = monthCur + 1 > 12 ? 1 : monthCur + 1
        dateComponent.day = Calendar.current.component(.day, from: Date()) + 1
        dateComponent.year = yearCur
        return Calendar.current.date(from: dateComponent) ?? Date()
    }
    
    
    init(frame: CGRect, delegate: DelegateSetDate) {
        super.init(frame: frame)
        self.delegate = delegate
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    

    func setup() {
        
        calendar = FSCalendar()
        calendar?.calendarHeaderView.isHidden = true
        calendar?.delegate = self
        calendar?.dataSource = self
        calendar?.appearance.weekdayTextColor = UIColor.init(rgb: 0xCBC9D5)
        calendar?.appearance.headerTitleFont = UIFont(name: "SFProDisplay-Regular", size: 16)
        
        
        if self.delegate?.dateSelected == nil {
            self.delegate?.dateSelected = self.startDate
        }
        calendar?.select(self.delegate?.dateSelected, scrollToDate: true)

//        раскомментить если нужно выделять текущий день
        
//        calendar?.appearance.todayColor = .clear
//        calendar?.appearance.titleTodayColor = calendar?.appearance.titlePlaceholderColor
        self.addSubview(calendar!)

        
        viewTime = ViewSelectedTime(frame: self.bounds, delegate: self.delegate!)
        viewTime?.alpha = 0
        self.addSubview(viewTime!)

        buttonShow = UIButton()
        buttonShow?.setTitleColor(.black, for: .normal)
        buttonShow?.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        buttonShow?.addTarget(self, action: #selector(change), for: .touchUpInside)
        buttonShow?.contentHorizontalAlignment = .left

        self.buttonShow?.setImage(UIImage(named: "arrow_bottom"), for: .normal)
        self.addSubview(buttonShow!)
        
        self.updateMonth(Calendar.current.component(.month, from: self.delegate?.dateSelected ?? Date())-1)
    
    
    }
    
    @objc private func change() {
        let scope = self.calendar!.scope == .month ? FSCalendarScope.week : FSCalendarScope.month
        changeView(scope: scope)
    }
    
    private func changeView(scope: FSCalendarScope) {
        self.openScreenTime(state: scope == .week)
        let image = UIImage(named: scope == .week ? "arrow_bottom" : "arrow_up")
        self.buttonShow?.setImage(image, for: .normal)
        self.calendar!.setScope(scope, animated: false)
        
        
        calendar?.frame = CGRect(x: 0, y: buttonShow!.frame.origin.y + buttonShow!.frame.height - calendar!.calendarWeekdayView.frame.origin.y, width: self.frame.width, height: self.frame.height + calendar!.calendarWeekdayView.frame.origin.y)
        
        let pointY = calendar!.calendarWeekdayView.frame.origin.y + calendar!.calendarWeekdayView.frame.height + calendar!.rowHeight + 8
        viewTime?.frame = CGRect(x: 8, y: pointY, width: self.frame.width - 16, height: self.frame.height - pointY)
    }
    
    private func openScreenTime(state: Bool) {
        UIView.animate(withDuration: 0.1, animations: {
            self.viewTime?.alpha = state ? 1 : 0
        }) {(state) in
            
        }
    }
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buttonShow?.setTitleColor(.black, for: .normal)
        buttonShow?.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.5, height: 30)
       
        if first {
         changeView(scope: .week)
        } else {
          changeView(scope: calendar?.scope ?? .week)
        }
    }
    
    
    private func updateMonth(_ monthIndex: Int) {
        let month = Calendar.current.standaloneMonthSymbols[monthIndex]
        buttonShow?.setTitle(month.capitalizingFirstLetter(), for: .normal)
        buttonShow?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        buttonShow?.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonShow!.intrinsicContentSize.width + 15, bottom: 0, right: 0)
    }
}

extension ViewCalendar: FSCalendarDelegateAppearance {
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return #colorLiteral(red: 1, green: 0.7764705882, blue: 0.2588235294, alpha: 1)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .black
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        return UIColor.init(rgb: 0x2E2E39)
    }
}

extension ViewCalendar: FSCalendarDataSource {

    
     func minimumDate(for calendar: FSCalendar) -> Date {
         return startDate
     }

     func maximumDate(for calendar: FSCalendar) -> Date {
         return endDate
     }
    
}

extension ViewCalendar: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        var dateComponent = Calendar.current.dateComponents(in: .current, from: date)
        dateComponent.hour = Calendar.current.component(.hour, from: self.delegate!.dateSelected!)
        dateComponent.minute = Calendar.current.component(.minute, from: self.delegate!.dateSelected!)
        self.delegate?.dateSelected = dateComponent.date
        
        if self.calendar?.scope == FSCalendarScope.month {
            changeView(scope: .week)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateMonth(Calendar.current.component(.month, from: calendar.currentPage) - 1)
    }
    
}


