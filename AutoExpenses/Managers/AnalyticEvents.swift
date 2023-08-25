//
//  AnalyticEvents.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 09/09/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class AnalyticEvents {
    
    static func logEvent(_ typeLog: AlanyticModelKey.TypeKey, params: (Dictionary<String, String>?)=nil) {
        if params == nil {
            Flurry.logEvent(typeLog.rawValue)
        } else {
            Flurry.logEvent(typeLog.rawValue, withParameters: params)
        }
    }
    
}
