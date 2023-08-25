//
//  ViewMyCars.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewMyCars: ViewFunction {
    
    init(text: String?) {
        super.init(text: text ?? "Марка авто", image: nil)
        
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

}
