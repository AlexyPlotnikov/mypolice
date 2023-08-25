//
//  PostRequest.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20.03.2020.
//  Copyright © 2020 rx. All rights reserved.
//

import Foundation
import Gloss

class InfoForWriteService: Codable {
    var numberPhone: String
    var text: String
    
    init(numberPhone: String, text: String?) {
        self.numberPhone = numberPhone
        self.text = text ?? ""
    }

    func toJSON() -> JSON? {
        return jsonify([
            "phone" ~~> self.numberPhone,
            "text" ~~> self.text,
            ])
    }
    
}


class RequestWithParametrs: IRequest {
    func executeRequest(methodRequest: String, url: String, parameters: [String : Any], callback: @escaping (Data?, Int?, Error?) -> Void) {

        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(EntityCarUser().getDataFromDBCurrentID()[0].token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = methodRequest
        request.httpBody = jsonData

        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString ?? "Not response")")
            callback(data, response.statusCode, error)
        }

        task.resume()
    }
       
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
