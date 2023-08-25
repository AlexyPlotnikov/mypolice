//
//  PhotoAutoView.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 13/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

//MARK: delegate image in source
protocol DelegateImagePicker: NSObjectProtocol {
    func getImage(image: UIImage, compressionQuality: CGFloat, completion: (_ load: Bool) -> Void)
}

//MARK: Class get image from sources
class PhotoView : UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DelegateImagePicker {
    
    var imagePicker: ImagePicker?
    var imageView: UIImageView?
    var buttonAddPhoto: UIButton?
    private var rectShape: CAShapeLayer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    func initialization() {
        
        if self.imagePicker == nil {
            self.imagePicker = ImagePicker(delegateView: self, vc: LocalDataSource.headViewController)
        }
        
        if self.imageView == nil {
            self.imageView = UIImageView()
            self.imageView!.contentMode = .scaleAspectFill
            self.addSubview(self.imageView!)
        }
        
        if self.buttonAddPhoto == nil {
            self.buttonAddPhoto = UIButton()
            self.buttonAddPhoto!.addTarget(self, action: #selector(selectSources(_:)), for: .touchUpInside)
            self.addSubview(self.buttonAddPhoto!)
        }
        
        if self.rectShape == nil {
            self.rectShape = CAShapeLayer()
        }
    }
    
    func setImage(index: Int) {
        let entity = AvatarAuto(index: index)
        self.imageView?.image = entity.photoImage
        self.imageView!.contentMode = .scaleToFill
    }
    
    override func draw(_ rect: CGRect) {
        self.imageView?.frame = rect
        self.buttonAddPhoto?.frame = rect
        
        //        self.rectShape!.bounds = self.frame
        //        self.rectShape!.position = self.center
        //        self.rectShape!.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 14, height: 14)).cgPath
        //        self.layer.mask = rectShape
        self.imageView!.contentMode = .scaleToFill
    }
    
    @objc private func selectSources(_ sender: UIButton) {
        self.imagePicker?.viewController = LocalDataSource.headViewController
        self.imagePicker!.openSourceToGetImages(sender)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        guard let image = info[.originalImage] as? UIImage else {
            return
        }

        
        LocalDataSource.headViewController.dismiss(animated: false, completion: nil)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewControllerEditPhoto = storyboard.instantiateViewController(withIdentifier: "viewControllerEditPhoto") as! ViewControllerEditPhoto
        viewControllerEditPhoto.photo = AvatarAuto(size: self.bounds.size, photo : image)
        viewControllerEditPhoto.delegateImagePicker = self
        viewControllerEditPhoto.modalPresentationStyle = .fullScreen
        
        LocalDataSource.headViewController.present(viewControllerEditPhoto, animated: true, completion: nil)
    }
    
    func getImage(image: UIImage, compressionQuality: CGFloat, completion: (_ load: Bool) -> Void) {
        
        imagePicker?.photo?.photoImage = image
        self.imageView?.image = image
        
        let entity = AvatarAuto()
        entity.id = LocalDataSource.identificatorUserCar
        entity.imageData = image.jpegData(compressionQuality: compressionQuality)!
        entity.addData()
        completion(true)
    }
    
}

//MARK: Category for screenshot to view


func getImage(image: UIImage, compressionQuality: CGFloat, completion: (Bool) -> Void) {
    
}
