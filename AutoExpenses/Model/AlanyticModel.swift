//
//  AlanyticModel.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 09/09/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation


internal struct AnalyticParams {
    var key: String
    var params: Dictionary<String, String>
}

class AlanyticModelKey {
    
    enum TypeKey: String {
        
        // Open ViewController
        case OpenScanerQRCode
        case OpenApplication
        case OpenListExpenses
        case OpenEditionExpense
        case OpenServices
        case OpenPolicy
        case OpenAutoInformation
        case OpenAuthorization
        case OpenParts
        
        // Add data
        case AddedNameAuto
        case AddedPhotoAuto
        case AddedTimeParking
        case AddedMileage
        case AddedNewExpense
        case AddedNewExpenseFromQRCode
        
        // Policy
        case CurtainPosition
        case DownloadPolicy
        case ApplicationInProcessing
        
        // Pay policy
        case GoPayPolicyToLink
        
        // Selected
        case SelectedDateStatistic
        case SelectedCategory
        
        // Authorization
        case UserAuthorizationComplete
        case UserLogOut
        
        // Deleted
        case DeletedExpense
        case DeletedAllExpensesFromCategory
        
        // Edition
        case EditionWidgets
    }
}
