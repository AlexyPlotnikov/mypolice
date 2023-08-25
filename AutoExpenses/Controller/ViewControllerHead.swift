//
//  ViewController.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 12/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import CoreLocation

protocol DelegateReloadData: NSObject {
   func updateData()
}

class ViewControllerHead: ViewControllerWidget, UIScrollViewDelegate, DelegateSetTimer {

    lazy var locationService = LocationService()
    let car = ModelAuto()
    
    @IBOutlet weak var buttonNameCar: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewPhotos: ViewPhotosAuto!
    @IBOutlet weak var viewTwoCellForCalculation: ViewTwoCell!
    @IBOutlet weak var buttonClose: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // делегат обработки у скрола при смене элементов
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = viewPhotos.scrollView!.contentOffset.x
        let w = viewPhotos.scrollView!.bounds.size.width
        let index = Int(x/w)
        
        let entityCarUser = EntityCarUser().getAllDataFromDB()[index]
        entityCarUser.changeState(item: entityCarUser)
        self.viewPhotos.pageControl?.currentPage = index
        self.updateData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        LocalDataSource.headViewController = self
        super.loadData(array: LocalDataSource.fullListInformationAuto as! [IAddInfoProtocol], keyID: "Head")
        
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        self.tableView.dragInteractionEnabled = true
        
        self.locationService.delegate = self
        // location
        self.locationService.requestPermission()
        self.locationService.start()
        
        buttonClose.addTarget(self, action: #selector(closeController), for: .touchUpInside)
        buttonNameCar.addTarget(self, action: #selector(updateNameCar), for: .touchUpInside)
        
        self.buttonNameCar.setTitle(self.car.info, for: .normal)
        
        
        // rotation loading swipe down
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.init(rgb: 0x3A78F6)
        self.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshFunction(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        car.delegateUpdateData = self
        viewPhotos.scrollView!.delegate = self        // delegate ScrollView
        let color: UIColor = viewPhotos.arrayPhotoCar[LocalDataSource.identificatorUserCar].imageView!.image!.isDark ? .white : .black
        let image = UIImage(named: "cross")?.withRenderingMode(.alwaysTemplate)
        buttonClose.setImage(image, for: .normal)
        buttonClose.tintColor = color
        buttonNameCar.setTitleColor(color, for: .normal)
        
        self.updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func updateNameCar() {
        car.addInfo { (autoName) in
            self.buttonNameCar.setTitle(autoName, for: .normal)
        }
    }
    
    @objc func closeController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setAutoTimer(shop: Shop?) {
        for item in self.userInformationHandler!.getSelectedElementsInfo() where item is TimeParking {
            if let time = shop?.timeParking {
                (item as! TimeParking).timer.startTimer(time: time, specialText: shop?.nameShop)
            } else {
               print("Timer runner")
            }
        }
    }
    
    
    func settingTimer() {
        for item in self.userInformationHandler!.getSelectedElementsInfo() where item is TimeParking {
                (item as! TimeParking).addInfo { (time) in }
        }
    }
    
    
    @objc private func refreshFunction(_ sender: UIRefreshControl) {
        let deadlineTime = DispatchTime.now() + .seconds(Int.random(in: 0...2))
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.updateData()
            sender.endRefreshing()
        }
    }
    
    // status bar
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        let statusBarColor: UIStatusBarStyle = viewPhotos.arrayPhotoCar[LocalDataSource.identificatorUserCar].imageView!.image!.isDark ? .lightContent : .default
//        return statusBarColor
//    }

    
    // делегат вызывается если трясем телефон
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake && !userInformationHandler!.isEmptyField() {
            let alert = UIAlertController(title: "Восстановить?", message: "Хотите вернуть", preferredStyle: .actionSheet)
            
            let ok = UIAlertAction(title: "Вернуть", style: .default) { (action) in
                self.userInformationHandler!.restoreSkipEndElement(completion: { (index) in
                    self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                })
            }
            
            let cancel = UIAlertAction(title: "Отмена", style: .destructive) { (action) in }
            alert.addAction(ok)
            alert.addAction(cancel)
            UISelectionFeedbackGenerator().selectionChanged()
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.maxY, width: 10, height: 10)
            }
            
            self.present(alert, animated: true) {}
        }
    }
    
}

//MARK: TableViewDelegate
extension ViewControllerHead: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
             return 23
        case 2:
            return 44
        default:
            return 80
        }
    }
    
  
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionSkip = UIContextualAction(style: .destructive, title: nil, handler: { (action, view, state) in
            self.userInformationHandler!.skipWidgetFromHeadScreen(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            state(true)
            state(false)
        })
        
        actionSkip.backgroundColor = UIColor.init(rgb: 0xB5B8BC)
        actionSkip.title = "Скрыть"
//        var image = UIImage(named: "iconDelete")
//        image =  image?.resizeImage(targetSize:CGSize(width: 15, height: 15))
//        actionSkip.image = image
        
        return UISwipeActionsConfiguration(actions: [actionSkip])
    }
}


//MARK: DataSource
extension ViewControllerHead: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
           return userInformationHandler!.getCountElementSelected()
        default:
           return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.section {
        case 0:
            let cellInfo: TableViewCellUserInfo = (tableView.dequeueReusableCell(withIdentifier: "cellUserInfo") as! TableViewCellUserInfo)
            let info = userInformationHandler!.getSelectedElementsInfo()[indexPath.row]
            cellInfo.initilization(dataUser: info)
            
            if info is BaseAutoInfo {
                (info as! BaseAutoInfo).delegateUpdateData = self
            }
            
            if info is TimeParking {
                (info as! TimeParking).timer.delegateUpdateTime = self
            }
            return cellInfo
            
        case 1:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.init(rgb: 0xFAFAFC)
            return cell
            
        case 2:
            let cellEdition = (tableView.dequeueReusableCell(withIdentifier: "cellEdition") as! TableViewCellEdition)
            cellEdition.initialization(userHandler: self.userInformationHandler, viewController: self)
            cellEdition.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cellEdition
            
        default:
            return UITableViewCell()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        guard sourceIndexPath != destinationIndexPath else {
            return
        }
        
        let place = userInformationHandler!.getSelectedElementsInfo()[sourceIndexPath.row]
        userInformationHandler!.removeWidgetFromList(sourceIndexPath.row)
        userInformationHandler!.insertItemInNewPosition(place, destinationIndexPath.row)
    }
}


//MARK: DelegateReloadData
extension ViewControllerHead: DelegateReloadData {
    
    func updateData() {
        self.viewTwoCellForCalculation.updating()
        for item in userInformationHandler!.getSelectedElementsInfo() {
            if item.updateInfo != nil {
                item.updateInfo!()
            }
        }
        self.tableView.reloadData()
        self.buttonNameCar.setTitle(self.car.info, for: .normal)
    }
}

extension ViewControllerHead: UpdateTime {
    func updateTime() {
        for cell in self.tableView!.visibleCells where cell is TableViewCellUserInfo && (cell as! TableViewCellUserInfo).dataUser is TimeParking {
            ((cell as! TableViewCellUserInfo).dataUser as! TimeParking).updateInfo()
            (cell as! TableViewCellUserInfo).update()
        }

    }
}
