//
//  ModelSchedule.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 12/09/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


protocol DelegateDataToSchedule: class {
    func setData(forSchedule: [DataForSchedule])
    
}

class ModelSchedule: NSObject {
    
    weak var delegate: DelegateDataToSchedule?
    private var forSchedule: [DataForSchedule]?
    
    init(arrayDataForSchedule: [DataForSchedule]) {
        self.forSchedule = arrayDataForSchedule
    }
    
    func update() {
         delegate?.setData(forSchedule: forSchedule!)
    }

    deinit {
        forSchedule = nil
    }
}
