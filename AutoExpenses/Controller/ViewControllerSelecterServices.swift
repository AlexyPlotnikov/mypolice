//
//  ViewControllerSelecterServices.swift
//  
//
//  Created by Иван Зубарев on 22.10.2019.
//

import UIKit

struct AutoForServices {
    var modelAuto: String?
    var iconAuto: UIImage?
    var stateToBase: Bool = false
}

class ViewControllerSelecterServices: ViewControllerThemeColor {

    @IBOutlet weak var labelSelectedService: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageCar: UIImageView!
    @IBOutlet weak var nameCar: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var idService: String?
    private var auto: AutoForServices?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     let mark = RequestPolicyOSAGO()
        mark.loadData(callback: {(model) in
           
            let icon = //mark.info.lowercased() == "toyota land cruiser" ? UIImage(named: "cruiser") :
                UIImage(named: "car_empty") // replace to
            self.auto = AutoForServices(modelAuto: "", iconAuto: icon, stateToBase: "" != "land cruiser")
                      
                self.labelSelectedService.text = "Авториеки"
                self.imageCar.image = self.auto?.iconAuto
                self.nameCar.text = self.auto?.modelAuto
        })
          
        self.descriptionLabel.text = "Ваш автомобиль"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ViewControllerSelecterServices: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ViewControllerSteperWriteTO(auto: auto, serviceID: self.idService)
        let aObjNavi = UINavigationController(rootViewController: viewController)
        aObjNavi.navigationBar.isHidden = true
        self.present(aObjNavi, animated: true, completion: nil)
    }
}

extension ViewControllerSelecterServices: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellServices") as! TableViewCellServices
        cell.labelName.text = "Плановое ТО"
//        cell.iconServices.image = UIImage(named: "to")
        return cell
    }
    
    
}
