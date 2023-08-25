//
//  CheckAccess.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 26/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import  AVFoundation
import Photos

class CheckAccess {
    
    enum TypeAccess {
        case Camera, Gallery
    }
    
    private var type: TypeAccess?
    private var viewControllerForShowAlert: UIViewController?
    
    init(type: TypeAccess, viewControllerForShowAlert: UIViewController) {
        self.viewControllerForShowAlert = viewControllerForShowAlert
        self.type = type
    }
    
    func checkState( callback: @escaping (_ granted: Bool)->Void ) -> Bool {
        if let selType = type {
            switch selType {
            case .Gallery:
                    let photos = PHPhotoLibrary.authorizationStatus()
                    if photos == .authorized {
                        callback(true)
                        return true
                    } else {
                        PHPhotoLibrary.requestAuthorization({status in
                            if status == .notDetermined {
                                
                                self.showAlertToTransitionSettings(title: "Ошибка доступа к галереи", message: "Разрешите доступ для использования галереи")
                                callback(false)
                            }
                        })
                        
                        return false
                }
                
            case .Camera:
                var tempState = false
                
                if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
                   tempState = true
                } else {
                    AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                        tempState = granted
                        if granted == true {
                           callback(true)
                        } else {
                            self.showAlertToTransitionSettings(title: "Ошибка доступа к камере", message: "Разрешите доступ для использования камеры")
                            callback(false)
                        }
                    })
                }
                return tempState
            }
        }
        return false
    }
    
    private func showAlertToTransitionSettings(title: String, message: String) {
        
        if let vc = self.viewControllerForShowAlert {
            let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
}
