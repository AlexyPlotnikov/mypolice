//
//  BaseAutoInfo.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import JMMaskTextField_Swift

class BaseAutoInfo : NSObject, IAddInfoProtocol {
    
    var heightFields: CGFloat = 0
    
    weak var viewControllerForOpen: UIViewController? {
        return UIViewController()
    }
    
    weak var delegateUpdateData: DelegateReloadData?
   // делегат для обновления данных на ViewControllerHead
    weak var delegateViewExpenses: DelegateViewExpenses?
    
    var id: String = ""
    var headerField: String
    var info = String()
    var icon : UIImage?
    var backImage: UIImage?
    
    
    override init() {
        
        self.headerField = "Нет данных"
        self.info = ""
    }

    func isEmpty() -> Bool {
        return false
    }
    
    // func protocol IAddInfoProtocol
    func addInfo(comletion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: self.headerField, message: nil, preferredStyle: .alert)
        
        alert.addTextField {(textField) in
            textField.delegate = self // делегат для TextField
            textField.placeholder = "Нет данных"
            textField.text = self.info == "Нет данных" ? "" : self.info
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (actionOk) in
            let textInField = alert.textFields![0].text!.isEmpty ? "" : alert.textFields![0].text
            if textInField != "" {
                self.info = textInField!
            }
            comletion(self.info)
            self.delegateUpdateData?.updateData()
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        LocalDataSource.statisticViewController.present(alert, animated: true, completion: nil)
    }
    
    func presentVC(vc: UIViewController) {
        let vcForShow = self.viewControllerForOpen!
        let isToken = EntityCarUser().checkData() && !EntityCarUser().getDataFromDBCurrentID()[0].token.isEmpty
        let authorization = EntityAuthorization().checkData()
        let delegate: DelegateShowViewController!
               // TODO: Analytics
               if authorization && isToken {
                   vc.navigationController?.pushViewController(vcForShow, animated: true)
               } else {
                   let vcAuthorization = UserAuthorization.sharedInstance.currentViewController(.Authorization) as! ViewControllerAutorization
                
                   delegate = vcAuthorization
                   UserAuthorization.sharedInstance.translitionInAutorization(in: vc, callback: { (state) in
                    DispatchQueue.main.async {
                        if state {
                           if !authorization {
                            
                               delegate.showViewController(vc: vcForShow)
                               vc.navigationController?.pushViewController(vcAuthorization, animated: true)
                            }
                           } else {
                                vc.navigationController?.pushViewController(vcForShow, animated: true)
                           }
                       }
                   })
               }
    }
}

extension BaseAutoInfo : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.keyboardType = .default
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        guard let text = textField.text else { return false }
        
        let count = text.count + string.count - range.length
        return count<=20
    }
}
