//
//  PhotoView.swift
//  GenerateFieldsToEnter
//
//  Created by Evgeniy on 17/07/2019.
//  Copyright © 2019 Evgeniy. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoViewCell: UIView {

    var imageView: UIImageView?
    var handler: ((_ longTap: Bool) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        imageView?.frame = rect
    }
    
    func initialization() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        imageView = UIImageView()
        imageView?.isUserInteractionEnabled = false
        imageView?.contentMode = .scaleAspectFill
        self.addSubview(imageView!)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
//        let forceTouch = ForceGestureRecognizer(target: self, action: #selector(forcePress(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(longPressGesture)
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tap() {
        self.handler!(false)
    }
    
    
    @objc private func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            self.handler!(true)
        }
    }
}

