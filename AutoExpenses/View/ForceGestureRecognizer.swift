//
//  ForceGestureRecognizer.swift
//  ForceTest
//
//  Created by Victor Baro on 17/10/2015.
//  Copyright © 2015 Produkt. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class ForceGestureRecognizer: UIGestureRecognizer {
    
    var forceValue: CGFloat = 0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        state = .began
        handleForceWithTouches(touches: touches)
    }
    
 override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        state = .changed
       handleForceWithTouches(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = .ended
        handleForceWithTouches(touches: touches)
    }
    
    func handleForceWithTouches(touches: Set<UITouch>) {
        if touches.count != 1 {
            state = .failed
            return
        }
        
        guard let touch = touches.first else {
            state = .failed
            return
        }
        forceValue = touch.force
    }
}
