//
//  ViewWearBase.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 28.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewWearBase: UIView {
    
    weak var delegate: DelegateOpenAdditionalScreen?
    var model: ModelTimeAndMileageWear?
    
    init(delegate: DelegateOpenAdditionalScreen?, model: ModelTimeAndMileageWear?) {
        super.init(frame: CGRect.zero)
        
        self.delegate = delegate
        self.model = model
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func functionOpenAlert() {
        delegate?.openAlert(PanelDropForWrite(delegate: self.delegate!, model: model!))
    }
    
    @objc func functionOpenScreen() {
        delegate?.openScreen(StationTechnicalService().viewControllerForOpen!)
    }
}
