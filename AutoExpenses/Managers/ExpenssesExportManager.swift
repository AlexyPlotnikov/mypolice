//
//  ExpenssesExportManager.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 15/10/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import UIKit

class ExpenssesExportManager {
    
    private var manager: ManagerCategory?
    private var structDate: StructDateForSelect
    private var viewControllerForShowShareScreen: UIViewController?
    
    init(managerCategory: ManagerCategory, structDate: StructDateForSelect, vc: UIViewController) {
        self.manager = managerCategory
        self.structDate = structDate
        self.viewControllerForShowShareScreen = vc
    }
    
    private func setFirstLineForNaming(category: BaseCategory) -> String {
        var newLine = ""
        
        switch category {
        case is Fuel:
            newLine = "\(category.dateField!.id); \(category.mileageField!.id) (km); \(category.sumField!.id) (rub); \((category as! Fuel).priceLiterField.id) (rub); \(category.commentField.id)"
            
        case is TechnicalService:
            newLine = "\(category.dateField!.id); \(category.mileageField!.id) (km); \(category.sumField!.id) (rub); \((category as! TechnicalService).technicalService.id); \(category.commentField.id)"
            
        default:
            newLine = "\(category.dateField!.id); \(category.mileageField!.id) (km); \(category.sumField!.id) (rub); \(category.commentField.id)"
        }
        
        return newLine + "\n"
    }
    
    func share() {
        
       let fileName = "Отчет по категории \(manager!.category!.id).csv"
       let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
       var csvText = ""
        
       let count = manager!.getCount(year_month: structDate)
                      
                var array = [BaseCategory]()
        
                      for i in 0..<count {
                        let expense = manager!.getDataBaseToIndex(index: i, year_month: structDate)
                          array.append(expense)
                      }
                      
                          if count > 0 {
                            
                              for item in array {
                                let index = array.firstIndex { (itemTemp) -> Bool in
                                    item.dateField?.date == itemTemp.dateField?.date
                                }
                                
                                let date = item.dateField?.date?.toString(format: "dd.MM.yyyy") ?? "-"
                                let cost = (item.sumField?.sum ?? 0).toString().replacePointToComma
                                  let mileage = item.mileageField?.info ?? "0"
                                let pricePerLiter = (item is Fuel) ? (item as! Fuel).priceLiterField.price.toString().replacePointToComma : ""
                                  let technicalType = (item is TechnicalService) ? (item as! TechnicalService).technicalService.type : ""
                                  let comment = item.commentField.comment
                                
                                var newLine = ""
                                if index == 0 {             // for header
                                    csvText.append(contentsOf: setFirstLineForNaming(category: item))
                                }
                                
                                switch item {
                                case is Fuel:
                                    newLine = "\(date); \(mileage); \(cost); \(pricePerLiter); \(comment)"
                                    
                                case is TechnicalService:
                                    newLine = "\(date); \(mileage); \(cost); \(technicalType); \(comment)"
                                    
                                default:
                                    newLine = "\(date); \(mileage); \(cost); \(comment)"
                                }
                                
                                csvText.append(contentsOf: newLine + "\n")
                              }
                            
                              do {
                                  try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                                          
                              let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
                                  vc.excludedActivityTypes = [
                                      UIActivity.ActivityType.assignToContact,
                                      UIActivity.ActivityType.saveToCameraRoll,
                                      UIActivity.ActivityType.postToFlickr,
                                      UIActivity.ActivityType.postToVimeo,
                                      UIActivity.ActivityType.postToTencentWeibo,
                                      UIActivity.ActivityType.postToTwitter,
                                      UIActivity.ActivityType.postToFacebook,
                                      UIActivity.ActivityType.openInIBooks
                                  ]
                              
                                  self.viewControllerForShowShareScreen!.present(vc, animated: true, completion: nil)

                              } catch {

                                  print("Failed to create file")
                                  print("\(error)")
                              }
                              
                          } else {
                              print("Error: There is no data to export")
                          }
          }
    
}

extension Double {
    func toString() -> String {
        return String(self)
    }
}
