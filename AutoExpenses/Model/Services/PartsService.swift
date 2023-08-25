//
//  PartsService.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift

class PartsService : BaseAutoInfo {
    
    override var viewControllerForOpen: UIViewController? {
        let vc: ViewControllerPartsService = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerPartsService") as! ViewControllerPartsService
        
        vc._title = "Запчасти"
        return vc
        
       }
    
    override init() {
        super.init()
        self.backImage = UIImage(named: "Spare parts-1")
        self.headerField = "Запчасти"
        self.icon = UIImage(named: "settings-gears")
        updateInfo()
    }

    func updateInfo() {
        self.info = "Выбирайте и заказывайте самые качест-венные запчасти для своего автомобиля"
    }
    
    override func addInfo(comletion: @escaping (String) -> Void) {
        
    }
    
    override func presentVC(vc: UIViewController) {
        super.presentVC(vc: vc)
        AnalyticEvents.logEvent(.OpenParts)
    }
    
    func deleteDataBase(index: Int) {
        let entity = EntityModelAuto()
        for item in EntityModelAuto().getDataFromDBCurrentID() {
            entity.deleteFromDb(object: item)
        }
    }
}

extension PartsService {
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.keyboardType = .default
    }

    
}
