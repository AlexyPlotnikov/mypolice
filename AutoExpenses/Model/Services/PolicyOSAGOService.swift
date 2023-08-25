//
//  ModelAuto.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class PolicyOSAGOService : BaseAutoInfo {
    
    override var viewControllerForOpen: UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerPolicyOSAGO")
    }
    
    override init() {
        super.init()
        self.headerField = "ОСАГО"
        self.backImage = UIImage(named: "OSAGO")
        self.icon = UIImage(named: "Exclusion 22")
        updateInfo()
    }

    func updateInfo() {
        self.info = "Оформляйте и продлевайте полис своевременно. Данные всегда под рукой"
    }
    
    override func addInfo(comletion: @escaping (String) -> Void) {
        
    }
    
    override func presentVC(vc: UIViewController) {
        super.presentVC(vc: vc)
        AnalyticEvents.logEvent(.OpenPolicy)
    }
    
    func deleteDataBase(index: Int) {
        let entity = EntityModelAuto()
        for item in EntityModelAuto().getDataFromDBCurrentID() {
            entity.deleteFromDb(object: item)
        }
    }
}

extension PolicyOSAGOService {
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.keyboardType = .default
    }
}
