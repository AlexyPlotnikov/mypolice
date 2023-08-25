//
//  StateWidgetsController.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 31/05/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation

struct Widget {
    var index: Int = 0
    var value: IAddInfoProtocol?
}

class StateWidgetsController {
    
    private var widgetStorage: Widget?
    private var editionListObjects: [IAddInfoProtocol] = []
    private let fullListObjects : [IAddInfoProtocol]?
    private let entityListWidgets : EntityListWidgets?
    
    init(arrayForEditional: [IAddInfoProtocol], keyID: String) {
        entityListWidgets = EntityListWidgets()
        entityListWidgets?.keyID = keyID
        self.fullListObjects = arrayForEditional
    
        if entityListWidgets!.getAllDataFromDB()!.count <= 0 {
            self.editionListObjects = arrayForEditional
        }
        else {
            self.loadData()
        }
    }
    
    func emptyField() -> Bool {
        return widgetStorage == nil
    }
    
    func loadData() {
        editionListObjects.removeAll()
        for item in entityListWidgets!.getAllDataFromDB()!{
            if let _item = getData(id: item.widgetKey) as? IAddInfoProtocol {
                editionListObjects.append(_item)
            }
        }
    }
    
    private func saveData() {
        for item in entityListWidgets!.getAllDataFromDB()! {
            item.deleteFromDb()
        }
        
        for i in 0..<editionListObjects.count {
           let entityWidgets = EntityListWidgets()
            entityWidgets.id = i.toString()
            entityWidgets.keyID = entityListWidgets!.keyID
            entityWidgets.widgetKey = editionListObjects[i].id!
            entityWidgets.addData()
        }
    }
    
    func reloadList() {
        editionListObjects = fullListObjects!
    }
    
    func removeFromArray(_ index: Int) {
        if self.editionListObjects.count>=index {
           self.editionListObjects.remove(at: index)
           saveData()
        }
    }
    
    
    func addTempToStorage (_ index: Int) {
        self.widgetStorage = Widget(index: index, value: editionListObjects[index])
    }
    
    
    func insertElementInArray(_ item: IAddInfoProtocol, _ index: Int) {
        if !self.editionListObjects.contains(where: { (addProtocol) -> Bool in addProtocol.id == item.id }) {
            self.editionListObjects.insert(item, at: index)
            saveData()
            
        }
        
       
    }
    
    func getFullList() -> [IAddInfoProtocol] {
        return fullListObjects!
    }
    
    func arrayItemSelectedForUserInformation() -> [IAddInfoProtocol] {
        return editionListObjects
    }
    
    func arrayItemNotSelectedForUserInformation() -> [IAddInfoProtocol] {
            var array : [IAddInfoProtocol] = []
            
            for itemFull in fullListObjects! where !editionListObjects.contains(where: {(itemFullItem) -> Bool in itemFullItem.id == itemFull.id }) && !array.contains(where: {(arrayItem) -> Bool in arrayItem.id == itemFull.id }) {
                array.append(itemFull)
                print(itemFull.id)
            }
        return array
    }
    
    func getRemovedEndElement() -> IAddInfoProtocol? {
        return self.widgetStorage!.value
    }
    
    func restoringEndElement(completion: (Int)-> Void) {
        
        if widgetStorage != nil {
            self.editionListObjects.insert(widgetStorage!.value!, at: widgetStorage!.index)
            saveData()
            completion(widgetStorage!.index)
            widgetStorage = nil
        }
    }
    
    
    private func getData(id: String) -> Any? {
        switch id {
        case "TimeParking":
            return fullListObjects![0]
        case "ModelAuto":
            return ModelAuto()
        case "CertificateAuto":
            return fullListObjects![1]
        case "PassportAuto":
            return fullListObjects![2]
        case "DriverSertificate":
            return fullListObjects![3]
        case "TechnicalInspection":
            return fullListObjects![4]
        case "Mileage":
            return fullListObjects![5]
        case "FuelConsumption":
            return fullListObjects![6]
        case "SumInMonth":
            return SumInMonth()
        case "SumInOneKilometer":
            return SumInOneKilometer()
        case "Fuel":
            return Fuel(typeEntity: .EntityFuelCategory)
        case "Parts":
            return Parts(typeEntity: .EntityPartsCategory)
        case "Other":
            return Other(typeEntity: .EntityOtherCategory)
        case "Policy":
            return Policy(typeEntity: .EntityPolicyInsurent)
        case "Tuning":
            return Tuning(typeEntity: .EntityTuningCategory)
        case "Parking":
            return Parking(typeEntity: .EntityParkingCategory)
        case "CarWash":
            return CarWash(typeEntity: .EntityCarWashCategory)
        case "TO":
            return TechnicalService(typeEntity: .EntityTechnicalServiceCategory)
        default:
            return nil
        }
    }
//
}
