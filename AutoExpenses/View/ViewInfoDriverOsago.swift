//
//  ViewInfoDriverOsago.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 16/05/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewInfoDriverOsago: UIView {

    var headerLabel: UILabel?
    var scrollDrivers: UIScrollView?
    var arrayDrivers: [ViewInfoOsago] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    func initialization() {
        self.backgroundColor = .gray
        
        headerLabel = UILabel()
        headerLabel?.font = UIFont(name: headerLabel!.font.fontName, size: 12)
        headerLabel?.textColor = .white
        
        scrollDrivers = UIScrollView()
        
        self.addSubview(headerLabel!)
        self.addSubview(scrollDrivers!)
        
//        UserAuthorization.sharedInstance.getParsingDatePolicyOsagoToKey(key: "drivers") {(arrayDictonary) in
//            for driverDictonary in arrayDictonary as! [Dictionary<String,Any>] {
//                let fullName = driverDictonary["fullName"] ??  "Нет данных"
//                let driverLicenseSeries = driverDictonary["driverLicenseSeries"] ??  "Нет данных"
//                let driverLicenseNumber = driverDictonary["driverLicenseNumber"] ??  "Нет данных"
//                
//                DispatchQueue.main.async {
//                    
//                    let viewDriver = ViewInfoOsago()
//                    viewDriver.headerLabel?.text = (fullName as! String)
//                    viewDriver.infoLabel?.text = "Серия:  \((driverLicenseSeries as! String)) Номер:  \(driverLicenseNumber as! String)"
//                    
//                    self.arrayDrivers.append(viewDriver)
//                    self.scrollDrivers!.addSubview(viewDriver)
//                    
//                   viewDriver.loadingIndicator?.stopAnimating()
//                    
//                    self.setNeedsDisplay()
//                }
//            }
//        }
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.headerLabel?.frame = CGRect(x: 8,
                                         y: 0,
                                         width: rect.width * 0.5  + 4,
                                         height: rect.height * 0.3)
    
        self.scrollDrivers?.frame = CGRect(x: 0,
                                       y: self.headerLabel!.bounds.height,
                                       width: rect.width,
                                       height: rect.height - self.headerLabel!.frame.height)
        
        // расстановка фреймов
        
        
        for viewDriver in self.arrayDrivers  {
            let index = self.arrayDrivers.firstIndex(of: viewDriver)
            viewDriver.frame = CGRect(x: 0,
                                      y: self.scrollDrivers!.frame.height * index!.toCGFloat(),
                                      width: self.scrollDrivers!.frame.width,
                                      height: self.scrollDrivers!.frame.height)
            
//            UserAuthorization.sharedInstance.getParsingDatePolicyOsagoToKey(key: "drivers") { (arrayDictonary) in
//                DispatchQueue.main.async {
//                    let driverDictonary = (arrayDictonary as! [Dictionary<String,Any>])[index!]
//                    
//                    let driverLicenseSeries = driverDictonary["driverLicenseSeries"] ??  "Нет данных"
//                    let driverLicenseNumber = driverDictonary["driverLicenseNumber"] ??  "Нет данных"
//                    
//                    
//                    viewDriver.headerLabel?.text = driverDictonary["fullName"] as? String ?? "Нет данных"
//                    viewDriver.infoLabel?.text = "Серия:  \((driverLicenseSeries as! String)) Номер:  \(driverLicenseNumber as! String)"
////                    viewDriver.loadingIndicator?.stopAnimating()
//                }
//            }
        }
        
        self.scrollDrivers?.contentSize = CGSize(width: self.scrollDrivers!.frame.size.width, height: self.scrollDrivers!.frame.size.height * self.arrayDrivers.count.toCGFloat())
    }

}
