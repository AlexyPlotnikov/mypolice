//
//  ViewControllerStatementGIBDD.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/05/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewControllerPartsService: ViewControllerThemeColor {

    @IBOutlet weak var titleHeader: UILabel!
    var _title: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        // Do any additional setup after loading the view.
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleHeader.text = _title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for i in 0..<self.navigationController!.viewControllers.count where self.navigationController!.viewControllers[i] is ViewControllerAutorization {
            self.navigationController!.viewControllers.remove(at: i)
        }
        
        if !UserAuthorization.sharedInstance.getActivateUser() {
            actionDismissViewController(UIButton())
        }
    }
    
    @IBAction func actionDismissViewController(_ sender: UIButton) {
//        let vcService = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerServices") as! ViewControllerServices
         self.navigationController!.popToRootViewController(animated: true)
        
    }
    
}
