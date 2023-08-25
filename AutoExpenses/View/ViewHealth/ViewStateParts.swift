//
//  ViewStateParts.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewStateParts: UIView {

    private var headerLabelParts: UILabel!
    private var buttonShowOther: UIButton!
    private var headerLabelPolicy: UILabel!
    private var scrollView: ScrollListStateParts!
    private var viewPolicy: ViewNotification?
    
    init(models: [ModelTimeAndMileageWear], delegate: DelegateOpenAdditionalScreen) {
        super.init(frame: CGRect.zero)
       
        self.backgroundColor = .white
        headerLabelPolicy = UILabel()
        headerLabelPolicy.text = "Страховка"
        headerLabelPolicy.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        headerLabelPolicy.textColor = UIColor.init(rgb: 0x8C8C8C)
        self.addSubview(headerLabelPolicy)
    
        scrollView = ScrollListStateParts(arrayModels: models, delegate: delegate, typeWearView: .Small)
        self.addSubview(scrollView)

        // fake data
        let dateStart = Date()
        let nextDate = Calendar.current.date(byAdding: .year, value: 1, to: dateStart)!
        
        viewPolicy = ViewNotification(textHeader: "ОСАГО", countMonth: 12, dateStartAndEnd: "\(String(describing: dateStart.toString(format: "dd.MM.yyyy")))-\(String(describing: nextDate.toString(format: "dd.MM.yyyy")))", delegate: delegate)
        self.addSubview(viewPolicy!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let widthHeader = self.frame.width * 0.8
        var heightView = self.frame.height * 0.5 - 20
        
        if heightView > 124 {
            heightView = 124
        }
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: heightView)
        
        headerLabelPolicy.frame = CGRect(x: 9, y: scrollView.frame.maxY, width: widthHeader - 9, height: 30)
        
        viewPolicy?.frame = CGRect(x: 16, y: headerLabelPolicy!.frame.maxY, width: self.frame.width * 0.6, height: heightView)
    }
    
}
