//
//  ViewControllerServices.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 16/05/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewControllerServices: ViewControllerThemeColor, UIGestureRecognizerDelegate {

    @IBOutlet weak var collectionViewServices: UICollectionView!

    @IBOutlet weak var logOutButton: UIButton!
    private var arrayServices : [IAddInfoProtocol]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("deinit_ViewControllerServices")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        arrayServices = [PolicyOSAGOService(), StationTechnicalService(), PartsService()]
        LocalDataSource.servicesViewController = self
     
        self.logOutButton.addTarget(self, action: #selector(logOutAction(_:)), for: .touchUpInside)
    }
    
    @objc func backAction(_ sender: Any) {
        self.dismiss(animated: true) {}
    }
    
    @objc func logOutAction(_ sender: Any) {
        let alert = UIAlertController(title: "Выход", message: "Вы хотите выйти?", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Выйти", style: .destructive) { (action) in
            
            UserAuthorization.sharedInstance.exitUserFromTheAccount()
            
            if EntityAuthorization().checkData() {
                EntityAuthorization().getAllDataFromDB()[0].deleteFromDb()
            }
            
            self.logOutButton.isHidden = true
        }
        
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel) {(action) in}
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.logOutButton.isHidden = !UserAuthorization.sharedInstance.getActivateUser() || !EntityAuthorization().checkData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateData()
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

extension ViewControllerServices : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayServices!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellServices", for: indexPath) as! CollectionViewCellServices
        let index = indexPath.row
        let autoInfo = arrayServices![index]
        collectionCell.initialization(iField: autoInfo)
        collectionCell.vcCurrent = self
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, layoutcollectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
}

extension ViewControllerServices: DelegateReloadData {
    
    func updateData() {
        for item in arrayServices! {
            if (item.updateInfo != nil) {
                item.updateInfo!()
            }
        }
        
        self.collectionViewServices.reloadData()
    }
    
    
    
}
