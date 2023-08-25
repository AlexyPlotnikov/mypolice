//
//  ViewShowWear.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 19.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewShowWear: UIView {
    
    var textHeader: UILabel?
    var periodWearDetail: UILabel?
    var progressView: ViewProgress?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
      
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    private func setup() {
        textHeader = UILabel()
        textHeader?.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        textHeader?.textColor = UIColor.init(rgb: 0x8C8C8C)
        self.addSubview(textHeader!)
        
        periodWearDetail = UILabel()
        self.addSubview(periodWearDetail!)
        
        progressView = ViewProgress(cornerRadius: 4)
        self.addSubview(progressView!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let leadingSpacing: CGFloat = 14
        textHeader?.frame = CGRect(x: leadingSpacing, y: 0, width: self.frame.width - leadingSpacing * 2, height: 30)
        periodWearDetail?.frame = CGRect(x: leadingSpacing, y: textHeader!.frame.maxY + 3, width: textHeader!.frame.width, height: 26)
        progressView?.frame = CGRect(x: leadingSpacing, y: periodWearDetail!.frame.maxY + 8, width: self.frame.width - leadingSpacing * 2, height: 8)
    }
    
    func updateData(model: IModelWear, typeWear: TypeWearView) {
        self.progressView?.setPriogressInPercentages(percentages: model.percentageFromCurrentValue, colorForProgress: model.color)
        periodWearDetail?.setNewChar(newArrayAttr: model.kitAttributesFromTypeView(typeWear: typeWear))
    }
}
