//
//  PresentPhotoFullScreen.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 01/08/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class PresentPhotoFullScreen: NSObject {
    
    private var array: [UIImageView] = []
    private var scroll: UIScrollView?
    private var viewParent: UIView?
    private var indexCurrent: Int = 0
    
    init(array: [UIImage], viewParent: UIView, indexCurrent: Int) {
        super.init()
        self.viewParent = viewParent
        self.indexCurrent = indexCurrent
        self.scroll = UIScrollView(frame: self.viewParent!.bounds)
        self.viewParent?.addSubview(self.scroll!)
        self.scroll?.backgroundColor = .black
        self.scroll?.bouncesZoom = true
        self.scroll?.maximumZoomScale = 10
        self.scroll?.isPagingEnabled = true
        self.scroll?.delegate = self
       
        for img in array {
            let index: CGFloat = array.firstIndex(of: img)?.toCGFloat() ?? 0
            let imgView = UIImageView(frame: CGRect(x: index * self.viewParent!.bounds.width,
                                                    y: (self.viewParent!.frame.height * 0.2) * 0.5,
                                                    width: self.viewParent!.bounds.width,
                                                    height: self.viewParent!.frame.height - self.viewParent!.frame.height * 0.2))
            imgView.contentMode = .scaleAspectFit
            imgView.image = img
            self.scroll!.addSubview(imgView)
            self.array.append(imgView)
        }
    }
    
    func presentPhoto() {
        
       self.scroll?.alpha = 0
       self.scroll?.contentSize = CGSize(width: viewParent!.frame.width * self.array.count.toCGFloat(), height: viewParent!.frame.height)
        self.scroll?.contentOffset.x = viewParent!.frame.width * self.indexCurrent.toCGFloat()
        print(self.indexCurrent)
        UIView.animate(withDuration: 0.3) {
            self.scroll?.alpha = 1
        }
    }
    
    func hiddenPhoto() {
        self.array.removeAll()
        self.scroll?.removeFromSuperview()
    }
}

extension PresentPhotoFullScreen: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let x = self.scroll!.contentOffset.x
        let w = self.scroll!.bounds.size.width
        self.indexCurrent = Int(x/w)
        
    }

}
