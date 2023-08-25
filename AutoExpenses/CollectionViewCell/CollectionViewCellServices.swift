//
//  CollectionViewCellExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 15/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class CollectionViewCellServices: UICollectionViewCell {
    

    @IBOutlet private weak var labelDescription: UILabel!
    @IBOutlet private weak var backImage: UIImageView!
    @IBOutlet private weak var labelNameCategory: UILabel!
    @IBOutlet weak var buttonAction: UIButton!
    private var field: IAddInfoProtocol?
    weak var vcCurrent: UIViewController?
    private weak var delegate: DelegateShowViewController?
    
    func initialization(iField: IAddInfoProtocol) {
        self.field = iField
        backImage.backgroundColor = .lightGray
        labelNameCategory.text =  iField.headerField
        self.labelDescription.text = iField.info
        backImage.image = (iField as! BaseAutoInfo).backImage
        buttonAction.addTarget(self, action: #selector(tap), for: .touchUpInside)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 14
    }
    
    @objc func tap() {
        
        if !CheckInternetConnection.shared.checkInternet(in: vcCurrent!) {
            return
        }
        
        switch self.field {
        case is PolicyOSAGOService:
            PolicyOSAGOService().presentVC(vc: vcCurrent!)
        case is PartsService:
            PartsService().presentVC(vc: vcCurrent!)
        case is StationTechnicalService:
            StationTechnicalService().presentVC(vc: vcCurrent!)
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    
    
}
