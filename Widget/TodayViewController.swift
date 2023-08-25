//
//  TodayViewController.swift
//  Widget
//
//  Created by Иван Зубарев on 14/10/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private var viewCollectionCategory: ViewCategoryForWidget!
    private var collectionView: UICollectionView!
    private var labelCost: UILabel!
    private var cost: Float = 0
    let itemsPerRow: CGFloat = 1
    let array = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ",", "0", ""]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CollectionViewCellForEnter", bundle: nil), forCellWithReuseIdentifier: "cellNumbers")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        labelCost = UILabel()
        labelCost.text = String(cost)
        labelCost.font = UIFont(name: "SFUIDisplay-Bold", size: 13)
        labelCost.textAlignment = .right
        labelCost.textColor = .white
        self.view.addSubview(labelCost)
        
        viewCollectionCategory = ViewCategoryForWidget()
        self.view.addSubview(viewCollectionCategory)
        
        self.collectionView.reloadData()
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.labelCost.frame = CGRect(x: 16, y: 0, width: self.view.frame.width - 32, height: self.view.frame.height * 0.15)
        self.collectionView.frame = CGRect(x: 16, y: self.labelCost.frame.height, width: self.view.bounds.width * 0.65 - 32, height: self.view.bounds.height - self.labelCost.frame.height)
        
        let pointX = self.collectionView.frame.origin.x + self.collectionView.frame.width + 8
        self.viewCollectionCategory.frame = CGRect(x: pointX , y: self.collectionView.frame.origin.y, width: self.view.frame.width - pointX - 8, height: self.collectionView.frame.height)
        
        self.collectionView.reloadData()
        self.viewCollectionCategory.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellNumbers", for: indexPath) as! CollectionViewCellForEnter
        
        let nameButton = array[indexPath.row]
        cell.number.setImage(nameButton.isEmpty ? UIImage.init(named: "remove") : nil, for: .normal)
        cell.number.setTitle(nameButton, for: .normal)
        cell.number.addTarget(self, action: #selector(tapNumber(_:)), for: .touchDown)
        return cell
    }
    
    @objc func tapNumber(_ sender: UIButton) {
       let url = URL(string: "mainApp://addExpenses")!
       self.extensionContext?.open(url, completionHandler: {(success) in
           if (!success) {
               print("error: failed to open app from Today Extension")
           } else {
              
           }
       })
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.collectionView.bounds.height / (4 + 1/3)
        let width = self.collectionView.bounds.width / (3 + 1/3)
        return CGSize(width: width, height: height)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {

        if activeDisplayMode == .compact {
            self.preferredContentSize = CGSize(width: 0, height: maxSize.height)
        } else {
            self.preferredContentSize = CGSize(width: 0, height: 300)
        }
        
        self.collectionView.reloadData()
        self.viewCollectionCategory.collectionView.reloadData()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
           // If an error is encountered, use NCUpdateResult.Failed
           // If there's no update required, use NCUpdateResult.NoData
           // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.newData)
    }

    
}
