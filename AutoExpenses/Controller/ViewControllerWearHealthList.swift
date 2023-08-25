//
//  ViewControllerWearHealthList.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewControllerWearHealthList: ViewControllerThemeColor {

    @IBOutlet weak private var headerLabel: UILabel!
    private var tableView: UITableView?
    
    private let arrayArrays: [[ModelTimeAndMileageWear]]
    
    init(arrayArrays: [[ModelTimeAndMileageWear]]) {
        self.arrayArrays = arrayArrays
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.arrayArrays = [[ModelTimeAndMileageWear]]()
        super.init(coder: coder)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        headerLabel.text = "Запчасти\nи расходники"
        tableView = UITableView()
        tableView?.separatorStyle = .none
        tableView?.delegate = self
        tableView?.dataSource = self
        
        // cell
        tableView?.register(UINib(nibName: "TableViewCellWear", bundle: nil), forCellReuseIdentifier: "CellWear")
        
        // header
        tableView?.register(UINib(nibName: "ViewTableViewCellHeader", bundle: nil), forCellReuseIdentifier: "HeaderWearLevel")
        
        self.view.addSubview(tableView!)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView?.frame = CGRect(x: 0,
                                  y: headerLabel.frame.maxY + 13,
                                  width: self.view.bounds.width,
                                  height: self.view.frame.height - (headerLabel.frame.maxY + 13))
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        arrayArrays.removeAll()
    }
}
extension ViewControllerWearHealthList: UITableViewDelegate {
    
}

extension ViewControllerWearHealthList: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "HeaderWearLevel") as! ViewTableViewCellHeader
        
        switch section {
        case 0:
            headerView.setup(text: "К срочной проверке или замене", colorPoint: UIColor.init(rgb: 0xFF4444))
        case 1:
            headerView.setup(text: "В нормальном состоянии", colorPoint: UIColor.init(rgb: 0xFFB815))
        default:
            headerView.setup(text: "Не требует вмешательств", colorPoint: UIColor.init(rgb: 0x1CD194))
        }
        return arrayArrays[section].count > 0 ? headerView : UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return arrayArrays[section].count > 0 ? 44 : 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayArrays.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayArrays[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellWear") as! TableViewCellWear
        cell.setup(model: arrayArrays[indexPath.section][indexPath.row])
        return cell
    }
}
