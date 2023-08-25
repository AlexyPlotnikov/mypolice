//
//  IRequest.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20.03.2020.
//  Copyright © 2020 rx. All rights reserved.
//

import Foundation

protocol IRequest {
    func executeRequest(methodRequest: String, url: String, parameters: [String: Any], callback: @escaping (_ data: Data?, _ code: Int?, _ error: Error?) -> Void)
}


