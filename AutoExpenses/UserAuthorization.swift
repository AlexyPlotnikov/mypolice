//
//  UserAuthorizationNumberPhone.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 10/06/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import UIKit

class UserAuthorization {
    
    enum CurrentOpenViewController: String {
        case Authorization = "viewControllerAutorization"
        case OsagoInformation = "viewControllerPolicyOSAGO"
        case Services = "viewControllerServices"
    }

//     var authApp : AppAuth?
    
    let currentViewController = { (type: CurrentOpenViewController) -> UIViewController in
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: type.rawValue)
    }
    
    static let sharedInstance: UserAuthorization = {
        let instance = UserAuthorization()
        return instance
    }()
    
    func translitionInAutorization(in viewController : UIViewController,callback: @escaping (Bool)-> Void) {
        
        if CheckInternetConnection.shared.checkInternet(in: viewController) {
//            self.authApp?.authWithAutoCodeExchange(viewController: viewController, callback: callback)
            let url = LocalDataSource.demo ? "https://demo-accounts.rx-agent.ru/connect/token" : "https://accounts.rx-agent.ru/connect/token"
            self.getDictionaryRequest(URLString: url, completion: {
                result in
                    
                    if let token = result["access_token"] as? String {
                        let entityCar = EntityCarUser()
                        entityCar.token = token
                        entityCar.select = EntityCarUser().getDataFromDBCurrentID()[0].select
                        entityCar.addToken()
                        callback(true)
                    } else {
                        callback(false)
                }
            })
        }
        
    }
    
    func getDictionaryRequest(URLString:String, completion:@escaping (_ array: [String:Any])->Void) {
           
           var request = URLRequest(url: NSURL(string: URLString)! as URL)
               request.httpMethod = "POST"
        
            let bodyData = convertToParameters(["grant_type":"client_credentials","client_id":"b2b.other.api","scope":"b2b.api","client_secret":"secret117243"])
               request.httpBody = bodyData.data(using: .utf8, allowLossyConversion: true)
        
           let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
               guard let data = data else { return }
                 do {
                    let GETdata  =  try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    completion(GETdata)
                 } catch {
                       print(error)
                 }
           })
           
           task.resume()
       }
    
    
    func convertToParameters(_ params: [String: String?]) -> String {
        var paramList: [String] = []

        for (key, value) in params {
            guard let value = value else {
                continue
            }
            
            guard let scapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                print("Failed to convert key \(key)")
                continue
            }
            
            guard let scapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                print("Failed to convert value \(value)")
                continue
            }
            
            paramList.append("\(scapedKey)=\(scapedValue)")
        }

        return paramList.joined(separator: "&")
    }
    
    func getActivateUser() -> Bool {
        return EntityCarUser().getDataFromDBCurrentID().count>0 && !EntityCarUser().getDataFromDBCurrentID()[0].token.isEmpty
    }
    
    func exitUserFromTheAccount() {
        let entityCar = EntityCarUser()
        entityCar.token = ""
        entityCar.select = EntityCarUser().getDataFromDBCurrentID()[0].select
        entityCar.addToken()
//        authApp!.setAuthState(nil)
        
        //TODO: Analytics
        AnalyticEvents.logEvent(.UserLogOut)
    }
    
    
    func postRequestNumberPhoneAuthorization(link: String, callback: @escaping (String?, Bool?, Int?, Int?, Int?, [String:Any]?) -> Void) {
        
        var request = URLRequest(url: NSURL(string: link)! as URL)
        
        if !EntityCarUser().getDataFromDBCurrentID()[0].token.isEmpty {
            request.addValue("Bearer \(EntityCarUser().getDataFromDBCurrentID()[0].token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "PATCH"
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data else { return }
            var movieData: [String: Any]?
            
            do {
                movieData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                
                callback((movieData?["message"] as? String),
                         (movieData?["isError"] as? Int) == 1,
                         (movieData?["state"] as? Int),
                         (movieData?["code"] as? Int),
                         (movieData?["errorCode"] as? Int),
                         (movieData?["data"] as? [String : Any]))
                
            } catch let DecodingError.dataCorrupted(context) {
                                 print(context)
                             } catch let DecodingError.keyNotFound(key, context) {
                                 print("Key '\(key)' not found:", context.debugDescription)
                                 print("codingPath:", context.codingPath)
                             } catch let DecodingError.valueNotFound(value, context) {
                                 print("Value '\(value)' not found:", context.debugDescription)
                                 print("codingPath:", context.codingPath)
                             } catch let DecodingError.typeMismatch(type, context)  {
                                 print("Type '\(type)' mismatch:", context.debugDescription)
                                 print("codingPath:", context.codingPath)
                             } catch {
                                   if let httpResponse = response as? HTTPURLResponse {

                                                      print(httpResponse.statusCode)



                                                      switch httpResponse.statusCode {
                                                      case 401:
                                                          print("401 ERROR")
                                                          UserAuthorization.sharedInstance.exitUserFromTheAccount()
                                  //                         self.showAlertMessage(message: "Время сессии закончилось авторизируйтесь снова")
                                                          break
                                                      case 502:
                                                          print("502 ERROR")
                                  //                         self.showAlertMessage(message: "Ошибка сервера")
                                                          break
                                                      default:
                                                          print("NOT NUMBER ERROR")
                                  //                        UserAuthorization.sharedInstance.exitUserFromTheAccount()
                                                      }
                                                  }
                             }
            
        })
        task.resume()
    }
    
