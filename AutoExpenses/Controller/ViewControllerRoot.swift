//
//  ViewControllerRoot.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewControllerRoot: ViewControllerThemeColor {

    private var scrollView: UIScrollView?
    private var viewSegmentView: ViewTopSegmentControll?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(rgb: 0x111624)
        self.viewSegmentView?.backgroundColor = UIColor.init(rgb: 0x111624)
        
        viewSegmentView = ViewTopSegmentControll(delegate: self, arrayNames: [/* "Здоровье", */ "Расходы", "Услуги"], indexSelected: 0)
        self.view.addSubview(viewSegmentView!)
        
        scrollView = UIScrollView()
//        scrollView?.tag = 11
//        scrollView?.isPagingEnabled = true
        self.view.addSubview(scrollView!)
        scrollView?.isScrollEnabled = false
            // Do any additional setup after loading the view, typically from a nib.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
//        let viewControllerHead = storyboard.instantiateViewController(withIdentifier: "viewControllerHealthCar") as! ViewControllerHealthCar
        let viewControllerStatisticExpenses = storyboard.instantiateViewController(withIdentifier: "viewControllerStatisticExpenses") as! ViewControllerStatisticExpenses
        let viewControllerServices = storyboard.instantiateViewController(withIdentifier: "viewControllerServices") as! ViewControllerServices
            
            
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height;

        scrollView?.frame = bounds
        scrollView!.contentSize = CGSize(width: 3 * width, height: height);
            
        let viewControllers = [/*viewControllerHead,*/ viewControllerStatisticExpenses, viewControllerServices]
        var idx:Int = 0
            
        for viewController in viewControllers {
            addChild(viewController)
            let originX: CGFloat = CGFloat(idx) * width;
            viewController.view.frame = CGRect(x: originX, y: 0, width: width, height: height)
            scrollView!.addSubview(viewController.view)
            viewController.didMove(toParent: self)
            idx+=1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewSegmentView?.frame = CGRect(x: 0, y: UIApplication.shared.keyWindow!.safeAreaInsets.top + 8, width: self.view.frame.width, height: 38)
        
        let pointYScroll = viewSegmentView!.frame.origin.y + viewSegmentView!.frame.height
        scrollView?.frame = CGRect(x: 0, y: pointYScroll, width: self.view.frame.width, height: self.view.frame.height - pointYScroll)
        scrollView!.contentSize = CGSize(width: 3 * self.view.frame.width, height: scrollView!.frame.height)
    }

}

//extension ViewControllerRoot: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let x = scrollView.contentOffset.x
//        let w = scrollView.bounds.size.width
//    }
//
//}
extension ViewControllerRoot: DelegateSelectedToIndex {
    func setIndex(index: Int) {
        
        UIView.animate(withDuration: 0.2) {
            self.scrollView?.contentOffset.x = self.view.frame.width * index.toCGFloat()
        }
    }

}

