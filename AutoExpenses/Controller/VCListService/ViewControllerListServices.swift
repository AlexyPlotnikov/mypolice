//
//  ViewControllerListServices.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 11.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

struct CellSettings {
    var cell: TableViewCellServiceForSelect
    var height: CGFloat
}

class ViewControllerListServices: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var managerServices: ManagerServiceInformation?
    
    private var arrayCells: [CellSettings]?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let manager = ManagerServiceInformation()
        managerServices = manager
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        print("deinit ViewControllerListServices")
        managerServices = nil
    }
    
    
    func cellsSetup() {
        arrayCells = [CellSettings]()
        
        // for test
        for i in 0..<managerServices!.getListServices(mark: "Mark auto").count {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellServicesForSelected") as! TableViewCellServiceForSelect
            let infoService = (managerServices!.getListServices(mark: "Mark auto")[i])
            cell.setup(modelService: infoService, delegate: self)
            arrayCells!.append(CellSettings(cell: cell, height: 386))
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        tableView.contentInset = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "TableViewCellServiceForSelect", bundle: nil), forCellReuseIdentifier: "cellServicesForSelected")
        cellsSetup()
        
        for i in 0..<self.navigationController!.viewControllers.count where self.navigationController!.viewControllers[i] is ViewControllerAutorization {
            self.navigationController!.viewControllers.remove(at: i)
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        for cellSet in arrayCells! {
            cellSet.cell.controllPlaying(play: false)
        }
        
        managerServices = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.delegate?.scrollViewDidScroll?(self.tableView)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ViewControllerListServices: UITableViewDelegate {

}

extension ViewControllerListServices: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 0 ? 16 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return arrayCells?[indexPath.section].height ?? 386
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         arrayCells?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return arrayCells![indexPath.section].cell
    }
}

extension ViewControllerListServices: CellDelegate {
    func writeService(idService: String?) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerSelecterServices") as! ViewControllerSelecterServices
        vc.idService = idService
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func contentDidChange(cellSettings: CellSettings) {
        self.tableView.beginUpdates()
        let index = arrayCells?.firstIndex(where: {(_cellSettings) -> Bool in
            cellSettings.cell == _cellSettings.cell
        }) ?? 0
        arrayCells?[index] = cellSettings
        self.tableView.endUpdates()
    }
}
extension ViewControllerListServices: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       var pageNumber = 0
       for i in 0..<arrayCells!.count {
           let cell = arrayCells![i].cell
           pageNumber = Int(round(tableView.contentOffset.y / (arrayCells![i].height + 8)))
           cell.controllPlaying(play: i==pageNumber)
       }
//       print(pageNumber)
    }
}

//extension ViewControllerListServices: DelegateVideo {
//    
//    func fullScreenResolution(state: Bool, view: UIView) {
//        if state {
//            self.view.addSubview(view)
//            view.bringSubviewToFront(self.view)
//            view.frame = self.view.frame
//        }
//    }
//}

