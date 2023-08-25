//
//  ViewControllerEditPhoto.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 13/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

//MARK: class View controller edit photo
class ViewControllerEditPhoto: ViewControllerThemeColor, UIScrollViewDelegate {
    
    var delegateImagePicker : DelegateImagePicker?
    var viewFieldCut: UIView?
    var imageViewPhoto: UIImageView?
    var photo : AvatarAuto!
    var scroll: UIScrollView?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
 
        if photo != nil && imageViewPhoto == nil {
            // size to view fade
            let sizeBackAlpha = CGSize(width: self.view.frame.width,
                                       height: self.view.frame.height * 0.5 - (photo.sizeViewToPhoto.height) * 0.5)
            
            // array positions for fade top and bottom
            let arrayPosBack = [CGPoint.zero, CGPoint(x: 0,
                                                  y: self.view.frame.height - sizeBackAlpha.height)]
            
            // view for cut off image
            self.viewFieldCut = UIView(frame: CGRect(x: 0,
                                                     y: sizeBackAlpha.height,
                                                     width: (photo.sizeViewToPhoto.width),
                                                     height: (photo.sizeViewToPhoto.height)))
            
          
            self.imageViewPhoto = UIImageView(frame: CGRect(origin: CGPoint(x: 0,
                                                                            y: 0),
                                                            size:  self.view.bounds.size))
            
//            self.imageViewPhoto!.frame.origin = CGPoint(x: 0, y:(self.viewFieldCut?.frame.midY)! - self.imageViewPhoto!.frame.height*0.5)
            self.scroll = UIScrollView(frame: CGRect(x: 0,
                                                     y: self.viewFieldCut!.bounds.midY - self.view.frame.height * 0.5,
                                                     width: self.view.frame.width,
                                                     height: self.view.frame.height))
            
            
//            self.scroll?.contentSize = self.view.frame.size
            self.scroll?.alwaysBounceVertical = true
            self.scroll?.alwaysBounceHorizontal = true
            
            self.view.addSubview(self.viewFieldCut!)
            self.viewFieldCut!.addSubview(scroll!)
            self.scroll!.addSubview(self.imageViewPhoto!)
            
            
         
            //create fade top and bottom
            for i in 0..<arrayPosBack.count {
                let blurEffect = UIBlurEffect(style: .dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = CGRect(origin: arrayPosBack[i], size: sizeBackAlpha)
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.view.addSubview(blurEffectView)
            }
            
//            hidden interactble all view
            for view in self.view.subviews {
                view.isUserInteractionEnabled = view is UIScrollView || view == self.viewFieldCut!
            }
            
            //button for cut off image to mask
            let buttonCut = UIButton(frame: CGRect(x: self.view.frame.width * 0.5,
                                                   y: self.view.frame.height - self.view.frame.height * 0.1,
                                                   width: self.view.frame.width * 0.5,
                                                   height: self.view.frame.height * 0.1))
            buttonCut.setTitle("Обрезать", for: .normal)
            buttonCut.backgroundColor = UIColor.clear
            buttonCut.addTarget(self, action: #selector(cutView), for: .touchUpInside)
            self.view.addSubview(buttonCut)
            
            //button for cancel
            let buttonCancel = UIButton(frame: CGRect(x: 0,
                                                   y: self.view.frame.height - self.view.frame.height * 0.1,
                                                   width: self.view.frame.width * 0.5,
                                                   height: self.view.frame.height * 0.1))
            buttonCancel.setTitle("Отмена", for: .normal)
            buttonCancel.backgroundColor = UIColor.clear
            buttonCancel.addTarget(self, action: #selector(cancel), for: .touchUpInside)
            self.view.addSubview(buttonCancel)
            
            // double tap
            let tapGestureRecognizer = UITapGestureRecognizer()
            tapGestureRecognizer.numberOfTapsRequired = 2
            tapGestureRecognizer.addTarget(self, action: #selector(imageViewDoubleTapped))
            scroll!.addGestureRecognizer(tapGestureRecognizer)
            
            scroll!.delegate = self
            scroll!.bouncesZoom = true
            scroll!.minimumZoomScale = 1
            scroll!.maximumZoomScale = 10
        
        }
        
        imageViewPhoto?.contentMode = .scaleAspectFit
        imageViewPhoto!.image = photo.photoImage
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewPhoto!
    }
    
    @objc func imageViewDoubleTapped() {
        if scroll!.zoomScale > scroll!.minimumZoomScale {
            scroll!.setZoomScale(scroll!.minimumZoomScale, animated: true)
        } else {
            scroll!.setZoomScale(scroll!.maximumZoomScale, animated: true)
        }
    }

     // func for cut off
    @objc func cutView() {
       
       let indicator = UIActivityIndicatorView(frame: self.view.bounds)
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        self.delegateImagePicker?.getImage(image: self.viewFieldCut!.screenshot(self.imageViewPhoto!, scale: (10/scroll!.zoomScale)/10), compressionQuality: 0.5, completion: { (state) in
                if state {
                    
                    // TODO: Analytics
                    AnalyticEvents.logEvent(.AddedPhotoAuto)
                    
                    self.dismiss(animated: true, completion: {
                         indicator.stopAnimating()
                        indicator.removeFromSuperview()
                    })
                    
                }
            })
        }
    
    // func for cancel
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIView {
    
    func screenshot(_ view: UIView, scale: CGFloat) -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions (view.frame.size, false, scale)
        
        // Draw view in that context
        drawHierarchy(in: view.frame, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return image ?? UIImage()
    }
}
