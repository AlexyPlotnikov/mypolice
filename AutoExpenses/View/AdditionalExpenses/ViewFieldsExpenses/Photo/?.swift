//
//  PhotoExpenses.swift
//  GenerateFieldsToEnter
//
//  Created by Evgeniy on 17/07/2019.
//  Copyright © 2019 Evgeniy. All rights reserved.
//

import UIKit

struct ImageView {
    var image: Data?
    var photoView: PhotoViewCell?
    
}

class PhotoExpenses: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DelegateImagePicker {
    
    private var imagePicker: ImagePicker
    private var imagesView: [ImageView] = []
    private var scroll: UIScrollView?
    
    init(scroll: UIScrollView) {
        self.scroll = scroll
    }
    
    func loadPhotos()  {

        for _ in 0..<imagesView.count + 1 {
            self.addNewCell(image: UIImage(named: "new_photo")!.pngData()!)
        }
    }
    
    func replaceImageinCell(image: Data, index: Int) {
        self.imagesView[index].image = image
        // save data base
    }
    
  
    func addNewCell(image: Data) {
        
        let index = imagesView.count > 1 ? imagesView.count - 2 : 0
        let photo = PhotoViewCell()
        photo.imageView?.image = image.isEmpty ? UIImage(named: "new_photo") : UIImage(data: image)
        
        imagesView.insert(ImageView(image: image, photoView: photo), at: index)
        
        self.scroll?.addSubview(photo)
        self.scroll?.contentSize.width += (self.scroll!.frame.height+10)
        
//        photo.button?.addTarget(self, action: #selector(click), for: .touchUpInside)
        
        reloadFrame()
    }
    
    func deleteCell(image: Data) {
        let index = imagesView.firstIndex { (imgPhoto) -> Bool in
            image == imgPhoto.image
        }
        
        if index != nil {
            imagesView.remove(at: index!)
            reloadFrame()
        }
    }
    
    func reloadFrame() {
        for i in 0..<imagesView.count {
            imagesView[i].photoView?.frame = CGRect(x: i.toCGFloat() * (self.scroll!.frame.height+10),
                                                    y: 0,
                                                    width: self.scroll!.frame.height,
                                                    height: self.scroll!.frame.height)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
        UIApplication.shared.keyWindow?.rootViewController!.dismiss(animated: false, completion: nil)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewControllerEditPhoto = storyboard.instantiateViewController(withIdentifier: "viewControllerEditPhoto") as! ViewControllerEditPhoto
//        viewControllerEditPhoto.photo = AvatarAuto(size: self.bounds.size, photo : image)
        viewControllerEditPhoto.delegateImagePicker = self
        getImage(image: image) { (Bool) in
            
        }
        UIApplication.shared.keyWindow?.rootViewController!.present(viewControllerEditPhoto, animated: true, completion: nil)
    }
    
    func getImage(image: UIImage, completion: (_ load: Bool) -> Void) {
        
        self.addNewCell(image: image.jpegData(compressionQuality: 0.5)!)
        self.reloadFrame()
        
//        let entity =
//        entity.id = LocalDataSource.identificatorUserCar
//        entity.imageData = image.jpegData(compressionQuality: 1.0)!
//        entity.addData()
        completion(true)
    }
    
    
}
