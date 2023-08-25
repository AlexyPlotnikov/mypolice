//
//  ViewTopSegmentControll.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewTopSegmentControll: UIView {

    private var arraySegment: [SegmentView]?
    private var lineSelected: UIView?
    
//    private var myCarView: ViewMyCars?
//    private var viewTimerParking: ViewTimerParking?
    
    private var indexSelected: Int = 0
    private weak var delegate: DelegateSelectedToIndex?
    
    init(delegate: DelegateSelectedToIndex, arrayNames: [String], indexSelected: Int) {
        super.init(frame: CGRect.zero)
        
        self.indexSelected = indexSelected
        self.delegate = delegate
        setup(arrayNames: arrayNames)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(arrayNames: [String]) {
        
//        myCarView = ViewMyCars(text: "Toyota Camry", image: UIImage(named: "arrowSelectCar")!)
//        viewTimerParking = ViewTimerParking(text: "Таймер парковки", image: UIImage(named: "plusTimer")!)
//        for view in [myCarView, viewTimerParking] {
//            self.addSubview(view!)
//        }
        
        arraySegment = [SegmentView]()
        for name in arrayNames  {
            let segment = SegmentView(text: name)
            segment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedScreen(gesture:))))
            arraySegment?.append(segment)
            self.addSubview(segment)
        }
        
        lineSelected = UIView()
        lineSelected?.backgroundColor = .white
        lineSelected?.layer.cornerRadius = 3
        self.addSubview(lineSelected!)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
          
        for segment in arraySegment! {
            let index = arraySegment?.firstIndex(where: {(_segment) -> Bool in
                segment == _segment
            }) ?? 0
            
            let width = self.frame.width / (arraySegment?.count ?? 1).toCGFloat()
            segment.frame = CGRect(x: index.toCGFloat() * width, y: 0, width: width, height: 38)
            
        }
        lineSelected?.frame.size = CGSize(width: 33, height: 4)
        lineSelected?.frame.origin.y = arraySegment!.first!.pointSelected.y
        lineSelected?.center.x = arraySegment!.first!.pointSelected.x
        
//        let width = (self.frame.width - 12 - 11 / 2) / 2
//        let pointUp = arraySegment!.first!.frame.origin.y + arraySegment!.first!.frame.height + 5
//        myCarView?.frame = CGRect(x: 12, y: pointUp, width: width - 5, height: 40)
//        viewTimerParking?.frame = CGRect(x: myCarView!.frame.origin.x + myCarView!.frame.width + 11, y: pointUp, width: width - 5, height: 40)
        
        selectedScreen(gesture: arraySegment![indexSelected].gestureRecognizers!.first!)
    }
    
    
    @objc private func selectedScreen(gesture: UIGestureRecognizer) {
        
        let index = arraySegment?.firstIndex(where: { (label) -> Bool in
            label.gestureRecognizers!.first == gesture
        }) ?? 0
        
        self.delegate?.setIndex(index: index)
        
        for segment in arraySegment! {
            let _index = arraySegment?.firstIndex(of: segment)
            segment.selectedTab(select: index == _index)
        }
        
        let segmentSelected = arraySegment![index]
            UIView.animate(withDuration: 0.2) {
                self.lineSelected?.frame.origin.y = segmentSelected.pointSelected.y
                self.lineSelected?.center.x = segmentSelected.pointSelected.x
        }
    }

}
