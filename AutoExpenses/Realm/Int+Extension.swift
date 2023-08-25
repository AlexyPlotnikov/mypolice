//
//  Image.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/06/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    func secondsToHoursMinutesSeconds() -> String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func toHoursConverted() -> Int {
        let hours = Int(self) / 3600
//        let minutes = Int(self) / 60 % 60
//        let seconds = Int(self) % 60
        return hours
    }
    
    func toMinutesConverted() -> Int {
        let minutes = Int(self) / 60 % 60
        return minutes
    }
    
    func toSecondsConverted() -> Int {
        let seconds = Int(self) % 60
        return seconds
    }
    
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    
    func toString() -> String {
        return String(self)
    }
    
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
    
    func toString(_ str: String) -> String {
        return String("\(self) \(str)")
    }
    
    func dayBeetweenTwoDates(startDate: Date, endDate: Date) -> Int? {
        
        let calendar = Calendar.current

        let components = calendar.dateComponents([.day], from: startDate, to: endDate)

        return components.day
    }
}
