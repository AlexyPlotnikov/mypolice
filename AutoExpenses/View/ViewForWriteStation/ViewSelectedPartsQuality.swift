//
//  ViewSelectedPartsQuality.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 28.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

protocol DelegateSelectedQualityParts: class {
    func setQualityParts(type: ModelWriteScheduledTO.TypeParts)
}

class ViewSelectedPartsQuality: UIView {
    
    private var viewOriginal: UIButton?
    private var viewDuplicate: UIButton?
    private weak var delegate : DelegateSelectedQualityParts?
    
    init(frame: CGRect, delegate: DelegateSelectedQualityParts, typeSelected: ModelWriteScheduledTO.TypeParts) {
        super.init(frame: frame)
        
        self.delegate = delegate
        
        viewOriginal = UIButton()
        viewOriginal!.setTitle(ModelWriteScheduledTO.TypeParts.originals.rawValue, for: .normal)
        viewOriginal?.addTarget(self, action: #selector(selectOriginal), for: .touchUpInside)
        viewOriginal?.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        self.addSubview(viewOriginal!)
        
        viewDuplicate = UIButton()
        viewDuplicate!.setTitle(ModelWriteScheduledTO.TypeParts.duplicates.rawValue, for: .normal)
        viewDuplicate?.addTarget(self, action: #selector(selectDuplicate), for: .touchUpInside)
        viewDuplicate?.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        self.addSubview(viewDuplicate!)
        
        selectedParts(typeParts: typeSelected)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewOriginal?.frame = CGRect(x: 16,
                                     y: self.frame.height * 0.5 - self.frame.height * 0.3 - 9,
                                     width: self.frame.width - 16 * 2,
                                     height: (self.frame.height * 0.3) - 4.5)
        
        viewDuplicate?.frame = CGRect(x: 16,
                                      y: viewOriginal!.frame.origin.y + viewOriginal!.frame.height + 4.5,
                                      width: self.frame.width - 16 * 2,
                                      height: self.frame.height * 0.3 - 4.5)
    }
    
    private func selectedParts(typeParts: ModelWriteScheduledTO.TypeParts) {
        
        let array = [viewOriginal, viewDuplicate] as! [UIButton]
       
        
        for item in array {
            item.layer.cornerRadius = 10
            item.layer.borderColor = UIColor(rgb: 0xCFCFCF).cgColor
            item.layer.borderWidth = 1
            item.backgroundColor = UIColor.white
            item.setTitleColor(.black, for: .normal)
        }
        
        setViewSelected(to: (typeParts == .originals ? viewOriginal : viewDuplicate)!)
        
        if delegate != nil {
            delegate?.setQualityParts(type: typeParts)
        }
    }
    
    
    private func setViewSelected(to viewSelected: UIButton) {
        viewSelected.layer.borderWidth = 0
        viewSelected.backgroundColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0.2588235294, alpha: 1)
        viewSelected.setTitleColor(.black, for: .normal)
        
    }
    
    // for button
    @objc private func selectOriginal() {
        selectedParts(typeParts: .originals)
    }
    
    @objc private func selectDuplicate() {
        selectedParts(typeParts: .duplicates)
    }
    
}
