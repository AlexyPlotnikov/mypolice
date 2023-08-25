//
//  TableViewCellSimpleButton.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 31/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellSimpleButton: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    private var handler : (()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initialization(handler: @escaping ()->Void) {
        self.handler = handler
        button.addTarget(self, action: #selector(editFunction(_:)), for: .touchUpInside)
    }
    
    @objc private func editFunction(_ sender: Any) {
        self.handler!()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let array = [DrawLine(view: self, setting: SettingDrawLine(pointStart: CGPoint(x: 0,
                                                                                       y: rect.height - 1.18 * 0.5),
                                                                   pointEnd: CGPoint(x: rect.width,
                                                                                     y: rect.height - 1.18 * 0.5),
                                                                   color: UIColor.init(rgb: 0xF4F4F4),
                                                                   lineWidth: 1.18)),
                     DrawLine(view: self, setting: SettingDrawLine(pointStart: CGPoint(x: 0,
                                                                                       y: 1.18 * 0.5),
                                                                   pointEnd: CGPoint(x: rect.width,
                                                                                     y: 1.18 * 0.5),
                                                                   color: UIColor.init(rgb: 0xF4F4F4),
                                                                   lineWidth: 1.18))]
        
        for item in array {
            item.drawLine()
        }
    }
    
}
