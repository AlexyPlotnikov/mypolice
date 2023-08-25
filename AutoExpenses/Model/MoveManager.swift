//
//  MoveManager.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 28.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import UIKit

struct ModelViewMove {
    var viewForMove: UIView?
    var viewBack: UIView?
    var startPoint: CGPoint?
}

class MoveManager: NSObject {
    
    private var modelForMove: ModelViewMove?
    
    init(modelForMove: ModelViewMove) {
        super.init()
        
        self.modelForMove = modelForMove
        let gesture = UIPanGestureRecognizer(target: modelForMove.viewForMove!, action: #selector(wasDragged(_:)))
        self.modelForMove!.viewForMove!.addGestureRecognizer(gesture)
    }
    
    @objc private func wasDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
            if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: modelForMove?.viewForMove)

            if (gestureRecognizer.view!.center.y > modelForMove!.startPoint!.y) {
                    gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + translation.y / 2)

                if (gestureRecognizer.view!.center.y > (modelForMove!.startPoint!.y + modelForMove!.viewForMove!.frame.height * 0.6)) {
                    gestureRecognizer.state = .cancelled
                    controllPanel(state: false)
                }
            }

                if (modelForMove!.viewForMove!.frame.origin.y < modelForMove!.startPoint!.y || gestureRecognizer.state == .ended) {
                    gestureRecognizer.state = .cancelled
                    controllPanel(state: true)
                }

            } else if gestureRecognizer.state != .cancelled {
                controllPanel(state: true)
            }
           
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: modelForMove!.viewForMove!)
    }
    
    func controllPanel(state: Bool) {
        returnView(state: state, callback: {
            
        })
    }

    
    
    
    private func returnView(state: Bool, callback: @escaping (() -> Void)) {
        
        let point = state ? CGPoint(x: 0, y: modelForMove!.startPoint!.y) : CGPoint(x: 0, y: modelForMove!.viewBack!.frame.height)
        UIView.animate(withDuration: 0.15, animations: {
            self.modelForMove!.viewForMove!.frame.origin = point
            self.modelForMove!.viewBack?.alpha = state ? 1 : 0
        }) {(state) in

        }
    }
}


