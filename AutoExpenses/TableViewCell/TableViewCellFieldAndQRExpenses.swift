//
//  TableViewCellFieldAndQRExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 04/09/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellFieldAndQRExpenses: TableViewCellFieldExpenses {

    @IBOutlet weak var qrButton: UIButton!
    var vcToShow: UIViewController?
    
    @objc private func scaning () {
        
        //TODO: Analytics
        AnalyticEvents.logEvent(.OpenScanerQRCode)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerScanerQRCode") as! ViewControllerScanerQRCode
        vc.delegate = (vcToShow as! DelegateDataFromQRCode)
        vc.modalPresentationStyle = .fullScreen
        vcToShow!.present(vc, animated: true, completion: nil)
    }

    
    override func initialization(fieldInfo: IFieldInfo, delegate: DelegateReloadData & DelegateViewExpenses, obligatoryField: Bool) {
        super.initialization(fieldInfo: fieldInfo, delegate: delegate, obligatoryField: obligatoryField)
        qrButton.addTarget(self, action: #selector(scaning), for: .touchUpInside)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
