//
//  StationTechnicalService.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class StationTechnicalService : BaseAutoInfo {
    
    override var viewControllerForOpen: UIViewController? {

            return ViewControllerListServices()
        
//        let vc: ViewControllerPartsService = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerPartsService") as! ViewControllerPartsService
         
//        vc._title = "Автосервис"
     //    return vc
    }
    
    override init() {
        super.init()
        self.backImage = UIImage(named: "Car service")
        self.headerField = "Автосервис"
        self.icon = UIImage(named: "Car service icon")
        updateInfo()
        
    }

    func updateInfo() {
        self.info = "Здесь Вы можете выбрать подходящий автосервис и записаться на ремонт и ТО"
    }
    
    override func presentVC(vc: UIViewController) {
        super.presentVC(vc: vc)
        AnalyticEvents.logEvent(.OpenServices)
    }
    
    override func addInfo(comletion: @escaping (String) -> Void) {
    }
}
