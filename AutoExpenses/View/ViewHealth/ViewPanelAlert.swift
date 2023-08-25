//
//  ViewAlertWriteStation.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 27.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewPanelAlertBase: UIView {
    
    var button: UIButton?
    var viewUp: UIView?
   
    override init(frame: CGRect) {
           super.init(frame: frame)
           setNeedsLayout()
           initialization()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
            initialization()
    }
    
    
    func initialization() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        
        viewUp = UIView()
        viewUp?.backgroundColor = UIColor.init(rgb: 0xD8D8D8)
        viewUp?.layer.cornerRadius = 3
        self.addSubview(viewUp!)
        
        button = UIButton()
        button?.setTitle("Записаться на сервис", for: .normal)
        button?.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
        button?.setTitleColor(.black, for: .normal)
        button?.backgroundColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0.2588235294, alpha: 1)
        button?.layer.cornerRadius = 26
//        button?.addTarget(self, action: #selector(write), for: .touchUpInside)
        self.addSubview(button!)
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewUp?.frame = CGRect(x: self.frame.midX - 15, y: 12, width: 30, height: 5)
    
        
        let heightButton: CGFloat = 52
        button?.frame = CGRect(x: 16, y: self.frame.height - (21 + heightButton), width: self.frame.width - 16 * 2, height: heightButton)
    }
}

class ViewPanelAlert: ViewPanelAlertBase {

    var labelHeader: UILabel?
    var labelSubHeader: UILabel?
    var labelMini: UILabel?
    var wearMileage: ViewShowWear?
    var wearTime: ViewShowWear?
    
    
    
    override func initialization() {
        super.initialization()
        
        labelHeader = UILabel()
        labelHeader?.textAlignment = .center
        labelHeader?.font = UIFont(name: "SFProDisplay-Bold", size: 22)
        labelHeader?.textColor = .black
        self.addSubview(labelHeader!)
             
        labelSubHeader = UILabel()
        labelSubHeader?.textAlignment = .center
        labelSubHeader?.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        labelSubHeader?.textColor = UIColor.init(rgb: 0x8C8C8C)
        self.addSubview(labelSubHeader!)
             
        labelMini = UILabel()
        labelMini?.textAlignment = .center
        labelMini?.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        labelMini?.textColor = UIColor.init(rgb: 0x8C8C8C)
        self.addSubview(labelMini!)
             
        
        wearMileage = ViewShowWear()
        self.addSubview(wearMileage!)
              
        wearTime = ViewShowWear()
        self.addSubview(wearTime!)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
            let line = DrawLine(view: self, setting: SettingDrawLine(pointStart:
                CGPoint(x: self.frame.midX,
                        y: wearMileage!.frame.minY + 23),
                                                                 pointEnd: CGPoint(x: self.frame.midX,
                                                                                   y: wearMileage!.frame.maxY - 11),
                                                                 color: UIColor.init(rgb: 0xD8D8D8),
                                                                 lineWidth: 1))
            line.drawLine()
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelHeader?.frame = CGRect(x: 0, y: viewUp!.frame.maxY + 5, width: self.frame.width, height: 58)

        labelSubHeader?.frame = CGRect(x: 0, y: labelHeader!.frame.maxY + 6, width: self.frame.width, height: 24)
               
        labelMini?.frame = CGRect(x: 0, y: labelSubHeader!.frame.maxY + 8, width: self.frame.width, height: 18)
        
        wearMileage?.frame = CGRect(x: 8, y: labelMini!.frame.maxY + 3, width: self.frame.width * 0.5 - 1 - 8, height: 70)
        
        wearTime?.frame = CGRect(x: self.frame.midX + 0.5, y: labelMini!.frame.maxY + 3, width: self.frame.width * 0.5 - 0.5 - 8, height: 70)
    }
}

class ViewPanelAlertTable: ViewPanelAlertBase {
    
    var labelHeader: UILabel?
    var tableView: UITableView?
    private var managerWriteTO: ManagerWriteStationScheduledTO?
    
    override func initialization() {
        super.initialization()
        
        managerWriteTO = ManagerWriteStationScheduledTO()
    
        labelHeader = UILabel()
        labelHeader?.textAlignment = .center
        labelHeader?.font = UIFont(name: "SFProDisplay-Bold", size: 22)
        labelHeader?.textColor = .black
        self.addSubview(labelHeader!)
        
        tableView = UITableView()
        if #available(iOS 13.0, *) {
            tableView?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UINib(nibName: "TableViewCellInfoWorkingRepair", bundle: nil), forCellReuseIdentifier: "cellWorkingRepair")
        self.addSubview(tableView!)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelHeader?.frame = CGRect(x: 93, y: viewUp!.frame.maxY + 5, width: self.frame.width - 93 * 2, height: 30)
        
        tableView?.frame = CGRect(x: 12, y: labelHeader!.frame.maxY + 30, width: self.frame.width - 12 * 2, height: (button!.frame.origin.y - 38) - (labelHeader!.frame.maxY + 30))
    }
}

extension ViewPanelAlertTable: UITableViewDelegate {
    
}

extension ViewPanelAlertTable: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return managerWriteTO?.selectedCurrentModel?.dataTO?.listRepairsWorking.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellWorkingRepair") as! TableViewCellInfoWorkingRepair
        
        let repair = managerWriteTO?.selectedCurrentModel?.dataTO?.listRepairsWorking[indexPath.row]
      
        if (indexPath.row == managerWriteTO?.selectedCurrentModel?.dataTO?.listRepairsWorking.count ?? 1 - 1) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.frame.width, bottom: 0, right: 0);
        }
        
        cell.setup(repair: repair)
        return cell
    }
    
    
}
