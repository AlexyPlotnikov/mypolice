//
//  JMTConnector.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 09.12.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation

class JMTConnector {
    
    func auth() {
    
        let tokenURL = "https://demo-accounts.rx-agent.ru/connect/token"

        let headers = ["Content-Type": "application/x-www-form-urlencoded",
                       "client_id" : "b2b.other.api",
                       "grant_type": "client_credentials",
                       "response_type" : "token",
                       "secret" : "secret117243"]
        
        let params = [ "client_id" : "b2b.other.api",
                       "response_type" : "token",
                       "grant_type": "client_credentials",
                       "secret" : "secret117243"]


//        let request = Alamofire.request(tokenURL,
//                                        method: .post,
//                                        parameters: params,
//                                        encoding: JSONEncoding.default,
//                                        headers: headers)
//        print(request.debugDescription)
//        request.responseJSON { response in
//            debugPrint(response)
//            let result = response.result.value
//            print(result)
//        }
    }
    
    func getDictionaryRequest(URLString:String, completion:@escaping (_ array: [String:Any])->Void) {
        
        var request = URLRequest(url: NSURL(string: URLString)!.appendingPathComponent(".well-known/openid-configuration")!)
            request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
             guard let data = data else { return }
               do {
                let GETdata  =  try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            
                 completion(GETdata)
           } catch let error as NSError {
               print(error)
           }
        })
        
        task.resume()
    }
    
}
