//
//  UserInformationHandler.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 30/05/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class UserInformationHandler: NSObject {
    
    private var stateWidgets: StateWidgetsController?

    init(array: [IAddInfoProtocol], keyID: String) {
        super.init()
        
//        if stateWidgets == nil {
            stateWidgets = StateWidgetsController(arrayForEditional: array, keyID: keyID)
//        }
    }
    
    func isEmptyField() -> Bool {
        return stateWidgets!.emptyField()
    }
    
    
    func removeWidgetFromList(_ index: Int) {
        stateWidgets!.removeFromArray(index)
    }
    
    // скрывает виджет
    func skipWidgetFromHeadScreen(_ index: Int) {
        stateWidgets!.addTempToStorage(index)           // добавление в временное хранение скинпнутой ячейки
        stateWidgets!.removeFromArray(index)            // удаление из массива
    }
    
    //меняет индекс в массиве при перемещении
    func insertItemInNewPosition(_ item: IAddInfoProtocol,_ index: Int) {
        stateWidgets!.insertElementInArray(item, index)
    }

    
    func getCountElementSelected() -> Int {
        return stateWidgets?.arrayItemSelectedForUserInformation().count ?? 0
    }
    
    func getCountElementNotSelected() -> Int {
        return stateWidgets?.arrayItemNotSelectedForUserInformation().count ?? 0
    }
    
    // получаем массив IAddInfoProtocol
    func getSelectedElementsInfo() -> [IAddInfoProtocol] {
        return stateWidgets!.arrayItemSelectedForUserInformation()
    }
    
    
    func getNotSelectedElementsInfo() -> [IAddInfoProtocol] {
        return stateWidgets!.arrayItemNotSelectedForUserInformation()
    }

    
    func restoreSkipEndElement(completion: (Int) -> Void) {
        stateWidgets?.restoringEndElement(completion: { (index) in
            completion(index)
        })
    }
}
