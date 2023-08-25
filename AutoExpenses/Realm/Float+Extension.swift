//
//  Image.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/06/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import UIKit

// MARK: Категория для Float
extension Float {
    
    func toStringIntegerValue() -> String {
        return String(Int(self))
    }
    
    func toString() -> String {
        return self.truncatingRemainder(dividingBy: 1) <= 0 ? String(format: "%.0f", self) : String(self)
    }
    
    func toString(_ str: String) -> String {
        return self.truncatingRemainder(dividingBy: 1) <= 0 ? String(format: "%.0f %@", self, str) : "\(self) \(str)"
    }
    
    func roundTo(places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return roundf(self * divisor) / divisor
    }
    
    func roundToZero() -> Float {
        let divisor = pow(10.0, Float(0))
        return roundf(self * divisor) / divisor
    }
    
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
    
    func fromFloatSetFormatToString(format: String) -> String {
        return String(format: format, self)
    }    
}
