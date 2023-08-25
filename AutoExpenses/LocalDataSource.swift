//
//  LocalDataSource.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

import RealmSwift


class LocalDataSource {

    static var headViewController: ViewControllerHead!
    static var listViewController: ViewControllerListExpenessWithCategory!
    static var statisticViewController: ViewControllerStatisticExpenses!
    static var autorizationViewController: ViewControllerAutorization!
    static var servicesViewController: ViewControllerServices!
    
    static var demo = true
    // Demo acess
    
    // идинтификатор автомобиля
    static var identificatorUserCar : Int = 0

    
    static var arrayCategory : [Any] = [Fuel(typeEntity: .EntityFuelCategory),                            // топливо
                                        CarWash(typeEntity: .EntityCarWashCategory),                      // мойка
                                        Parking(typeEntity: .EntityParkingCategory),                      // Парковка
                                        Parts(typeEntity: .EntityPartsCategory),                          // Запчасти
                                        Policy(typeEntity: .EntityPolicyInsurent),                        // страховка
                                        TechnicalService(typeEntity: .EntityTechnicalServiceCategory),    // тех. обслуживание
                                        Tuning(typeEntity: .EntityTuningCategory),                        // тюнинг
                                        Other(typeEntity: .EntityOtherCategory)]                          // другие

//    static func clearCategory() {
//        self.arrayCategory.removeAll()
//       LocalDataSource.arrayCategory = [Fuel(),                // топливо
//        CarWash(),             // мойка
//        Parking(),             // Парковка
//        Parts(),               // Запчасти
//        Policy(),              // страховка
//        TechnicalService(),    // тех. обслуживание
//        Tuning(),              // тюнинг
//        Other()]
//    }
    
    
    static var fullListInformationAuto : [Any] = [//ModelAuto(),            // марка авто
                                                  TimeParking(),
                                                  CertificateAuto(),      // сртс
                                                  PassportAuto(),         // птс
                                                  DriverSertificate(),    // права
                                                  TechnicalInspection(),  // TO
                                                  Mileage(),              // пробег
                                                  FuelConsumption()      // расход
                                                  /*,SumInMonth(),           // стоимость за месяц
                                                  SumInOneKilometer()*/]    // стоимость на км
    
//    static var arrayServices : [IAddInfoProtocol] = [PolicyOSAGOService(),
//                                                    StationTechnicalService(),
//                                                    PartsService()]
    
}
