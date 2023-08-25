//
//  ManagerPanelForWrite.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 02.12.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class PanelDropForWrite: PanelDropForWriteProtocol {
 
    private var alertScreenView: ViewAlertScreen?
    private weak var delegate: DelegateOpenAdditionalScreen?
    private var model: ModelTimeAndMileageWear?
    
    init(delegate: DelegateOpenAdditionalScreen, model: ModelTimeAndMileageWear) {
        self.model = model
        self.delegate = delegate
    }
        
    func show(complete: (() -> Void)?) {
        
        let rootViewController =  UIApplication.shared.keyWindow?.rootViewController
        
        let viewAlert =  ViewPanelAlert(frame: CGRect(x: 0,
                                                      y: rootViewController!.view.frame.height,
                                                      width: rootViewController!.view.frame.width,
                                                      height: 300))

        alertScreenView = ViewAlertScreen(frame: rootViewController!.view.frame, alertView: viewAlert, delegate: self.delegate!)
        rootViewController!.view.addSubview(alertScreenView!)
        
        self.model!.updateViewWear(viewForUpdate: alertScreenView!.getView())
        
        alertScreenView?.showView({
            complete?()
        })
    }
        
    func close(complete: (()->Void)?) {
        alertScreenView?.closeView({
            complete?()
        })
    }
    
}

