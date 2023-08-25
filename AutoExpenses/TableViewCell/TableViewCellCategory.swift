//
//  TableViewCellCategory.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


class TableViewCellCategory : UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameCategory: UILabel!
    @IBOutlet weak var sum: UILabel!
    @IBOutlet weak var buttonClickCell: UIButton!
    @IBOutlet weak var backViewProgress: UIView!
    private weak var vc: UIViewController?
    private var viewProgress: UIView!
    private var fullValue: Float = 0.0
    private var model: ModelSegment?
    var category : BaseCategory?
    
    var structDate: StructDateForSelect {
        return StructDateForSelect(year: (SelectedDate.shared.getDate()[.YearString] as! String).toInt(), month: SelectedDate.shared.getSelectedIndexMonth())
    }
    
    var isEmptyExpenses: Bool {
        return ManagerCategory(category: category!).getAllSum(year_month: structDate) == Float(0.0)
    }
    
    func initialization(category: BaseCategory, vc: UIViewController, modelSegment: ModelSegment, fullValue: Float) {
        self.category = category
        self.vc = vc
        self.icon.image = category.iconCategoryActivate
        self.nameCategory.text = category.headerField
        self.model = modelSegment
        self.fullValue = fullValue
        
        self.backViewProgress.layer.cornerRadius = 4
        self.backViewProgress.layer.masksToBounds = true
        
        self.buttonClickCell.isHidden = isEmptyExpenses
        buttonClickCell.removeTarget(self, action: nil, for: .allEvents)
        self.buttonClickCell.addTarget(self, action: #selector(actionClick(_:)), for: .touchUpInside)
    }
    
    private func buildLine() {
        
        if self.viewProgress == nil {
            self.viewProgress = UIView()
            self.backViewProgress.addSubview(self.viewProgress)
            self.viewProgress.layer.cornerRadius = 4
        }
        
        self.sum.text = Float((model?.value ?? 0)).roundTo(places:0).formattedWithSeparator
        self.sum.setNewChar(newAttr: NewAttrChar(color: UIColor.black.withAlphaComponent(0.45),
                                                 font: UIFont(name: "SFUIDisplay-Medium", size: 15)!,
                                                 char: " ₽"), standartColor: UIColor.black)
        self.viewProgress.backgroundColor = model?.color
        self.viewProgress.frame.size = CGSize(width: 0, height: self.backViewProgress.bounds.height)
        let value = fullValue == 0 ? 0 : (self.backViewProgress.bounds.width / CGFloat(self.fullValue)) * CGFloat(self.model!.value)
        
        UIView.animate(withDuration: 0.5) {
            self.viewProgress.frame = CGRect(x: 0,
                                             y:  0,
                                             width: value,
                                             height: self.backViewProgress.bounds.height)
        }
    }

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.buildLine()
        let line = DrawLine(view: self, setting: SettingDrawLine(pointStart: CGPoint(x: 28,
                                                                                    y: rect.height - 0.5),
                                                                 pointEnd: CGPoint(x: rect.width,
                                                                                    y: rect.height - 0.5),
                                                                     color: UIColor.init(rgb: 0xF3F4F5),
                                                                 lineWidth: 1))
        line.drawLine()
    }
    
    @objc func actionClick(_ sender: Any) {
        let vcForShow = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerListExpenessWithCategory") as! ViewControllerListExpenessWithCategory
        vcForShow.manager = ManagerCategory(category: self.category!)
        self.vc!.navigationController?.pushViewController(vcForShow, animated: true)
    }

}
