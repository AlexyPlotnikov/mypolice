//
//  ViewControllerEditionExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 15/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

enum TypeView {
    case Additional
    case Editional
}

class ViewControllerEditionExpenses: ViewControllerThemeColor {

    @IBOutlet weak var labelNameCategory: UILabel!
    @IBOutlet weak var iconCategory: UIImageView!
    @IBOutlet weak var bunttonBack: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var viewConteiner: UIView!
    private var heightViewForBias: CGFloat = 0
    private var category: BaseCategory?

    
    func setCategory(category: BaseCategory) {
        
        if let childVC = self.children.first as? ViewControllerTableViewExpenses {
            childVC.category = category
        }
        
        self.category = category
//        if category.typeView == .Additional {
//            self.clearAllField()
//        }
    }
    
    
    deinit {
        category = nil
        if let childVC = self.children.first as? ViewControllerTableViewExpenses {
                  childVC.category = nil
        }
        print("deinit VC")
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        LocalDataSource.editorExpensesViewController = nil
//        LocalDataSource.editorExpensesViewController = self
//        self.initilization()
//
//        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
//        self.view.addGestureRecognizer(gestureTap)
//
        self.bunttonBack.addTarget(self, action:  #selector(actionButtonCancel(_:)), for: .touchUpInside)
//
//        let drawLine = DrawLine(view: self.scrollView, setting: SettingDrawLine(pointStart: CGPoint(x: 0,
//                                                                                                    y: 0),
//                                                                                pointEnd: CGPoint(x: self.scrollView.frame.width,
//                                                                                                  y: 0),
//                                                                                color: UIColor.init(rgb: 0xEBEBED),
//                                                                                lineWidth: 0.5))
//        drawLine.drawLine()
        
//        self.labelNameCategory.text = self.category.headerField
//        self.iconCategory.image = self.category.iconCategory
    }
    
    func checkScrollContentOffset(offsetY: CGFloat) {
        
        UIView.animate(withDuration: 0.3) {
            if offsetY > 30 {
                self.labelNameCategory.alpha = 1
            }
            else if offsetY < 1 {
                self.labelNameCategory.alpha = 0
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let childVC = self.children.first as? ViewControllerTableViewExpenses {
            childVC.category = self.category
        }
        
        labelNameCategory.text = category?.headerField
        iconCategory.image = category?.iconCategoryActivate
        self.buttonSave.setTitle("Сохранить", for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.category?.clearAllField()
        //TODO: Analytic
        AnalyticEvents.logEvent(.OpenEditionExpense, params: ["Category" : self.category?.headerField ?? "No category"])
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        UIView.animate(withDuration: 0.3) {
//            if scrollView.contentOffset.y > 30 {
//                self.labelNameCategory.alpha = 1
//            }
//            else if scrollView.contentOffset.y < 1 {
//                self.labelNameCategory.alpha = 0
//            }
//        }
//    }
    
//    func deleteExpenses() {
//        let alert = UIAlertController(title: "Удаление", message: "Хотите удалить расход?", preferredStyle: .alert)
//        let actionDelete = UIAlertAction(title: "Удалить", style: .destructive) { (UIAlertAction) in
//            self.reloadDateCategory()
//            self.category.deleteDataBaseFindToDate()
//            self.actionButtonCancel(UIButton())
//        }
//
//        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//
//        alert.addAction(actionDelete)
//        alert.addAction(actionCancel)
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    //  функция закрытия клавиатуры по нажатию на экран
//    @objc private func tapScreen() {
//        self.view.endEditing(true)
//    }

    
    @objc func actionButtonCancel(_ sender: UIButton) {
//         self.category = nil
         _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func actionButtonSave(_ sender: UIButton) {
      
        if let childVC = self.children.first as? ViewControllerTableViewExpenses {
            childVC.saveExpenses { (state) in
                if state {
                    _ = self.navigationController?.popViewController(animated: true)
                    LocalDataSource.statisticViewController.update = true
                }
            }
        }
    }
}

