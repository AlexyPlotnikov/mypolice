//
//  ViewAlertScreen.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 27.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewAlertScreen: UIView {

    private var alertView: ViewPanelAlertBase?
    private var pointStart: CGPoint?
    private weak var delegate: DelegateOpenAdditionalScreen?
    
    init(frame: CGRect, alertView: ViewPanelAlertBase, delegate: DelegateOpenAdditionalScreen) {
        super.init(frame: frame)
        setup(frame: frame, alertView: alertView, delegate: delegate)
    }
    
    deinit {
        print("deinit ViewAlertScreen")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func getView() -> UIView {
        return alertView!
    }
    
    private func setup(frame: CGRect, alertView: ViewPanelAlertBase, delegate: DelegateOpenAdditionalScreen) {
        
        self.delegate = delegate
        
        self.alertView = alertView
        self.alertView?.button?.addTarget(self, action: #selector(write), for: .touchUpInside)
        
        self.pointStart = CGPoint(x: 0, y: frame.height - alertView.frame.height)
        self.addSubview(self.alertView!)
        
        self.alpha = 0
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        let gestureMove = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(_:)))
        self.alertView!.addGestureRecognizer(gestureMove)
        
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(tapBackScreen))
        self.addGestureRecognizer(gestureTap)
    }
    
    @objc private func write() {
        closeView {
            self.delegate?.openScreen(StationTechnicalService().viewControllerForOpen!)
        }
    }
    
    @objc private func tapBackScreen() {
        closeView()
    }
    
    func showView(_ callback: (() -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 1
        }) {[weak self] (complete)  in
            UIView.animate(withDuration: 0.15, animations: {
                
                self?.alertView?.frame.origin.y = self?.pointStart!.y ?? 0
                
            }) { (complete)  in
                callback?()
            }
        }
    }
    
    func closeView(_ callback: (() -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.15, animations: {
            
            self.alertView?.frame.origin.y = self.frame.height
            
        }) {[weak self] (complete)  in
            
            UIView.animate(withDuration: 0.15, animations: {
                
                self?.alpha = 0
                
            }) {[weak self] (complete)  in
                self?.removeFromSuperview()
                self?.pointStart = nil
                callback?()
            }
        }
    }
    
    

    @objc private func wasDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
              if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                      
                  let translation = gestureRecognizer.translation(in: alertView!)
                       
              if (gestureRecognizer.view!.center.y > pointStart!.y) {
                      gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + translation.y / 2)

                  if (gestureRecognizer.view!.center.y > (pointStart!.y + alertView!.frame.height * 0.8)) {
                      gestureRecognizer.state = .cancelled
                    closeView()
                  }
              }

                  if (alertView!.frame.origin.y < pointStart!.y || gestureRecognizer.state == .ended) {
                      gestureRecognizer.state = .cancelled
                      showView()
                  }

              } else if gestureRecognizer.state != .cancelled {
                  showView()
              }
             
              gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: alertView)
      }
    

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    

}
