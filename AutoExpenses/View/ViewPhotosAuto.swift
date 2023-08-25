//
//  ScrollPhotoAuto.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 01/04/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewPhotosAuto: UIView {
    
    weak var delegate: DelegateReloadData?
    var arrayPhotoCar: [PhotoView] = []
    var pageControl: UIPageControl?
    var scrollView: UIScrollView?
    private var gradientLayer: CAGradientLayer?
    private var shape: CAShapeLayer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    // добавление нового авто
    func addNewCar(index: Int, updatePosition: Bool) {
        let photoView = PhotoView(frame: CGRect(x: self.frame.width * CGFloat(index),
                                                y: 0,
                                                width: self.frame.width,
                                                height: self.frame.height))
        photoView.setImage(index: index)
        self.scrollView!.addSubview(photoView)
        self.arrayPhotoCar.append(photoView)
        
        if updatePosition {
            self.setScrollOffset(index: self.arrayPhotoCar.count-1)
            self.updateScroll()
        }
    }
    
    // обновление скрола расстановка новых элементов
    func updateScroll() {
       
        UIView.animate(withDuration: 0.3) {
            self.scrollView!.contentSize.width = self.frame.width * self.arrayPhotoCar.count.toCGFloat()
        }
       
        for photo in arrayPhotoCar {
            let index = arrayPhotoCar.lastIndex(of: photo)
            photo.frame = CGRect(x: self.frame.width * CGFloat(index ?? 0),
                                                    y: 0,
                                                    width: self.frame.width,
                                                    height: self.frame.height)
            photo.setImage(index: index!)
        }
        
        self.pageControl?.numberOfPages = arrayPhotoCar.count
        self.scrollView?.delegate?.scrollViewDidEndDecelerating!(self.scrollView!)
        
        UIView.animate(withDuration: 0.5) {
            self.pageControl?.alpha = self.arrayPhotoCar.count < 2 ? 0.0 : 0.7
        }
        setScrollOffset()
    }
    
    // удаление авто по индексу
    func deleteCar(index: Int) {
        arrayPhotoCar[index].removeFromSuperview()
        arrayPhotoCar.remove(at: index)
        
        self.updateScroll()
        self.setScrollOffset(index: self.arrayPhotoCar.count-1)
    }
    
    
    // инициализация
    private func initialization() {
        if self.scrollView == nil {
            self.scrollView = UIScrollView()
            self.scrollView!.isPagingEnabled = true
            self.scrollView!.backgroundColor = .clear
            self.scrollView!.showsHorizontalScrollIndicator = false
            self.addSubview(self.scrollView!)
        }
        
        let entity = EntityCarUser()
        for i in 0..<entity.getAllDataFromDB().count {
            addNewCar(index: i, updatePosition: false)
        }
        
        if self.pageControl == nil {
            self.pageControl = UIPageControl()
            self.pageControl?.currentPageIndicatorTintColor = UIColor.init(rgb: 0xDDFFAF)
            self.pageControl?.pageIndicatorTintColor = .white
            self.pageControl?.isUserInteractionEnabled = false
            self.addSubview(self.pageControl!)
        }
        
//        if self.gradientLayer == nil {
//            self.gradientLayer = CAGradientLayer()
//            self.gradientLayer!.colors = [UIColor.white.cgColor,UIColor.gray.cgColor]
//            self.gradientLayer!.locations = [0.0, 1.0]
//            self.pageControl?.layer.insertSublayer(self.gradientLayer!, at: 0)
//
//            self.shape = CAShapeLayer()
//        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.scrollView!.frame = CGRect(x: 0,
                                        y: 0,
                                        width: rect.width,
                                        height: rect.height)
        let height = rect.height * 0.15
        self.pageControl!.frame = CGRect(x: 0,
                                         y: rect.height - height,
                                         width: rect.width,
                                         height: height)
        
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 10)
        self.layer.shadowOpacity = 2
        self.layer.shadowRadius = 12
        
//        self.gradientLayer!.frame = self.pageControl!.bounds
        self.setScrollOffset()
        self.updateScroll()
        
//        shape!.bounds = self.frame
//        shape!.position = self.center
//        shape!.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 14, height: 14)).cgPath
//        self.layer.mask = shape
        
        if delegate != nil {
            delegate?.updateData()
        }
    }
    
    
    // установка скролла на выбранный объект
    private func setScrollOffset() {
        let entity = EntityCarUser()
        
        for item in entity.getAllDataFromDB() where item.select {
            let index = entity.getAllDataFromDB().index(of: item) ?? 0
            self.pageControl?.currentPage = index
            
            UIView.animate(withDuration: 0.3) {
                self.scrollView!.contentOffset = CGPoint(x: self.frame.width * (index).toCGFloat(), y: 0)
            }
        }
    }
    
    // установка скролла на объект с заданным индексом
    private func setScrollOffset(index: Int) {
        self.pageControl?.currentPage = index
        UIView.animate(withDuration: 0.3) {
            self.scrollView!.contentOffset = CGPoint(x: self.frame.width * (index).toCGFloat(), y: 0)
        }
    }
    
}
