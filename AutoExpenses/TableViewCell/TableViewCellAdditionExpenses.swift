//
//  TableViewCellAdditionExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18/06/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class TableViewCellAdditionExpenses: UITableViewCell {
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var nameCategory: UILabel!
    @IBOutlet weak var sumOld: UILabel!
    @IBOutlet weak var dateOldExpenses: UILabel!
    @IBOutlet weak var allSum: UILabel!
    @IBOutlet weak var backView: UIView!
    private var category: BaseCategory?
    private var viewProgress: UIView?
    var delegateUpdateData : DelegateReloadData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func setViewLength (prevSum: Float, curSum: Float) {
     
        if viewProgress == nil {
            viewProgress = UIView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: 0,
                                                height: self.backView!.frame.height))
            self.backView?.addSubview(viewProgress!)
        } else {
            viewProgress!.frame = CGRect(x: 0,
                                         y: 0,
                                         width: 0,
                                         height: self.backView!.frame.height)
        }
        
        if prevSum==0 {
            self.viewProgress?.frame = CGRect(x: self.viewProgress!.frame.origin.x,
                                              y: self.viewProgress!.frame.origin.y,
                                              width: 0,
                                              height: self.backView!.frame.height)
        } else {
            var width = (self.backView.frame.width / CGFloat(prevSum)) * CGFloat(curSum)
            width = width <= self.backView.frame.width ? width : self.backView.frame.width
            UIView.animate(withDuration: 0.4) {
                self.viewProgress?.frame = CGRect(x: self.viewProgress!.frame.origin.x,
                                                  y: self.viewProgress!.frame.origin.y,
                                                  width: width,
                                                  height: self.backView!.frame.height)
            }
        }
    }
    
    func updateData() {
        loadData(object: category!)
    }
    
    private func loadData(object: BaseCategory) {
   
        let manager = ManagerCategory(category: object)
        allSum.text = manager.getAllSum(year_month: SelectedDate.shared.getDate()) > 0 ? manager.getAllSum(year_month: SelectedDate.shared.getDate()).toString("₽") : ""
        sumOld.text = ""
        dateOldExpenses.text = ""
        
        imageViewIcon.image = object.iconCategoryActivate
        nameCategory.text = object.headerField
        // установка цвета всем элементам
        viewProgress?.backgroundColor = object.colorHead
//        imageViewIcon.image! = imageViewIcon.image!.withRenderingMode(.alwaysTemplate)
//        imageViewIcon.tintColor = object.colorHead
        allSum.textColor = object.colorHead
        nameCategory.textColor = object.colorHead
        
        self.setViewLength(prevSum: 0, curSum: 0)
        var prevSum = 1.0 as Float
        var curSum = 1.0 as Float
        
        switch object {
        case is Fuel:
            let objectEntity = ManagerDataBaseFromRealm(typeEntity: .EntityFuelCategory)
            let array = (objectEntity.getDataFromDBCurrentID() as! [EntityFuelCategory]).sorted(by: { $0.date < $1.date })
            if objectEntity.checkData() {
                sumOld.text = array[array.count-1].sum.toString()
                dateOldExpenses.text = array[array.count-1].date.toString()
                if array.count>1 {
                    prevSum = array[array.count-2].sum
                    curSum = array[array.count-1].sum
                }
                self.setViewLength(prevSum: prevSum, curSum: curSum)
            }
            
        case is Parts:
            let objectEntity = ManagerDataBaseFromRealm(typeEntity: .EntityPartsCategory)
             let array = (objectEntity.getDataFromDBCurrentID() as! [EntityPartsCategory]).sorted(by: { $0.date < $1.date })
            if objectEntity.checkData() {
                sumOld.text = array[array.count-1].sum.toString()
                dateOldExpenses.text = array[array.count-1].date.toString()
                if array.count>1 {
                    prevSum = array[array.count-2].sum
                    curSum = array[array.count-1].sum
                }
                 self.setViewLength(prevSum: prevSum, curSum: curSum)
            }
            
        case is Other:
            let objectEntity = ManagerDataBaseFromRealm(typeEntity: .EntityOtherCategory)
            let array = (objectEntity.getDataFromDBCurrentID() as! [EntityOtherCategory]).sorted(by: { $0.date < $1.date })
            if objectEntity.checkData() {
                sumOld.text = array[array.count-1].sum.toString()
                dateOldExpenses.text = array[array.count-1].date.toString()
                if array.count>1 {
                    prevSum = array[array.count-2].sum
                    curSum = array[array.count-1].sum
                }
               self.setViewLength(prevSum: prevSum, curSum: curSum)
            }
            
        case is Policy:
            let objectEntity = ManagerDataBaseFromRealm(typeEntity: .EntityPolicyInsurent)
            let array = (objectEntity.getDataFromDBCurrentID() as! [EntityPolicyInsurent]).sorted(by: { $0.date < $1.date })
            if objectEntity.checkData() {
                sumOld.text = array[array.count-1].sum.toString()
                dateOldExpenses.text = array[array.count-1].date.toString()
                if array.count>1 {
                    prevSum = array[array.count-2].sum
                    curSum = array[array.count-1].sum
                }
                self.setViewLength(prevSum: prevSum, curSum: curSum)
            }
            
        case is Tuning:
            let objectEntity = ManagerDataBaseFromRealm(typeEntity: .EntityTuningCategory)
            let array = (objectEntity.getDataFromDBCurrentID() as! [EntityTuningCategory]).sorted(by: { $0.date < $1.date })
            if objectEntity.checkData() {
                sumOld.text = array[array.count-1].sum.toString()
                dateOldExpenses.text = array[array.count-1].date.toString()
                if array.count>1 {
                    prevSum = array[array.count-2].sum
                    curSum = array[array.count-1].sum
                }
                    self.setViewLength(prevSum: prevSum, curSum: curSum)
            }
           
        case is Parking:
            let objectEntity = ManagerDataBaseFromRealm(typeEntity: .EntityParkingCategory)
            let array = (objectEntity.getDataFromDBCurrentID() as! [EntityParkingCategory]).sorted(by: { $0.date < $1.date })
            if objectEntity.checkData() {
                sumOld.text = array[array.count-1].sum.toString()
                dateOldExpenses.text = array[array.count-1].date.toString()
                if array.count>1 {
                    prevSum = array[array.count-2].sum
                    curSum = array[array.count-1].sum
                }
                   self.setViewLength(prevSum: prevSum, curSum: curSum)
            }
            
        case is CarWash:
            let objectEntity = ManagerDataBaseFromRealm(typeEntity: .EntityCarWashCategory)
             let array = (objectEntity.getDataFromDBCurrentID() as! [EntityCarWashCategory]).sorted(by: { $0.date < $1.date })
            if objectEntity.checkData() {
                sumOld.text = array[array.count-1].sum.toString()
                dateOldExpenses.text = array[array.count-1].date.toString()
                if array.count>1 {
                    prevSum = array[array.count-2].sum
                    curSum = array[array.count-1].sum
                }
                 self.setViewLength(prevSum: prevSum, curSum: curSum)
            }
          
        case is TechnicalService:
            let objectEntity = ManagerDataBaseFromRealm(typeEntity: .EntityTechnicalServiceCategory)
            let array = (objectEntity.getDataFromDBCurrentID() as! [EntityTechnicalServiceCategory]).sorted(by: { $0.date < $1.date })
            if objectEntity.checkData() {
                sumOld.text = array[array.count-1].sum.toString()
                dateOldExpenses.text = array[array.count-1].date.toString()
                if array.count>1 {
                    prevSum = array[array.count-2].sum
                    curSum = array[array.count-1].sum
                }
                 self.setViewLength(prevSum: prevSum, curSum: curSum)
            }
        default:
            break
        }
    }
    
   
    func initialization(dataInfo: BaseCategory) {
        // добавдление данных
        category = dataInfo
        loadData(object: dataInfo)
    }
    
}
