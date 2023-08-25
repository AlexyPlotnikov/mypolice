//
//  PhotoExpenses.swift
//  GenerateFieldsToEnter
//
//  Created by Evgeniy on 17/07/2019.
//  Copyright © 2019 Evgeniy. All rights reserved.
//

import UIKit

struct BoxPhoto {
    var image: Data?
    weak var photoView: PhotoViewCell?
}

class PhotoExpenses: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DelegateImagePicker {
    
    var imagesView: [BoxPhoto] = []
    private var scroll: UIScrollView?
    private weak var vc: UIViewController?
    private var dummiForAddition: PhotoViewCell?
    weak var delegate: DelegateReloadData?
    private var tempCellForDelete: BoxPhoto?
    private var delegateShowPhoto: DelegatePresenterPhoto?
    
    
    init(scroll: UIScrollView, vc: UIViewController) {
        super.init()
        self.vc = vc
        self.scroll = scroll
        
       removeAll()
        
        let vcToDelegate = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerPresenterImage") as! ViewControllerPresenterImage
        vcToDelegate.modalPresentationStyle = .fullScreen
        self.delegateShowPhoto = vcToDelegate
       
        reloadFrame()
    }
    
    private func checkState() {
        if self.imagesView.count == 5 {
            self.dummiForAddition?.removeFromSuperview()
            self.dummiForAddition = nil
        } else if self.imagesView.count < 5 && self.dummiForAddition == nil {
            self.dummiForAddition = PhotoViewCell()
            self.scroll?.addSubview(self.dummiForAddition!)
            dummiForAddition?.imageView?.image = UIImage(named: "new_photo")
            
            self.dummiForAddition!.handler = {_ in
                self.tempCellForDelete?.photoView?.removeFromSuperview()
                self.tempCellForDelete?.image = nil
                self.tempCellForDelete = nil
                ImagePicker(delegateView: self, vc: self.vc).openSourceToGetImages(self.dummiForAddition)
            }
        }
    }
    
    func replacingCell(image: Data, index: Int) {
        self.deleteCell(image: self.tempCellForDelete!.image!)
        self.addNewCell(image: image, indexMy: index)
        self.tempCellForDelete?.photoView?.removeFromSuperview()
        self.tempCellForDelete = nil
    }
    

    
    func addNewCell(image: Data, indexMy: (Int?) = nil) {
        
        let index = indexMy ?? imagesView.count
        let photo = PhotoViewCell()
        
        photo.imageView?.image = UIImage(data: image)
        imagesView.insert(BoxPhoto(image: image, photoView: photo), at: index)
        
        // обработчик зажатия или тапа
        photo.handler = { [weak self] (long) in
            if long {
                self!.tempCellForDelete = BoxPhoto(image: image, photoView: photo)
                ImagePicker(delegateView: self, vc: self!.vc).openSourceToGetImages(nil, delete: {
                    self!.deleteCellAnimated(image: image)
                })
            } else {
                
                self!.vc?.present((self!.delegateShowPhoto as! ViewControllerPresenterImage), animated: false, completion: {})
            }
            
         // передаем данные в view controller для показа фото
            
            var array: [UIImage] = []
            let tempIndex = self!.imagesView.firstIndex(where: {(img) -> Bool in
                image == img.image
            })
            
            for img in self!.imagesView {
                array.append(UIImage(data: img.image!)!)
            }
            self!.delegateShowPhoto?.setImagesArray(arrayImage: array, indexCurrent: tempIndex ?? 0)
        }
        
        self.scroll?.addSubview(photo)
        
        reloadFrame()
    }
    
    
    func removeAll() {
        
        
        
        for view in scroll!.subviews {
            view.removeFromSuperview()
        }
        
        if imagesView.count>0 {
            imagesView.removeAll()
        }

        
        if delegate != nil {
            delegate?.updateData()
        }
    }
    
    
    func deleteCellAnimated(image: Data) {
        
        let index = imagesView.firstIndex { (imgPhoto) -> Bool in
            image == imgPhoto.image
        }
        
        let point = self.imagesView[index!].photoView?.center
        UIView.animate(withDuration: 0.2, animations: {
            self.imagesView[index!].photoView?.frame = CGRect(origin: point!, size: CGSize.zero)
        }) { (complete) in
            
            if index != nil {
                self.imagesView[index!].photoView?.removeFromSuperview()
                self.imagesView.remove(at: index!)
            }
            
            self.tempCellForDelete?.photoView?.removeFromSuperview()
            self.tempCellForDelete?.image = nil
            self.tempCellForDelete = nil
            
            if self.delegate != nil {
                self.delegate?.updateData()
            }
            
            self.reloadFrame()
        }
    }
    
    
    func deleteCell(image: Data) {
        
        let index = imagesView.firstIndex { (imgPhoto) -> Bool in
            image == imgPhoto.image
        }
        
        if index != nil {
            self.imagesView[index!].photoView?.removeFromSuperview()
            self.imagesView.remove(at: index!)
        }
        
        self.tempCellForDelete?.photoView?.removeFromSuperview()
        self.tempCellForDelete?.image = nil
        self.tempCellForDelete = nil
        
        if self.delegate != nil {
            self.delegate?.updateData()
        }
        
        self.reloadFrame()
    }
    
    func reloadFrame() {
        
        self.checkState()
        
        UIView.animate(withDuration: 0.3) {
            for i in 0..<self.imagesView.count {
                
                self.imagesView[i].photoView?.frame = CGRect(x: i.toCGFloat() * (self.scroll!.frame.height + 10),
                                                        y: 0,
                                                        width: self.scroll!.frame.height,
                                                        height: self.scroll!.frame.height)
            }
            
            if self.dummiForAddition != nil {
                self.dummiForAddition?.frame = CGRect(x: self.imagesView.count.toCGFloat()  * (self.scroll!.frame.height + 10),
                                                 y: 0,
                                                 width: self.scroll!.frame.height,
                                                 height: self.scroll!.frame.height)
            }
        }
        
       
        
        
        self.scroll?.contentSize.width = (self.scroll!.frame.height + 10) * (self.imagesView.count +  (self.dummiForAddition != nil ? 1 : 0)).toCGFloat()
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
           return
        }
        
        UIApplication.shared.keyWindow?.rootViewController!.dismiss(animated: false, completion: nil)
        getImage(image: image, compressionQuality: 0.1) {(Bool) in}
    }
    
    func getImage(image: UIImage, compressionQuality: CGFloat, completion: (_ load: Bool) -> Void) {
        
        if tempCellForDelete != nil {
            let index = self.imagesView.firstIndex {(img) -> Bool in
                tempCellForDelete?.image == img.image
            }
            self.replacingCell(image: image.jpegData(compressionQuality: compressionQuality)!, index: index!)
        } else {
            self.addNewCell(image: image.jpegData(compressionQuality: compressionQuality)!)
        }
       
        self.reloadFrame()
        
        if delegate != nil {
            delegate?.updateData()
        }
        
        completion(true)
    }
    
    
}
