//
//  Image.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/06/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    func toString(format: (String?)=nil) -> String {
        print(self)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        formatter.dateFormat = format ?? "dd MMMM yyyy"
        let myString = formatter.string(from: self) // string purpose I add here
        return myString
    }
    
}
