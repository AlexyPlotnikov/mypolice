//
//  Font+Extension.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 19/08/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

extension UIFont {
    func fontForHeader(widthFrame: CGFloat) -> UIFont {
        return UIFont(name:"SFUIDisplay-Bold",size: (widthFrame * 2.3) / 40)!
    }
    
    func fontForHeaderIpad(widthFrame: CGFloat) -> UIFont {
        return UIFont(name:"SFUIDisplay-Bold",size: (widthFrame * 2.5) / 50)!
    }
    
    func toBold()->UIFont {
        return UIFont.boldSystemFont(ofSize: self.pointSize)
    }
}
