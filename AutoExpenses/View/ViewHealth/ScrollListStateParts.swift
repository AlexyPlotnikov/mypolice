//
//  ViewListStateParts.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 22.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ScrollListStateParts: UIScrollView {

    private var arrayModels: [ModelTimeAndMileageWear]?
    private var arrayView: [ViewWearBase]?
    private var typeWear: TypeWearView = .Big
    
    init(arrayModels: [ModelTimeAndMileageWear], delegate: DelegateOpenAdditionalScreen, typeWearView: TypeWearView) {
        super.init(frame: CGRect.zero)
        
        self.typeWear = typeWearView
        self.backgroundColor = .clear
        
        self.isPagingEnabled = typeWearView == .Big
        self.showsHorizontalScrollIndicator = false
        
        self.arrayView = [ViewWearBase]()
        self.arrayModels = arrayModels
        
        for var model in arrayModels {
            var view: ViewWearBase!
            switch typeWearView {
            case .Big:
                view = ViewWearBig(delegate: delegate, model: model)
            default:
                view = ViewWearSmall(delegate: delegate, model: model)
            }
            
            model.updateViewWear(viewForUpdate: view)
            arrayView?.append(view)
            self.addSubview(view)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing: CGFloat = (typeWear == .Big ? 11 : 9)
        let width = (typeWear == .Big ? self.frame.width : self.frame.width * 0.637) - spacing * 2
        let count = self.arrayModels?.count.toCGFloat() ?? 0
        
        self.contentSize = CGSize(width: width * count + spacing * (count+1), height: self.frame.height)
        
        for view in arrayView! {
            let index = (arrayView?.firstIndex(of: view) ?? 0).toCGFloat()
            view.frame = CGRect(x: (width + spacing) * index + spacing,
                                y: 0, width: width,
                                height: self.frame.height)
        }
        
    }
}
