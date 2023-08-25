//
//  ManagerWriteStationScheduledTO.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 24.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ManagerWriteStationScheduledTO {
    
    var selectedCurrentModel: ModelWriteScheduledTO?
    private var parsing: ParsingJSON?
    private var arrayModelsWriteTO: [ModelWriteScheduledTO]!
    
    var currentIndexTO: Int = 0 {
        didSet {
            selectedCurrentModel?.dataTO = arrayModelsWriteTO?[currentIndexTO].dataTO
        }
    }
    
     var currentStep: Int = 1 {
        didSet (step) {
            if step > totalStep + 1 {
                self.currentStep = totalStep
            } else if step < 1 {
                self.currentStep = 1
            }
        }
    }

    var totalStep: Int = 4
    
    init() {
        self.parsing = ParsingJSON(nameFile: "Toyota LC 200 VD")
        self.arrayModelsWriteTO = [ModelWriteScheduledTO]()
        
      if let arrayTypesTO = ParsingJSON(nameFile: "Toyota LC 200 VD").getDataFromJson(key: "kilm") as? [Any] {
    
        for item in arrayTypesTO {
            let model = ModelWriteScheduledTO()
            if let dictTypesTO = item as? [String : Any] {
                     let nameTO = dictTypesTO["name"] as? String ?? "Нет данных"                // вид работы
                     let priceOriginal = dictTypesTO["priceOr"]  as? String ?? "Нет данных"     // цена за оригинальные запчасти
                     let priceDuplicate = dictTypesTO["priceRep"] as? String ?? "Нет данных"    // цена за дубли запчасти
                      
                    model.dataTO?.nameTO = nameTO
                    model.dataTO?.fullOriginalPrice = priceOriginal
                    model.dataTO?.fullDuplicatePrice = priceDuplicate
                     if let dictArrayWorkingRepairs = dictTypesTO["rep"] as?  [Any]  {
                         
                        for i in 0..<dictArrayWorkingRepairs.count {
                            if let dict = dictArrayWorkingRepairs[i] as? [String : Any] {
                                 
                                let nameWorkingRepair = dict["name"] as? String ?? "Нет данных"
                                 
                                let itemDescription = dict["item"] as? String
                                 
                                let pricePart = dict["price"] as? Float ?? 0
                                 
                                let time = dict["time"] as? String ?? "Нет данных"
                                 
                                let replacementPrice = dict["replacementPrice"] as? Float ?? 0
                                 
                                // добавление списка работ
                                let repair = RepairWorking(nameWorking:  nameWorkingRepair, itemDescription: itemDescription, pricePart: pricePart, replacementPrice: replacementPrice, leadTime: time)
                                
                                if  repair.itemDescription != nil {
                                    model.dataTO?.listRepairsWorking.append(repair)
                                }
                            }
                        }
                    }
                }
                self.arrayModelsWriteTO.append(model)
            }
        
         self.selectedCurrentModel = self.arrayModelsWriteTO[self.currentIndexTO]
        }
       
    }
    
    func setType(type: ModelWriteScheduledTO.TypeParts) {
        self.selectedCurrentModel?.typeParts = type
    }
    
    func getModelWriteTO() -> ModelWriteScheduledTO {
        return self.selectedCurrentModel!
    }
    
    func arrayNamesTO() -> [String] {
        var array = [String]()
        for item in self.arrayModelsWriteTO {
            array.append(item.dataTO!.nameTO!)
        }
        return array
    }
    
}
