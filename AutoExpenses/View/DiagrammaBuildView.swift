//
//  ScrollMonth.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 29/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


class DiagrammaBuildView: UIView, UIScrollViewDelegate {

    var scrollMonth: UIScrollView?
    var scrollDiagramm : UIScrollView!
    lazy var indexMonth = Calendar.current.dateComponents([.month], from: Date()).month!
    var pageControl : UIPageControl!
    weak var delegateReloadData: DelegateReloadData?
    lazy var arrayMonth: [UILabel] = []
    
    lazy private var widthLabel = CGFloat()
    lazy private var heightLabel = CGFloat()
    lazy private var centerPointX = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        intialization()
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        intialization()
    }

    func createDiagramms(arrayCategory: [BaseCategory]) {

        for diagramm in self.scrollDiagramm.subviews where diagramm is ScaleGraphic {
            diagramm.removeFromSuperview()
        }
        
        if arrayCategory.count <= 0 {
            return
        }
        
        // получаем максимальную сумму
        let manager = ManagerCategory(category: arrayCategory[0])
        var maxSum = manager.getAllSum(year_month:SelectedDate.shared.getDate())
        for _ in arrayCategory where manager.getAllSum(year_month: SelectedDate.shared.getDate()) >= maxSum {
            maxSum = manager.getAllSum(year_month: SelectedDate.shared.getDate())
        }
        
        
        let widthView = self.scrollDiagramm.frame.width * 0.2
        var padding: CGFloat = self.scrollDiagramm.frame.width * 0.01
        
        self.scrollDiagramm.contentSize.width = (widthView + padding) * (arrayCategory.count).toCGFloat()
        
        // проверка для определения колличества категорий если они вмещаются в ширину экрана
        if self.scrollDiagramm.contentSize.width < self.scrollDiagramm.frame.width {
            padding = (self.scrollDiagramm.frame.width - (widthView * arrayCategory.count.toCGFloat())) / (arrayCategory.count+1).toCGFloat()
        }
        
        self.scrollDiagramm.showsHorizontalScrollIndicator = false
        let coef = (self.scrollDiagramm.frame.height) / CGFloat(maxSum)
        
        for i in 0..<arrayCategory.count {
            
            var length = CGFloat(ManagerCategory(category: arrayCategory[i]).getAllSum(year_month: SelectedDate.shared.getDate())) * coef
            
            // задаем минимальный размер для графика для того что бы минимальное значение было видно
            length = length < self.scrollDiagramm.frame.height * 0.01 ? self.scrollDiagramm.frame.height * 0.01 : length

            
            let graphic = ScaleGraphic(frame: CGRect(x: padding + (widthView + padding) * CGFloat(i),
                                               y: 0,
                                               width: widthView,
                                               height: self.scrollDiagramm.frame.height))
            
            graphic.building(category: arrayCategory[i], length: length)
            self.scrollDiagramm.addSubview(graphic)
        }
    }
    
    
    func intialization() {
        
        
        if self.scrollMonth == nil {
            // scroll month
            self.scrollMonth = UIScrollView()
            self.scrollMonth?.layer.masksToBounds = false
            self.scrollMonth?.showsHorizontalScrollIndicator = false
            self.scrollMonth?.isPagingEnabled = true
            
            scrollMonth!.delegate = self
            scrollMonth!.isPagingEnabled = true
            scrollMonth?.backgroundColor = .clear
            self.addSubview(self.scrollMonth!)
        }
        
        // scroll diagramm
        if self.scrollDiagramm == nil {
            self.scrollDiagramm = UIScrollView()
            self.addSubview(self.scrollDiagramm!)
        }
            
        var num: Int = 0
        for nameMonth in SelectedDate.shared.getArrayMonthName() {
            let label = UILabel()
            label.text = nameMonth
            label.textAlignment = .center
            self.scrollMonth!.addSubview(label)
            num+=1
            arrayMonth.append(label)
        }
        
        if self.pageControl == nil {
            self.pageControl = UIPageControl()
            self.pageControl.numberOfPages = SelectedDate.shared.getArrayMonthName().count
            self.pageControl.isUserInteractionEnabled = false
            self.pageControl.pageIndicatorTintColor = UIColor.init(rgb: 0xD5974E)
            self.pageControl.currentPageIndicatorTintColor = UIColor.black
            self.addSubview(pageControl)
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
      //  widthLabel = self.frame.width * 0.5
        heightLabel = self.frame.height * 0.15
        centerPointX = (self.center.x - widthLabel)
        
        self.pageControl.frame = CGRect(x: 0, y: heightLabel*0.8, width: self.frame.width, height: heightLabel * 0.5)
        
        self.scrollMonth!.frame = CGRect(x: 0,
                                        y: 0,
                                        width: self.frame.width,
                                        height: self.frame.height)
        self.scrollMonth?.contentSize.width = self.frame.width * (CGFloat(SelectedDate.shared.getArrayMonthName().count))
        
        self.scrollDiagramm.frame = CGRect(x: 0,
                                           y: heightLabel+heightLabel*0.3,
                                           width: self.frame.width,
                                           height: self.frame.height - (heightLabel+heightLabel*0.3))
        
        for label in arrayMonth {
            let index = arrayMonth.lastIndex(of: label)
            label.frame = CGRect(x: self.frame.width * CGFloat(index!),
                                 y: 0,
                                 width: self.frame.width,
                                 height: heightLabel)
        }
        
        setPositionScroll()
    }
    
    
    func setPositionScroll() {
        
        scrollMonth?.contentOffset.x = self.scrollMonth!.frame.size.width * CGFloat(indexMonth-1)
        scrollViewDidEndDecelerating(scrollMonth!)
    }
    
// MARK: TO CHANGE WHILE CLICKING ON PAGE CONTROL
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let index = Int(x/w)
        self.pageControl.currentPage = index
        
        if indexMonth == (index + 1) {
            return
        }
        
        indexMonth = index + 1
        print("indexMonth = \(indexMonth)")
        let arrayLabels = self.scrollMonth!.subviews
        for label in arrayLabels where label is UILabel {
            (label as! UILabel).textColor = .lightGray
            let alphaLabel : CGFloat = arrayLabels.lastIndex(of: label) == index ? 1.0 : 0.3
            (label as! UILabel).alpha = alphaLabel
            (label as! UILabel).font = UIFont(name: (arrayLabels.lastIndex(of: label) == index ? "HelveticaNeue-Bold" : "HelveticaNeue-Light"), size: 14.0)
        }
        
        self.delegateReloadData?.updateData()
    }
}

