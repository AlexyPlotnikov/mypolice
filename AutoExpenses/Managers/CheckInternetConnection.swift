//
//  CheckInternetConnection.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 05/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import Foundation
import Reachability

class CheckInternetConnection {
    
    lazy private var reachability = Reachability()
    
    static var shared = CheckInternetConnection()
    
    func createSessionCheckInternetConnection() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability!.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    

    
    @objc private func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }
    
    func checkInternet(in vc: UIViewController) -> Bool {
        
        let state = reachability!.connection != .none
        
        if !state {
            let alert = UIAlertController(title: "Ошибка!", message: "Проверьте интернет соединение", preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
            vc.present(alert, animated: true) {
                // action
            }
        }
        
        return state
    }
    
}
