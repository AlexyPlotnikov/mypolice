//
//  PhotoAutoView.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 13/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

//MARK: Class get image from sources
class ImagePicker  {
    
    weak var viewController : UIViewController?
    weak var photo : AvatarAuto?
    weak var delegateView : (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?

    init(delegateView : (UIImagePickerControllerDelegate & UINavigationControllerDelegate)!, vc: UIViewController?) {
        self.viewController = vc
        self.delegateView = delegateView
    }
    
    // func call is alert for selected source to load image
    @objc func openSourceToGetImages(_ sender: UIView?) {
        
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let actionCamera = UIAlertAction(title: "Камера", style: UIAlertAction.Style.default) { (UIAlertAction) in
            self.openSource(fromSourceType: .camera)
        }
        let actionGallery = UIAlertAction(title: "Галерея", style: UIAlertAction.Style.default) { (UIAlertAction) in
            self.openSource(fromSourceType: .photoLibrary)
        }
        let actionCancel = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertSheet.addAction(actionCamera)
        alertSheet.addAction(actionGallery)
        alertSheet.addAction(actionCancel)
        
        if let popoverController = alertSheet.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: sender!.bounds.midX, y: sender!.bounds.midY, width: 0, height: 0)
        }
         self.viewController!.present(alertSheet, animated: true, completion: nil)
    }
    
    func openSourceToGetImages(_ sender: UIView?, delete: @escaping ()-> Void) {
        
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let actionCamera = UIAlertAction(title: "Камера", style: UIAlertAction.Style.default) { (UIAlertAction) in
            self.openSource(fromSourceType: .camera)
        }
        
        let actionGallery = UIAlertAction(title: "Галерея", style: UIAlertAction.Style.default) { (UIAlertAction) in
            self.openSource(fromSourceType: .photoLibrary)
        }
       
        
        let actionDelete = UIAlertAction(title: "Удалить", style: UIAlertAction.Style.destructive) { (UIAlertAction) in
           delete()
        }
        
        
        let actionCancel = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil)
        
        
        alertSheet.addAction(actionCamera)
        alertSheet.addAction(actionGallery)
        alertSheet.addAction(actionDelete)
        
        alertSheet.addAction(actionCancel)
        
        if let popoverController = alertSheet.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: sender!.bounds.midX, y: sender!.bounds.midY, width: 0, height: 0)
        }
        
        self.viewController!.present(alertSheet, animated: true, completion: nil)
    }
    
    //get image from source type
   private func openSource(fromSourceType sourceType: UIImagePickerController.SourceType) {
        //Check is source type available
    
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = delegateView
            imagePickerController.sourceType = sourceType
            imagePickerController.mediaTypes = ["public.image"]
            
            if sourceType == .camera {
                imagePickerController.cameraFlashMode = .off
            }
            
            imagePickerController.modalPresentationStyle = .fullScreen
            self.viewController!.present(imagePickerController, animated: true, completion: nil)
            
        }
    }
}


