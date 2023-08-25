//
//  ViewDateSelected.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewDateSelected: ViewFunction {
    
    private var clickAction: (()->Void)?
    
    init(clickAction: @escaping () -> Void) {
        super.init(text: "", image: UIImage(named: "arrowSelectCar"))
        self.labelText!.text = self.selectedDate()
        self.clickAction = clickAction
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    @objc private func tap() {
        self.clickAction!()
    }
    
    private func selectedDate() -> String {
        return SelectedDate.shared.getSelectedIndexMonth() == 0 ? "За \(SelectedDate.shared.getStringYear()) год" : "\(SelectedDate.shared.getStringMonth()) \(SelectedDate.shared.getStringYear())"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        self.clickAction = {}
        
    }
}

extension ViewDateSelected: DelegateReloadData {
    func updateData() {
        self.labelText!.text = self.selectedDate()
    }
}