//    func getRequest(URLString:String, completion:@escaping (Dictionary<String, Any>)->Void) {
//
//        var request = URLRequest(url: NSURL(string: URLString)! as URL)
//
//        if !EntityCarUser().getDataFromDBCurrentID()[0].token.isEmpty {
//            request.addValue("Bearer \(EntityCarUser().getDataFromDBCurrentID()[0].token)", forHTTPHeaderField: "Authorization")
//            request.httpMethod = "GET"
//        }
//
//        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
//            guard let data = data else { return }
//            do {
//                let movieData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
//                completion(movieData)
//
//            } catch let error as NSError {
//                if let httpResponse = response as? HTTPURLResponse {
//                    switch httpResponse.statusCode {
//                    case 401:
//                        print("401 ERROR")
//
//                        UserAuthorization.sharedInstance.exitUserFromTheAccount()
//                        UserAuthorization.sharedInstance.translitionInAutorization(in: self.currentViewController(.Authorization), callback: { (state) in
//                            if !state {
//                                self.currentViewController(.Authorization).dismiss(animated: true, completion: nil)
//                            }
//                        })
//                        break
//                    case 502:
//                        print("502 ERROR")
//                        //                         self.showAlertMessage(message: "Ошибка сервера")
//                        break
//                    default:
//                        print("NOT NUMBER ERROR")
//                    }
//                }
//                print(error)
//            }
//        })
//        task.resume()
//    }
    
    
    func getParsingDatePolicyOsagoToKey(callback :@escaping (_ model: ListPolicysOSAGO?) -> Void) {
       let link = (LocalDataSource.demo ? "https://demo-api.rx-agent.ru/v0/technocards/getPolicies/" : "https://api.rx-agent.ru/v0/technocards/getPolicies/")
            + EntityAuthorization().getAllDataFromDB()[0].numberPhone.dropFirst()
        
        var request = URLRequest(url: NSURL(string: link)! as URL)
        
            if !EntityCarUser().getDataFromDBCurrentID()[0].token.isEmpty {
                    request.addValue("Bearer \(EntityCarUser().getDataFromDBCurrentID()[0].token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = "GET"
                }
                
                print(EntityCarUser().getDataFromDBCurrentID()[0].token)
                let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                    guard let data = data else { return }
//                    var movieData: [String: Any]?
                    let decode = JSONDecoder()
                    do {
//                        movieData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                        
//                        if(movieData?["errors"] == nil) {
//                            let dataModel = try JSONSerialization.data(withJSONObject: movieData?["data"] as? [String : Any], options: .fragmentsAllowed)
                            let model = try decode.decode(ListPolicysOSAGO.self, from: data)
                            print(model)
                            callback(model)
//                        } else {
//                            callback(nil)
//                        }
                        
                      
                          
                        
                    } catch let DecodingError.dataCorrupted(context) {
                                         print(context)
                                     } catch let DecodingError.keyNotFound(key, context) {
                                         print("Key '\(key)' not found:", context.debugDescription)
                                         print("codingPath:", context.codingPath)
                                     } catch let DecodingError.valueNotFound(value, context) {
                                         print("Value '\(value)' not found:", context.debugDescription)
                                         print("codingPath:", context.codingPath)
                                     } catch let DecodingError.typeMismatch(type, context)  {
                                         print("Type '\(type)' mismatch:", context.debugDescription)
                                         print("codingPath:", context.codingPath)
                                     } catch {
                                           if let httpResponse = response as? HTTPURLResponse {

                                                              print(httpResponse.statusCode)



                                                              switch httpResponse.statusCode {
                                                              case 401:
                                                                  print("401 ERROR")
                                                                  UserAuthorization.sharedInstance.exitUserFromTheAccount()
                                          //                         self.showAlertMessage(message: "Время сессии закончилось авторизируйтесь снова")
                                                                  break
                                                              case 502:
                                                                  print("502 ERROR")
                                          //                         self.showAlertMessage(message: "Ошибка сервера")
                                                                  break
                                                              default:
                                                                  print("NOT NUMBER ERROR")
                                          //                        UserAuthorization.sharedInstance.exitUserFromTheAccount()
                                                              }
                                                          }
                                     }
                    
                })
                task.resume()
          
    }
    
    //    func getParsingDatePolicyOsagoToKey(key: String, callback :@escaping (_ value: Any) -> Void) {
    //        UserStateManager.sharedInstance.getRequest(URLString: "https://demo-api.rx-agent.ru/v0/EOSAGOPolicies/lastPolicy/"+LocalDataSource.autorizationViewController.autorization.numberPhone!) { (dictonary) in
    //            let dictOsago = dictonary["eosagoPolicy"] as? Dictionary <String, Any>
    //            let field = dictOsago?[key]
    //             DispatchQueue.main.async {
    //                callback(field as Any)
    //            }
    //        }
    //    }
    
}
extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

    
    
    

