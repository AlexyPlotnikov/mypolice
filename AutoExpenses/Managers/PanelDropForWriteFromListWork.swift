//
//  PanelDropForWriteFromListWork.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 04.12.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class PanelDropForWriteFromListWork: PanelDropForWriteProtocol {
 
    private var alertScreenView: ViewAlertScreen?
    private weak var delegate: DelegateOpenAdditionalScreen?
    private var model: ModelTimeAndMileageWear
    
    init(delegate: DelegateOpenAdditionalScreen, model: ModelTimeAndMileageWear) {
        self.model = model
        self.delegate = delegate
    }
    
    func show(complete: (() -> Void)?) {
        let rootViewController =  UIApplication.shared.keyWindow?.rootViewController
        let viewAlert =  ViewPanelAlertTable(frame: CGRect(x: 0,
                                                      y: rootViewController!.view.frame.height,
                                                      width: rootViewController!.view.frame.width,
                                                      height: rootViewController!.view.frame.height * 0.8))
        model.updateViewWear(viewForUpdate: viewAlert)
        
        alertScreenView = ViewAlertScreen(frame: rootViewController!.view.frame, alertView: viewAlert, delegate: self.delegate!)
        rootViewController!.view.addSubview(alertScreenView!)

        alertScreenView?.showView ({
            complete?()
        })
    }
        
    func close(complete: (()->Void)?) {
        alertScreenView?.closeView ({
            complete?()
        })
    }
}
