//
//  TableViewCellUserInfo.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 29/05/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit



class TableViewCellUserInfo: UITableViewCell {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var info: UILabel!
    var dataUser : IAddInfoProtocol?
    private var button : UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func update() {
        updateDataFromDataUser(dataUser: self.dataUser!)
    }
    
    func initilization(dataUser : IAddInfoProtocol) {
        
//        if self.dataUser == nil {
            self.dataUser = dataUser
//        }
        
        self.updateDataFromDataUser(dataUser: dataUser)
//        }
        
        if button == nil {
            button = UIButton(frame: self.bounds)
            self.addSubview(button!)
            self.button?.addTarget(self, action: #selector(click), for: .touchUpInside)
        }
        
       
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let draw = DrawLine(view: self, setting: SettingDrawLine(pointStart: CGPoint(x: 28,
                                                                                     y: rect.height - 1 * 0.5),
                                                                 pointEnd: CGPoint(x: rect.width,
                                                                                   y: rect.height - 1 * 0.5),
                                                                 color: UIColor.init(rgb: 0xF4F4F4),
                                                                 lineWidth: 1))
        draw.drawLine()
    }
    
    func updateDataFromDataUser(dataUser: IAddInfoProtocol?) {
        self.header.text = dataUser!.headerField
        self.info.text = dataUser!.info
        self.icon?.image = dataUser!.icon
    }
   
    @objc func click() {
        if self.dataUser!.addInfo != nil {
            print("You can click")
            self.dataUser!.addInfo?(comletion: { (info) in
                self.info.text = info
            })
        }
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
////        super.setSelected(selected, animated: false)
//        if selected {
//            dataUser?.addInfo?(comletion: { (info) in
//                self.info.text = info
//            })
//        }
//    }

}
