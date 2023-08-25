//
//  TableViewCellCategory.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


class TableViewCellExpenses: UITableViewCell {
    
    @IBOutlet private weak var iconExpense: UIImageView!
    @IBOutlet private weak var nameCategory: UILabel!
    @IBOutlet private weak var sum: UILabel!
    @IBOutlet private weak var buttonClickCell: UIButton!
    private var iconPapperPhoto: UILabel?
    private var category: BaseCategory?
    
    func initialization(category: BaseCategory, delegate: DelegateShowViewController) {
        self.category = category
        self.category!.delegateShowViewController = delegate
        nameCategory.text = self.category!.dateField?.date?.toString()
        sum.text = self.category!.sumField?.sum.roundTo(places: 0).formattedWithSeparator
        sum.setNewChar(newAttr: NewAttrChar(color: UIColor.black.withAlphaComponent(0.45), font: UIFont(name: "SFUIDisplay-Medium", size: 15)!, char: " ₽"), standartColor: UIColor.black)
        
        if (iconPapperPhoto == nil) {
            self.iconPapperPhoto = UILabel()
            self.iconPapperPhoto!.textAlignment = .center
            self.iconPapperPhoto?.backgroundColor = UIColor.init(rgb: 0xD8E3FF)
            self.iconPapperPhoto?.layer.cornerRadius = 12
            self.iconPapperPhoto?.font = UIFont(name: "SFUIDisplay-Bold", size: 11)
            self.iconPapperPhoto?.textColor = UIColor.init(rgb: 0x447AFF)
            self.iconPapperPhoto?.layer.masksToBounds = true
            self.iconPapperPhoto?.layer.borderColor = UIColor.white.cgColor
            self.iconPapperPhoto?.layer.borderWidth = 2
            self.addSubview(iconPapperPhoto!)
        }
        
        self.iconPapperPhoto!.isHidden = self.category!.photo!.isEmpty()
        self.iconPapperPhoto!.text = self.category!.photo!.arrayPhotos?.count.toString()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let draw = DrawLine(view: self,
                            setting: SettingDrawLine(pointStart: CGPoint(x: 28,
                                                                         y: rect.height - 0.5),
                                                     pointEnd: CGPoint(x: rect.width,
                                                                       y: rect.height - 0.5),
                                                     color: UIColor.init(rgb: 0xF4F4F4),
                                                     lineWidth: 1))
        draw.drawLine()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconPapperPhoto?.frame = CGRect(x: self.iconExpense.center.x,
                                             y: self.iconExpense.frame.origin.y - self.iconExpense.frame.width * 0.25,
                                             width: self.iconExpense.frame.width * 0.65,
                                             height: self.iconExpense.frame.width * 0.5)
        
    }
    

    @IBAction func actionClick(_ sender: Any) {
        self.category!.click(typeView: .Editional)
    }

}
