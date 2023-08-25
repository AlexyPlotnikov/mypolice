//
//  ViewHealthNeedToServe.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 19.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

protocol DelegateOpenAdditionalScreen: class {
    func openAlert(_ panelProtocol: PanelDropForWriteProtocol)
    func closeAlert()
    func openScreen(_ vcForOpen: UIViewController)
}

class ViewWearBig: ViewWearBase {
    
    var headerLabel: UILabel!
    var wearToMileage: ViewShowWear!
    var imageView: UIImageView?
    var buttonWriteService: UIButton?
    
    // need rewrite
    private var color: UIColor?
    
    override init(delegate: DelegateOpenAdditionalScreen?, model: ModelTimeAndMileageWear?) {
        super.init(delegate: delegate, model: model)
        self.color = model?.modelTime.color
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        headerLabel = UILabel()
        headerLabel.isUserInteractionEnabled = true
        headerLabel.backgroundColor = self.color
        headerLabel.textColor = .white
        headerLabel!.font = UIFont(name: "SFProDisplay-Bold", size: 26)
        headerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(functionOpenAlertList)))
        self.addSubview(headerLabel!)
      
        imageView =  UIImageView()
        imageView?.image = UIImage(named: "info_button")
        imageView?.contentMode = .scaleAspectFit
        self.addSubview(imageView!)
        
//        let wearTime = ViewShowWear()
//        wearToTime = wearTime
//        self.addSubview(wearToTime)
        
        wearToMileage = ViewShowWear()
        wearToMileage.textHeader?.text = "Осталось"
        self.addSubview(wearToMileage)
        
//        let button = UIButton()
//        buttonWriteService = button
//        buttonWriteService?.setTitle("Записаться на сервис", for: .normal)
//        buttonWriteService?.setImage(UIImage(named: "arrow_up"), for: .normal)
//        buttonWriteService?.setTitleColor(UIColor.init(rgb: 0x151515), for: .normal)
//        buttonWriteService?.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 12)
//        buttonWriteService?.contentMode = .left
//        buttonWriteService?.addTarget(self, action: #selector(functionOpenScreen), for: .touchUpInside)
//        self.addSubview(buttonWriteService!)
    }

    @objc func functionOpenAlertList() {
        
        delegate?.openAlert(PanelDropForWriteFromListWork(delegate: delegate!, model: self.model!))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
//        let widthLine: CGFloat = 1
        
//        if lineHorizontal == nil {
//            let lineH = DrawLine(view: self, setting:
//                SettingDrawLine(pointStart:
//                    CGPoint(x: 0,
//                            y: headerLabel!.frame.height - widthLine), pointEnd:
//                    CGPoint(x: self.frame.width,
//                            y: headerLabel!.frame.height - widthLine),
//                                                                       color: UIColor.init(rgb: 0xDADADA),
//                                                                       lineWidth: widthLine))
//            lineHorizontal = line
//            lineH.drawLine()
//        }
        
//        if lineCenter == nil {
//            let lineC = DrawLine(view: self, setting: SettingDrawLine(pointStart:
//                CGPoint(x: self.frame.width * 0.5,
//                        y: wearToMileage!.frame.minY + 29.5), pointEnd:
//                CGPoint(x: self.frame.width * 0.5,
//                        y: wearToMileage!.frame.maxY - 20.5),
//                                                           color: UIColor.init(rgb: 0xDADADA), lineWidth: widthLine))
//            lineCenter =  line
//            lineC.drawLine()
//        }
        
//        if lineFooter == nil {
//            let lineF = DrawLine(view: self, setting: SettingDrawLine(pointStart:
//                CGPoint(x: 0,
//                        y: buttonWriteService!.frame.origin.y), pointEnd:
//                CGPoint(x: self.frame.width,
//                        y: buttonWriteService!.frame.minY),
//                                                           color: UIColor.init(rgb: 0xDADADA), lineWidth: widthLine))
//            lineFooter = line
//            lineF.drawLine()
//        }
        
        wearToMileage.textHeader?.textColor = .black
        wearToMileage.textHeader?.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        wearToMileage?.textHeader?.text = "Пора посетить автосервис"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
          
        let heightHeader: CGFloat = 75
        
        headerLabel?.frame = CGRect(x: 0,
                                    y: 0,
                                    width: self.frame.width,
                                    height: heightHeader)
        
      
        imageView?.frame = CGRect(x: self.frame.width - 38 - 14,
                                  y: headerLabel.frame.midY - 38 * 0.5,
                                  width: 38,
                                  height: 38)
        
        
        let heightCenter = self.frame.height - heightHeader
        wearToMileage?.frame  = CGRect(x: 0,
                                       y: headerLabel!.frame.maxY + 13,
                                       width: self.frame.width - 0.5,
                                       height: heightCenter)
        
//        wearToTime?.frame  = CGRect(x: wearToMileage!.frame.maxX + 1,
//                                    y: headerLabel!.frame.maxY,
//                                    width: self.frame.width * 0.5 - 0.5,
//                                    height: heightCenter)
        
//        let footerHeight = self.frame.height - (heightHeader + heightCenter)
//        buttonWriteService?.frame = CGRect(x: 14, y: self.frame.height - footerHeight, width:  self.frame.width - 14, height: footerHeight)
//        buttonWriteService?.imageEdgeInsets.left = buttonWriteService!.frame.width - buttonWriteService!.imageView!.frame.width
//        buttonWriteService?.titleEdgeInsets.left = -(buttonWriteService!.frame.width - buttonWriteService!.titleLabel!.frame.width)
    }
    
}
