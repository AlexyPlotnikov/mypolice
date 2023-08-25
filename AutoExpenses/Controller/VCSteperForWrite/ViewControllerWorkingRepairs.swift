//
//  ViewControllerWorkingRepairs.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 25.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewControllerWorkingRepairs: ViewControllerThemeColor, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    private var array: [RepairWorking]?
    
    init(array: [RepairWorking]) {
        super.init(nibName: nil, bundle: nil)
        self.array = array
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "TableViewCellInfoWorkingRepair", bundle:  nil), forCellReuseIdentifier: "cellWorkingRepair")
        // Do any additional setup after loading the view.
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ViewControllerWorkingRepairs: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension ViewControllerWorkingRepairs: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellWorkingRepair") as! TableViewCellInfoWorkingRepair
        cell.setup(repair: array?[indexPath.row])
        return cell
    }
}
