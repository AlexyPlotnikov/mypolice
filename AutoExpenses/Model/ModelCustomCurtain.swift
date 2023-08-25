//
//  ModelCustomCurtain.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 06/08/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


protocol DelegateSwipePanelExpenses: NSObject {
    func setStatePanelExpenses(state: ModelCustomCurtain.StatePanelExpenses, valuePointY: CGFloat)
    func savingData()
    func setCategory(category:BaseCategory)
}

class ModelCustomCurtain: NSObject {
    
    private weak var viewCustom: CustomCurtainEnterExpenses?
    private weak var vc: UIViewController?
    var indexCategory: Int = 0
    
    enum StatePanelExpenses: Int {
        case Low = 2, Middle = 1, Top = 0
    }
    
    init(viewCustom: CustomCurtainEnterExpenses, vc: UIViewController) {
       super.init()

       self.vc = vc
       self.viewCustom = viewCustom
       self.viewCustom?.delegate = (vc as! DelegateSwipePanelExpenses)
    }
    
    func update() {
         self.viewCustom?.startSettings()
    }

    func scrollingToCurCategory() {
        self.viewCustom?.scrollingPanelCategorys(index: indexCategory)
    }
    
}
