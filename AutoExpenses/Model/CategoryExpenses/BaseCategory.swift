//
//  CategoryExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 15/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

// MARK: делегат открытия ViewController
protocol DelegateShowViewController: class {
    func showViewController(vc : UIViewController)  //в vc передать view controller который нужно открыть
}


// MARK: базовый класс категории
class BaseCategory: IAddInfoProtocol {
    
    var heightFields: CGFloat = 0
    var info: String = ""
    var headerField: String = ""
    var icon: UIImage?
    var id: String = ""

    var photo: Photo?
    var sumField: Sum?
    var mileageField: Mileage?
    var commentField: Comment
    var dateField: DataExpenses?
    
    var typeView = TypeView.Additional
    
    var iconCategoryActivate : UIImage?
    var iconCategoryNotActivate : UIImage?
    
    var colorHead = UIColor()
    var colorGradient: UIColor = .white
    
    weak var delegateUpdateData : DelegateReloadData?
    weak var delegateShowViewController : DelegateShowViewController?
    var manager: ManagerDataBaseFromRealm!
    
    deinit {
        print("deinit CATEGORY")
        photo = nil
        sumField = nil
        mileageField = nil
        dateField = nil
        
    }
    
    init(typeEntity: ManagerDataBaseFromRealm.TypeEntity) {
        manager = ManagerDataBaseFromRealm(typeEntity: typeEntity)
        self.photo = Photo()
        self.mileageField = Mileage()
        self.commentField = Comment()
        self.dateField = DataExpenses()
        
        self.sumField = Sum()
        self.sumField!.sum = getEndSum()
    }

    func getEndSum() -> Float {
        let array = manager.getAllDataFromDB()
        let loadPrice = array.count >= 2 ? Int(manager.dataForCompareInDataBase(item: array[array.count-1]).sum) == Int(manager.dataForCompareInDataBase(item: array[array.count-2]).sum) : false
        return loadPrice || (array.count > 0 && typeView == .Editional) ? manager.dataForCompareInDataBase(item: array[array.count-1]).sum : 0.0
    }
    
    func clearAllField() {
        self.sumField!.sum = getEndSum()
        self.mileageField!.info = Mileage().info
        self.commentField.comment = ""
        self.dateField!.date = Date()
        self.photo!.arrayPhotos!.removeAll()
    }

    func updateMileage() {
        let _mileage = Int(self.mileageField!.info) ?? 0
        let entityMileage = EntityMileageAuto(mileage: _mileage)
        for entity in entityMileage.getAllDataFromDB() where entity.mileage == _mileage {
            entity.deleteFromDb()
        }
        entityMileage.addData()
    }
    
    func click(typeView: TypeView) {
        if typeView == .Additional {
            self.clearAllField()
        }
        self.typeView = typeView
            
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewControllerEditionExpenses = (storyboard.instantiateViewController(withIdentifier: "viewControllerEditionExpenses") as! ViewControllerEditionExpenses)
        viewControllerEditionExpenses.setCategory(category: self)
        self.delegateShowViewController?.showViewController(vc: viewControllerEditionExpenses)
    }
}
