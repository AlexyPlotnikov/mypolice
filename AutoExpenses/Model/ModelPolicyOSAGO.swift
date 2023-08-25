//
//  ModelPolicyOSAGO.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 01.04.2020.
//  Copyright © 2020 rx. All rights reserved.
//

import Foundation

struct FieldOSAGO {
    var header: String
    var description: String?
}

class ModelPolicyOSAGO: Codable {
 
    var insurantFullName: String
    var insurantShortName: String?
    var insurantDate: String?
    var vehicleMark: String?
    var rxMark: Int?
    var rxModel: Int?
    var vehicleModel: String?
    var vehicleYear: Int?
    var vehicleNumber: String?
    var vehicleBody: String?
    var vehicleVIN: String?
    var pageID: Int?
    var vehicleMileage: String?
    var dateSent: String?
    var `super`: String?
    var paid: Bool?
    var state: Int?
    var startDate: String?
    var insurancePeriod: Int
    var id: Int
    
    var arrayFields: [FieldOSAGO] {
        
        return [FieldOSAGO(header: "ФИО", description: insurantFullName),
                FieldOSAGO(header: "Марка", description: vehicleMark),
                FieldOSAGO(header: "Модель", description: vehicleModel),
                FieldOSAGO(header: "Год выпуска", description: vehicleYear?.toString()),
                FieldOSAGO(header: "Гос. номер", description: vehicleNumber),
                FieldOSAGO(header: "Номер кузова", description: vehicleBody),
                FieldOSAGO(header: "VIN", description: vehicleVIN),
                FieldOSAGO(header: "Пробег", description: vehicleMileage),
                FieldOSAGO(header: "Начало действия полиса", description: startDate?.toDateTime(format: "yyyy-MM-dd'T'HH:mm:SS").toString()),
                FieldOSAGO(header: "Период страхования", description: insurancePeriod == 12 ? "1 год" : "\(insurancePeriod) мес.")]
    }
    
}

struct ListPolicysOSAGO: Codable {
    var data: [ModelPolicyOSAGO]?
    var isError: Bool
    var state: Int
}
