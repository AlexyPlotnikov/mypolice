//
//  TableViewCellEdition.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 30/05/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellEdition: TableViewCellSimpleButton {

    private var viewControllerEditionWidgets : ViewControllerEditionWidgets? = nil
    private var viewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

        
    func initialization(userHandler: UserInformationHandler?, viewController: UIViewController)  {
        
        self.viewController = viewController
        self.viewControllerEditionWidgets = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerEditionWidgets") as! ViewControllerEditionWidgets)
        self.viewControllerEditionWidgets?.userInformationHandler = userHandler
        self.viewControllerEditionWidgets?.delegate = (viewController as! DelegateReloadData)
        
        super.initialization {
            self.viewController!.present(self.viewControllerEditionWidgets!, animated: true) {}
        }
    
    }
}
