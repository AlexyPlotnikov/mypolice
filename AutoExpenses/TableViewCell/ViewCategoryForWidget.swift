//
//  ViewCategoryForWidget.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 17/10/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewCategoryForWidget: UIView {

    var collectionView: UICollectionView!
    var buttonNextCategory: UIButton!
    var numSelect = 0
    
    func setup() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0.5
        layout.minimumLineSpacing = 0.5
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCellForEnter", bundle: nil), forCellWithReuseIdentifier: "cellNumbers")
        collectionView.backgroundColor = .clear
        self.addSubview(collectionView)
        
        buttonNextCategory = UIButton()
        buttonNextCategory.setImage(UIImage(named: "arrow_bottom"), for: .normal)
        self.addSubview(buttonNextCategory)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = self.bounds.height * 0.2
        self.buttonNextCategory.frame = CGRect(x: 0, y: self.bounds.height - height, width: self.bounds.width, height: height)
        
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height-buttonNextCategory.frame.height)
       
        self.collectionView.reloadData()
    }
    
}

extension ViewCategoryForWidget: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
}

extension ViewCategoryForWidget: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellNumbers", for: indexPath) as! CollectionViewCellForEnter
        cell.number.setImage(UIImage(named: numSelect == indexPath.row ? "car_wash_category" : "car_wash_category_not_activate"), for: .normal)
        return cell
    }
}


extension ViewCategoryForWidget: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.collectionView.bounds.height / (2 + 0.5/2)
        let width = self.collectionView.bounds.width / (2 + 0.5/2)
           return CGSize(width: width, height: height)
       }
       
}
