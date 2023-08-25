//
//  ViewControllerThemeColor.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 11/09/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewControllerThemeColor: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //TODO: for iOS 13 working with color
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
//        
//        if #available(iOS 13.0, *) {
//            if responds(to: #selector(getter: UIView.overrideUserInterfaceStyle)) {
//                setValue(UIUserInterfaceStyle.light.rawValue,
//                         forKey: "overrideUserInterfaceStyle")
//            }
//        }
        
        // Do any additional setup after loading the view.
    }
}
