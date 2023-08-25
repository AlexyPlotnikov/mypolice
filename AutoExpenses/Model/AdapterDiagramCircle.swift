//
//  AdapterDiagramCircle.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 09/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

struct ModelSegment {
    var color: UIColor?
    var value: Float = 0.0
}

class AdapterDiagramCircle: IViewControll {
   
    var viewCircle: ChartDiagrammExpenses?
    private weak var viewParent: UIView?

    private var type: ChartDiagrammExpenses.TypeChart?
    private var rect : CGRect?

    private var segments: [ModelSegment] = [] {
        didSet (models) {
               segments.removeAll()
        }
    }
   
    
    init(in view: UIView, rect: (CGRect?) = nil , segments: [ModelSegment], type: ChartDiagrammExpenses.TypeChart) {
        self.rect = rect
        self.viewParent = view
        self.segments = segments
        self.type = type
    }
    
    deinit {
        print(self)
    }
    
    func create() {
        self.viewCircle = nil
        self.viewCircle = ChartDiagrammExpenses(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: rect!.width,
                                                              height: rect!.height), segments: self.segments, type: self.type!)

        self.viewParent!.insertSubview(viewCircle!, at: 0)
    }
    
    
    
    func delete() {
        if viewCircle != nil {
            viewCircle?.removeFromSuperview()
            self.viewCircle = nil
        }
    }
    
    

    func update() {
        self.viewCircle!.frame = self.rect ?? self.viewParent!.bounds
       
    }
    

}
