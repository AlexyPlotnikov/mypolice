//
//  ModelAuto.swift
//  
//
//  Created by Иван Зубарев on 20/05/2019.
//

import Foundation
import UIKit

class RequestPolicyOSAGO {
    
    enum TypeData : Int {
        case fullName
        case mark
        case vin
        case numberBody
        case drivers
        case numberAuto
        case startDate
        case countMonth
        case vehicleYear
        case pageID
        case dateSent
        case superState
        case state
        case paid
    }
    
    var info: String = ""
    var headerField: String = ""
    private var model: ModelPolicyOSAGO?
//    private var typeData: TypeData = .fullName
   
//    func getModelPolicy() -> ModelPolicyOSAGO {
//        return model
//    }
    
    init() {
//        self.typeData = typeData
    }
    
    
    func loadData(callback: @escaping (ListPolicysOSAGO?) -> Void) {
        UserAuthorization.sharedInstance.getParsingDatePolicyOsagoToKey() { (modelPolicy) in
            DispatchQueue.main.async {
//                print(modelPolicy?.data?.count)
                callback(modelPolicy)
            }
        }
    }
    
//    func loadingData(complete: @escaping (_ load_complete: Bool) -> Void) {
//
//        switch typeData {
//        case .fullName:
//            self.headerField = "ФИО владельца"
//
//            loadData(key: "insurantFullName", callback: {(fullName) in
//                self.info = (fullName as? String)  ?? "Нет данных"
//                complete(true)
//                return
//            })
//            complete(false)
//
//        case .mark:
//            self.headerField = "Марка автомобиля"
//
//            loadData(key: "vehicleMark", callback: { (vehicleMark) in
//
//                self.info = (vehicleMark as? String) ?? ""
//
//                self.loadData(key: "vehicleModel", callback: { (vehicleModel) in
//                    self.info = self.info + " " + (vehicleModel as? String ?? "Нет данных")
//                    complete(true)
//                })
//
//                complete(true)
//            })
//
//
//        case .vin:
//            self.headerField = "VIN"
//
//            loadData(key: "vehicleVIN", callback: {  (vehicleVIN) in
//                self.info = (vehicleVIN as? String) ?? "Нет данных"
//                complete(true)
//                return
//            })
//            complete(false)
//
//        case .numberBody:
//            self.headerField = "Номер кузова"
//
//            loadData(key: "vehicleBody", callback: {  (vehicleBody) in
//                self.info = (vehicleBody as? String) ?? "Нет данных"
//                complete(true)
//                return
//            })
//            complete(false)
//
//        case .drivers:
//            self.headerField = "Водители"
//            complete(true)
//            return
//
//        case .numberAuto:
//
//            self.headerField = "Гос. номер"
//            loadData(key: "vehicleNumber", callback: {  (vehicleNumber) in
//                self.info = (vehicleNumber as? String) ?? "Нет данных"
//                complete(true)
//                return
//            })
//            complete(false)
//
//        case .startDate:
//
//            self.headerField = "Дата начала"
//            loadData(key: "startDate", callback: { (startDate) in
//                if (startDate) == nil {
//                    self.info = "Нет данных"
//                    complete(true)
//                    return
//                } else {
//                    let dataString = (startDate as? String)?.prefix((startDate as! String).count-9).description
//                    let date = dataString?.toDateTime(format: "yyyy-MM-dd")
//                    self.info = date?.toString() ?? "Нет данных"
//                    complete(true)
//                    return
//                }
//            })
//            complete(false)
//
//        case .countMonth:
//            self.headerField = "Период страхования"
//            loadData(key: "insurancePeriod", callback: { (insurancePeriodDate) in
//
//                let period = insurancePeriodDate as? Int ?? 0
//
//                switch(period) {
//                case 0:
//                    self.info = "Нет данных"
//                case 12:
//                    self.info = "1 год"
//                default:
//                    self.info = period.toString() + " мес."
//                }
//
//                complete(true)
//                return
//            })
//            complete(false)
//
//        case .vehicleYear:
//
//            self.headerField = "Год выпуска ТС"
//            loadData(key: "vehicleYear", callback: { (vehicleYear) in
//                let year = (vehicleYear as? Int)
//                self.info = year?.toString("Год") ?? "Нет данных"
//                complete(true)
//                return
//            })
//            complete(false)
//
//        case .pageID:
//          self.headerField = "Номер заявки"
//            loadData(key: "pageID", callback: { (pageID) in
//                self.info = (pageID as? Int)?.toString() ?? ""
//                complete(true)
//                return
//            })
////            complete(false)
//
//        case .dateSent:
//          self.headerField = "DateSent"
//            loadData(key: "dateSent", callback: { (dataSent) in
//                self.info = (dataSent as? String) ?? ""
//                complete(true)
//                return
//            })
////            complete(false)
//
//        case .superState:
//        self.headerField = "Super"
//          loadData(key: "super", callback: { (Super) in
//              self.info = (Super as? String) ?? ""
//              complete(true)
//              return
//          })
////          complete(false)
//
//        case .state:
//        self.headerField = "State"
//          loadData(key: "state", callback: { (state) in
//            self.info = (state as? Int)?.toString() ?? ""
//              complete(true)
//              return
//          })
//
//        case .paid:
//        self.headerField = "Paid"
//          loadData(key: "paid", callback: { (paid) in
//            let tempPaid = (paid as? Bool) ?? false
//            self.info = tempPaid ? "paid" : ""
//              complete(true)
//              return
//          })
//        }
//
//    }
    
}
