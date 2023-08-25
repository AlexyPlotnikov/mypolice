//
//  ModelWriteScheduledTO.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 23.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation

//MARK: Model for Repair
struct RepairWorking {
    var nameWorking = "Нет данных"
    var itemDescription: String?
    var pricePart: Float = 0
    var replacementPrice: Float = 0
    var leadTime: String = "Нет данных"
}

//MARK: structs for data
struct DataForTO {
    var nameTO: String?
    var fullOriginalPrice: String?
    var fullDuplicatePrice: String?
    var listRepairsWorking = [RepairWorking]()
}

//MARK: Model for write schedule TO
class ModelWriteScheduledTO {
    
    enum TypeParts: String {
        case originals = "Оригинальные"
        case duplicates = "Дубликат"
    }
    
    var serviceID: String?
    var dataTO: DataForTO?
    var typeParts: TypeParts = .originals
    var dateVisit: Date?
    var protectedEngine = false
    var aditionalInfo: String?
    
    init() {
        self.dataTO = DataForTO()
    }
    
    func getCostTo() -> String {
        return  (typeParts == TypeParts.originals ? dataTO?.fullOriginalPrice : dataTO?.fullDuplicatePrice) ?? "0"
    }
    
    func getDataForRequest() -> String {
        let _date: String = "\(dateVisit?.toString(format: "d MMMM yyyy \n в H:mm") ?? "-"); "
        let _mileageTO: String = "TO: \(dataTO?.nameTO ?? "-"); "
        let _typeParts = typeParts.rawValue + "; "
        let _ptotectedEngine = protectedEngine ? "Защита двигателя; " : ""
        let _additionalInfo = "\(aditionalInfo ?? ""); "
        return serviceID ?? "" + _mileageTO + _typeParts + _date + _ptotectedEngine + _additionalInfo
    }
    
}
