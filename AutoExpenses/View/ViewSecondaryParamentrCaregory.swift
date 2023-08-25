//
//  ViewSecondaryParamentrCaregory.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20/09/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewSecondaryParamentrCaregory: UIView {
    
    private var collectionView: UICollectionView?
    weak var calculationCategoryData : CalculationForCategory? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    
    private func setup() {
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.backgroundColor = .clear
        collectionView?.register(UINib(nibName: "CollectionViewCellCalculations", bundle: nil), forCellWithReuseIdentifier: "cellCalculation")
        self.addSubview(collectionView!)
    }

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView?.frame = self.bounds
    }
    
}

//MARK: CollectionView Delegate
extension ViewSecondaryParamentrCaregory: UICollectionViewDelegate {
    
}

//MARK: CollectionView Data Source
extension ViewSecondaryParamentrCaregory: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calculationCategoryData?.getArrayCalculation()?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCalculation", for: indexPath) as! CollectionViewCellCalculations
        let calculation = calculationCategoryData!.getArrayCalculation()![indexPath.row]
        cell.initialization(calculation: calculation, attrForLabelName: calculation.newAttr)
        return cell
    }
}

//MARK: DelegateFlowLayout
extension ViewSecondaryParamentrCaregory : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / (calculationCategoryData?.getArrayCalculation()?.count ?? 0).toCGFloat()-16, height: self.frame.height-8)
    }
    
}
