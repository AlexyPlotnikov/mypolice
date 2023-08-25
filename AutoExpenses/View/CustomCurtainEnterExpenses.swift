//
//  CustomCurtainEnterExpenses.swift
//  
//
//  Created by Иван Зубарев on 05/08/2019.
//

import UIKit


struct LineStructBezier {
    var bezierPress: [UIBezierPath]?
    var layers: [CAShapeLayer]?
}

class CustomCurtainEnterExpenses: UIView {
    
    private var lineToSwipe: UIView?
    private var scrollToFrameCategory: UIScrollView?
    private var pointTouch: CGFloat = 0.0
    private var buttonSaveExpenses: UIButton?
    private var buttonScanQR: UIButton?
    private var viewConteiner: UIView?
    private var viewMask: UIView?
    private var heightKeyboard: CGFloat = 0
    
    var statePanel:  ModelCustomCurtain.StatePanelExpenses = .Low {
        willSet (state) {
           checkPos(state: state)
        }
    }
    
    private var first : Bool = true
    weak var delegate: DelegateSwipePanelExpenses?
    private var arrayButtonOfCategory: [ButtonIconAndTitle] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    

    func checkPos(state: ModelCustomCurtain.StatePanelExpenses) {
        
        let padding: CGFloat = 3
        let count: CGFloat = UIScreen.main.bounds.width <= 320 ? 4 : 3.5
        let heightElem = UIDevice.current.userInterfaceIdiom != .pad ? (self.frame.width - 32 - padding * count) / 4 : (self.frame.width - 32 - padding * 8) / 8
        
        switch state {
        case .Low, .Top:
            UIView.animate(withDuration: 0.3) {
                self.viewConteiner?.alpha = state == .Low ? 0 : 1
                
                self.scrollToFrameCategory?.frame = CGRect(x: 16,
                                                           y: self.lineToSwipe!.frame.origin.y + self.lineToSwipe!.frame.height + 8,
                                                           width: self.frame.width - (32),
                                                           height: heightElem )
                
                if self.arrayButtonOfCategory.count > 0 {
                    for btn in self.arrayButtonOfCategory {
                        let numX = self.arrayButtonOfCategory.firstIndex(of: btn) ?? 0
                        
                        btn.frame = CGRect(x: (heightElem + padding) * numX.toCGFloat(),
                                           y: self.scrollToFrameCategory!.bounds.origin.y + padding,
                                           width: heightElem,
                                           height: heightElem - padding)
                        
                    }
                    self.scrollToFrameCategory?.contentSize = CGSize(width: (heightElem + padding) * self.arrayButtonOfCategory.count.toCGFloat() - padding, height: self.scrollToFrameCategory!.frame.height)
                }
            }
            
        case .Middle:
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                return
            }
            
            UIView.animate(withDuration: 0.3) {
                self.viewConteiner?.alpha = 0
                self.scrollToFrameCategory?.frame = CGRect(x: 16,
                                                           y: self.lineToSwipe!.frame.origin.y + self.lineToSwipe!.frame.height + 8,
                                                           width: self.frame.width - (32),
                                                           height: (heightElem + padding) * 2)
                
                self.scrollToFrameCategory?.contentOffset = CGPoint.zero
                
                if self.arrayButtonOfCategory.count > 0 {
                    var numX = 0
                    var numY = 0
                    for btn in self.arrayButtonOfCategory {
                        
                        if numX > 3 {
                            numY += 1
                            numX = 0
                        }
                        
                        btn.frame = CGRect(x: self.scrollToFrameCategory!.bounds.origin.x + (heightElem + padding) * numX.toCGFloat(),
                                           y: self.scrollToFrameCategory!.bounds.origin.y + (heightElem + padding) * numY.toCGFloat(),
                                           width: heightElem,
                                           height: heightElem - padding)
                        numX += 1
                    }
                    self.scrollToFrameCategory?.contentSize = self.scrollToFrameCategory!.frame.size
                }
            }
        }
    }
    
    
    // натификашка вызова клавиатуры
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.heightKeyboard = keyboardHeight
            
            if statePanel == .Middle {
                movePanel(statePanel:.Top)
            }
        }
    }
    
    @objc func keyboardHide(_ notification: Notification) {
        heightKeyboard = 0
    }
    
    
    func scrollingPanelCategorys (index: Int) {
        if  UIDevice.current.userInterfaceIdiom == .pad || statePanel == .Middle  {
            return
        }
        
        let countCellInScroll: Int = Int(self.scrollToFrameCategory!.frame.width / (self.arrayButtonOfCategory[index].frame.width))
        let point = self.arrayButtonOfCategory[index].frame.origin.x - self.arrayButtonOfCategory[index].frame.width
        UIView.animate(withDuration: 0.5, animations: {

            if point > self.scrollToFrameCategory!.frame.width && index > self.arrayButtonOfCategory.count - countCellInScroll {
                self.scrollToFrameCategory?.contentOffset.x = self.arrayButtonOfCategory[self.arrayButtonOfCategory.count - countCellInScroll].frame.origin.x
            } else {
                self.scrollToFrameCategory?.contentOffset.x = self.arrayButtonOfCategory[index].frame.origin.x
            }
        }) {(complete) in
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initialization() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)),name:UIResponder.keyboardWillHideNotification,object: nil)
        
        if let viewConteiner = self.viewWithTag(1) {
            self.viewConteiner = viewConteiner
        }
        
        if let viewMask = self.viewWithTag(2) {
            self.viewMask = viewMask
        }
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_ :))))

        buttonSaveExpenses = UIButton()
        buttonSaveExpenses?.setImage(UIImage(named: "checkButton"), for: .normal)
        buttonSaveExpenses?.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        self.addSubview(buttonSaveExpenses!)
        
        lineToSwipe = UIView()
        lineToSwipe?.layer.cornerRadius = 3
        lineToSwipe?.backgroundColor = UIColor.init(rgb: 0xD2D0D0)
        self.addSubview(lineToSwipe!)
        
        scrollToFrameCategory = UIScrollView()
        scrollToFrameCategory?.backgroundColor = .clear

        scrollToFrameCategory?.showsHorizontalScrollIndicator = false
        self.addSubview(scrollToFrameCategory!)
        
        for item in LocalDataSource.arrayCategory as! [BaseCategory] {
            let btn = ButtonIconAndTitle(category: item)
            btn.addTarget(self, action: #selector(tapCategory(_:)), for: .touchUpInside)
            self.arrayButtonOfCategory.append(btn)
            self.scrollToFrameCategory?.addSubview(btn)
        }
        
        self.viewMask?.bringSubviewToFront(self)
        tapCategory(nil)
    }
    
    @objc private func saveData () {
        if delegate != nil {
            delegate!.savingData()
        }
    }

    
    @objc private func tapCategory(_ sender: ButtonIconAndTitle?) {

        let index = arrayButtonOfCategory.firstIndex(of: sender ?? arrayButtonOfCategory[0])
        for btn in arrayButtonOfCategory {
                if sender != nil && statePanel == .Low {
                    movePanel(statePanel: .Middle)
                }
            btn.setStateBtn(select: arrayButtonOfCategory.firstIndex(of: btn) == index)
        }
        
        if delegate != nil {
            let nameCategory = (LocalDataSource.arrayCategory as! [BaseCategory])[index!].headerField
            delegate!.setCategory(category: (LocalDataSource.arrayCategory as! [BaseCategory])[index!])
            
            // TODO: Analytics
            AnalyticEvents.logEvent(.SelectedCategory,params: ["Category": nameCategory])
        }
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {

        let pointLowY = self.superview!.frame.height - 133
        let pointHeightY = self.superview!.frame.origin.y + 50
        let pointMiddleY = self.superview!.frame.height - (self.scrollToFrameCategory!.frame.origin.y + ((self.frame.width - 32 + 6) / 4) * 2) - 16
        
        let array = UIDevice.current.userInterfaceIdiom == .pad ? [pointHeightY, pointLowY] : [pointHeightY, pointMiddleY ,pointLowY]
        let oneHeightSegment = (pointLowY-pointHeightY) / (self.frame.height / array.count.toCGFloat())
        var num = (self.frame.origin.y * oneHeightSegment) / (pointLowY - pointHeightY)
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            if pointTouch == 0 {
                pointTouch = self.frame.origin.y
                print("touch \(pointTouch)")
            }
            
            let translation = gestureRecognizer.translation(in: self)
            let nextPos = gestureRecognizer.view!.center.y + translation.y
            
            if self.frame.origin.y < 0 || self.frame.origin.y > pointLowY * 1.7 {
                gestureRecognizer.state = .ended
            }
    
            gestureRecognizer.view!.center = CGPoint(x: self.bounds.midX, y: nextPos)
            gestureRecognizer.setTranslation(CGPoint(x: 0,y: 0), in: self)
            
            UIView.animate(withDuration: 0.2) {
                self.buttonSaveExpenses?.frame.origin.y = self.superview!.frame.height
                
                if self.statePanel == .Low && self.frame.origin.y < pointLowY {
                    self.scrollToFrameCategory?.contentOffset = CGPoint.zero
                }
            }
            
            self.endEditing(true)
            
        } else if gestureRecognizer.state == .ended {
            if self.frame.origin.y < pointTouch {
                num -= 0.4
            } else {
                num += 0.3
            }
            pointTouch = 0
            
            if Int(num) > array.count - 1 {
                num = (array.count - 1).toCGFloat()
            }
            
            if Int(num) < 0 {
                num = 0.toCGFloat()
            }
            
            if delegate != nil {
                self.statePanel = ModelCustomCurtain.StatePanelExpenses(rawValue: Int(num))!
                delegate?.setStatePanelExpenses(state: ModelCustomCurtain.StatePanelExpenses(rawValue: Int(num))!, valuePointY: array[Int(num)])
            }
            
            movePanel(value: array[Int(num)], animated: true)
        
        }
    }
    
    
    func movePanel(value: CGFloat, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.35, animations: {
                self.frame.origin = CGPoint(x: 0, y: value)
                self.buttonSaveExpenses?.frame.origin.y = self.statePanel == .Low || self.statePanel == .Middle ? self.superview!.frame.height : self.superview!.frame.height - self.frame.origin.y - (self.frame.width * 0.25 + 8)
            }, completion: { (state) in
                UISelectionFeedbackGenerator().selectionChanged()
            })
        } else {
            self.frame.origin = CGPoint(x: 0, y: value)
            self.buttonSaveExpenses?.frame.origin.y = self.statePanel == .Low || self.statePanel == .Middle  ? self.superview!.frame.height : self.superview!.frame.height - self.frame.origin.y - (self.frame.width * 0.25 + 8)
        }
    }
    
    func movePanel(statePanel: ModelCustomCurtain.StatePanelExpenses) {
        
        let pointLowY = self.superview!.frame.height - 133
        let pointHeightY = self.superview!.frame.origin.y + 50
        let pointMiddleY = self.superview!.frame.height - (self.scrollToFrameCategory!.frame.origin.y + ((self.frame.width - 32 + 10) / 4) * 2) - 16
        
        
                switch statePanel {
                case .Low:
                    UIView.animate(withDuration: 0.35, animations: {
                        self.frame.origin = CGPoint(x: 0, y: pointLowY)
                        self.buttonSaveExpenses?.frame.origin.y = self.superview!.frame.height
                    }, completion: { (state) in
//                        UISelectionFeedbackGenerator().selectionChanged()
                    })
                    if self.delegate != nil {
                        self.delegate?.setStatePanelExpenses(state: .Low, valuePointY: pointLowY)
                    }
                    
                case .Middle:
                    UIView.animate(withDuration: 0.35, animations: {
                        self.frame.origin = CGPoint(x: 0, y: pointMiddleY)
                        self.buttonSaveExpenses?.frame.origin.y = self.superview!.frame.height
                    }, completion: { (state) in
//                        UISelectionFeedbackGenerator().selectionChanged()
                    })
                    if self.delegate != nil {
                        self.delegate?.setStatePanelExpenses(state: .Middle, valuePointY: pointMiddleY)
                    }
                case .Top:
                    UIView.animate(withDuration: 0.35, animations: {
                        self.frame.origin = CGPoint(x: 0, y: pointHeightY)
                        self.buttonSaveExpenses?.frame.origin.y = self.superview!.frame.height - self.frame.origin.y - (self.frame.width * 0.25 + 8)
                    }, completion: { (state) in
//                        UISelectionFeedbackGenerator().selectionChanged()
                    })
                    
                    
                 
                    
                    if self.delegate != nil {
                        self.delegate?.setStatePanelExpenses(state: .Top, valuePointY: pointHeightY)
                    }
            }
        
         self.statePanel = statePanel

    }
    
    func startSettings() {
        movePanel(statePanel: self.statePanel)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if !first {
            return
        } else {
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.frame
            rectShape.position = self.center
            rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight , .topLeft], cornerRadii: CGSize(width: 22, height: 22)).cgPath
            self.viewMask!.layer.mask = rectShape
            
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 5
            first = false
        }
       
        let widthLine: CGFloat = 30
        lineToSwipe?.frame = CGRect(x: self.frame.midX - widthLine * 0.5,
                                    y: 9,
                                    width: widthLine,
                                    height: 5)
        
        if  UIDevice.current.userInterfaceIdiom == .pad {
            let heightElem = (self.frame.width - 32 - 3 * 8) / 8
            scrollToFrameCategory?.frame = CGRect(x: 16,
                                                  y: lineToSwipe!.frame.origin.y + lineToSwipe!.frame.height + 16,
                                                  width: heightElem + 3,
                                                  height: heightElem + 3)
            
            scrollToFrameCategory?.contentSize.width = (heightElem + 3) * 8
        }
        
        buttonSaveExpenses?.frame = CGRect(x: self.frame.midX - (self.frame.width * 0.25) * 0.5,
                                           y: self.superview!.frame.height - (self.frame.width * 0.25 + 8),
                                           width: self.frame.width * 0.25,
                                           height: self.frame.width * 0.25)
        
       
        self.frame.size = rect.size
        self.viewMask!.frame.size = rect.size
        self.viewConteiner?.frame = CGRect(x: 0,
                                           y: scrollToFrameCategory!.frame.maxY + 20,
                                           width: self.frame.width,
                                           height: (self.frame.height - self.buttonSaveExpenses!.frame.height) - scrollToFrameCategory!.frame.maxY)

      
        
        startSettings()
        
    }
    

}
