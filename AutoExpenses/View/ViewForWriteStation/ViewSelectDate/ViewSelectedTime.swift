//
//  ViewSelectedTime.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 31.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewSelectedTime: UIView {

    private weak var delegate: DelegateSetDate?
    private var collectionView: UICollectionView?
    private var time: Time?

    
    init(frame: CGRect, delegate: DelegateSetDate) {
        super.init(frame: frame)
        self.delegate = delegate
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    func setup() {
        
        time = Time()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 2
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.allowsMultipleSelection = false
        collectionView?.register(UINib(nibName: "CollectionViewCellSelectTime", bundle: nil), forCellWithReuseIdentifier: "cellTimeToWrite")
        self.addSubview(collectionView!)
        self.collectionView?.backgroundColor = .clear
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView?.frame = self.bounds
        collectionView?.reloadData()
    }
}

extension ViewSelectedTime: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dateComponent = Calendar.current.dateComponents(in: .current, from: self.delegate?.dateSelected ?? Date())
        let hour = time!.timers[indexPath.row]
        dateComponent.hour = hour

        self.delegate?.dateSelected = dateComponent.date ?? Date()
        self.collectionView?.reloadData()
    }
  
}

extension ViewSelectedTime: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTimeToWrite", for: indexPath) as! CollectionViewCellSelectTime
        cell.setup(time: time!.getTimeToStringFromArray(index: indexPath.row), type: .notSelectedSettings())
        cell.isSelected = time!.timers[indexPath.row] == Calendar.current.component(.hour, from: self.delegate!.dateSelected!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return time!.timers.count
    }

}

extension ViewSelectedTime: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 4 - (4) , height: self.frame.height / 3 - (4))
    }
    
}
