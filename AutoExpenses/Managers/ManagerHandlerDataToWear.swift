//
//  ManagerHandlerDataToWear.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 19.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

enum LevelWear {
    case Low
    case Medium
    case High
}

enum TypeWearView {
    case Small
    case Big
    case Alert
}
   
//MARK: interface model WEAR
protocol IModelWear {
    var totalPoint: Float { get set }
    var currentPoint: Float { get set }
    var unit: String { get set }
    var typeLevel: LevelWear { get }
    var color: UIColor { get }
    var percentageFromCurrentValue: Float { get }
    func kitAttributesFromTypeView(typeWear: TypeWearView) -> [NewAttrChar]
}



//MARK: class handler data about parts
class ManagerHandlerDataToWear {
    
    private var models: [ModelTimeAndMileageWear]?
    
    deinit {
        print("deinit ManagerHandlerDataToWear")
    }
    
    init() {
     
//        let manager = ManagerDataBase(entity: EntityHealthCar())
//        let entityHealthArray: [EntityHealthCar] = manager.getArrayDataBase() as! [EntityHealthCar]
        
//        for entity in entityHealthArray {
//            let modelTimeAndMileage = ModelTimeAndMileageWear(
//                modelTime: StructWear(endDate: entity.dateEndWear, unit: "мес."),
//                modelMileage: StructWear(totalPoint: Float(entity.mileageEndWear), currentPoint: Float(EntityMileageAuto().mileage), unit: "км"),
//                nameHeader: entity.name,
//                typeWearView: .Small)
//
//            models?.append(modelTimeAndMileage)
//        }
//        models = [ModelTimeAndMileageWear(modelTime: ModelWearEmpty(unit: "мес."),
//                                          modelMileage: ModelWearEmpty(unit: "км"),
//                                          nameHeader: "")]
        models = [ModelTimeAndMileageWear(modelTime: ModelWear(totalPoint: 6,
                                                                     currentPoint: 5,
                                                                     unit: "мес."),
                                          modelMileage: ModelWear(totalPoint: 10000,
                                                                   currentPoint: 9000,
                                                                   unit: "км"),
                                          nameHeader: "TO - 10000 km"),

                  ModelTimeAndMileageWear(modelTime: ModelWear(totalPoint: 12,
                                                                currentPoint: 2,
                                                                unit: "мес."),
                                          modelMileage: ModelWear(totalPoint: 20000,
                                                                   currentPoint: 10000,
                                                                   unit: "км"),
                                          nameHeader: "Система охлаждения"),

                  ModelTimeAndMileageWear(modelTime: ModelWear(totalPoint: 3,
                                                                currentPoint: 1,
                                                                unit: "мес."),
                                          modelMileage: ModelWear(totalPoint: 5000,
                                                                   currentPoint: 500,
                                                                   unit: "км"),
                                          nameHeader: "Масло в двигателе"),

                  ModelTimeAndMileageWear(modelTime: ModelWear(totalPoint: 6,
                                                                currentPoint: 1,
                                                                unit: "мес."),
                                          modelMileage: ModelWear(totalPoint: 10000,
                                                                   currentPoint: 1000,
                                                                   unit: "км"),
                                          nameHeader: "Ходовая часть"),

                  ModelTimeAndMileageWear(modelTime: ModelWear(totalPoint: 24,
                                                                currentPoint: 2,
                                                                unit: "мес."),
                                          modelMileage: ModelWear(totalPoint: 40000,
                                                                   currentPoint: 10000,
                                                                   unit: "км"),
                                          nameHeader: "Тормозные колодки"),

                  ModelTimeAndMileageWear(modelTime: ModelWear(totalPoint: 6,
                                                                currentPoint: 0,
                                                                unit: "мес."),
                                          modelMileage: ModelWear(totalPoint: 10000,
                                                                   currentPoint: 2000,
                                                                   unit: "км"),
                                          nameHeader: "Фильтры")]
    }
    
    func getArrayFromLevel() -> [[ModelTimeAndMileageWear]] {
        let arrayArrays: [[ModelTimeAndMileageWear]]?
        
        var arrayLow = [ModelTimeAndMileageWear]()
        var arrayMiddle = [ModelTimeAndMileageWear]()
        var arrayHigh = [ModelTimeAndMileageWear]()
        
            for item in models! {
                for lev in [LevelWear.Low, LevelWear.Medium, LevelWear.High] {
                    switch lev {
                    case .Low:
                        if item.modelMileage.typeLevel == .Low && item.modelTime.typeLevel == .Low {
                            arrayLow.append(item)
                        }
                        
                    case .Medium:
                        if item.modelMileage.typeLevel != .High && item.modelTime.typeLevel != .High && (item.modelMileage.typeLevel == .Medium || item.modelTime.typeLevel == .Medium) {
                            arrayMiddle.append(item)
                        }
                        
                    case .High:
                        if item.modelMileage.typeLevel == .High || item.modelTime.typeLevel == .High {
                            arrayHigh.append(item)
                        }
                    }
                }
            }
        
        arrayArrays = [arrayLow, arrayMiddle, arrayHigh]
        return arrayArrays!
    }
    
}
