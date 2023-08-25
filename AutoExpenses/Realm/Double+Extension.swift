//
//  Double+Extension.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/08/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
extension Double {
    
    func roundTo(places: Int) -> Double {
//        let divisor = pow(10.0, Double(places))
        return self// Double(roundl(Float80((self) * Float80(divisor))) / divisor)
    }
    
    func toString() -> String {
        return String(self)
    }
    
    func toString(_ str: String) -> String {
        return String("\(self) \(str)")
    }
}
