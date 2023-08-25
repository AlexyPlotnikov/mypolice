//
//  AppAuth.swift
//  RxAgentStateNumbers
//
//  Created by Иван Зубарев on 04/03/2019.
//  Copyright © 2019 Edrenov Dmitry. All rights reserved.
//

import AppAuth
import UIKit


typealias PostRegistrationCallback = (_ configuration: OIDServiceConfiguration?, _ registrationResponse: OIDRegistrationResponse?) -> Void

/**
 The OIDC issuer from which the configuration will be discovered.
 */

let kIssuer: String = LocalDataSource.demo ? "https://demo-accounts.rx-agent.ru/" : "https://accounts.rx-agent.ru"
let param = "{\"prompt\":\"login\"}"

/**
 The OAuth client ID.
 
 For client configuration instructions, see the [README](https://github.com/openid/AppAuth-iOS/blob/master/s/-iOS_Swift-Carthage/README.md).
 Set to nil to use dynamic registration with this .
 */

let kClientID: String? = "b2b.app.ios"

/**
 The OAuth redirect URI for the client @c kClientID.
 
 For client configuration instructions, see the [README](https://github.com/openid/AppAuth-iOS/blob/master/s/-iOS_Swift-Carthage/README.md).
 */
let kRedirectURI: String =  LocalDataSource.demo ? "b2b.app.ios://ru.rx-agent.demo-accounts/oauthredirect" : "b2b.app.ios://ru.rx-agent.accounts/oauthredirect"

/**
 NSCoding key for the authState property.
 */
let kAppAuthAuthStateKey: String = "username"

class AppAuth : NSObject {
    var authState: OIDAuthState?
}

extension AppAuth {
    
    func validateOAuthConfiguration() {
        
        // The  needs to be configured with your own client details.
        // See: https://github.com/openid/AppAuth-iOS/blob/master/s/-iOS_Swift-Carthage/README.md
        
        assert(kIssuer != "https://accounts.rx-agent.ru",
               "Update kIssuer with your own issuer.\n" +
            "Instructions: https://github.com/openid/AppAuth-iOS/blob/master/s/-iOS_Swift-Carthage/README.md");
        
        assert(kClientID != "b2b.app.ios",
               "Update kClientID with your own client ID.\n" +
            "Instructions: https://github.com/openid/AppAuth-iOS/blob/master/s/-iOS_Swift-Carthage/README.md");
        
        assert(kRedirectURI != "b2b.app.ios://ru.rx-agent.accounts/oauthredirect",
               "Update kRedirectURI with your own redirect URI.\n" +
            "Instructions: https://github.com/openid/AppAuth-iOS/blob/master/s/-iOS_Swift-Carthage/README.md");
        
        // verifies that the custom URI scheme has been updated in the Info.plist
        guard let urlTypes: [AnyObject] = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [AnyObject], urlTypes.count > 0 else {
            assertionFailure("No custom URI scheme has been configured for the project.")
            return
        }
        
        guard let items = urlTypes[0] as? [String: AnyObject],
            let urlSchemes = items["CFBundleURLSchemes"] as? [AnyObject], urlSchemes.count > 0 else {
                assertionFailure("No custom URI scheme has been configured for the project.")
                return
        }
        
        guard let urlScheme = urlSchemes[0] as? String else {
            assertionFailure("No custom URI scheme has been configured for the project.")
            return
        }
        
        assert(urlScheme != "com..app",
               "Configure the URI scheme in Info.plist (URL Types -> Item 0 -> URL Schemes -> Item 0) " +
                "with the scheme of your redirect URI. Full instructions: " +
            "https://github.com/openid/AppAuth-iOS/blob/master/s/-iOS_Swift-Carthage/README.md")
    }
    
}

extension AppAuth {
    
    func authWithAutoCodeExchange(viewController : UIViewController, callback: @escaping (Bool)-> Void) {
        
        guard let issuer = URL(string: kIssuer) else {
            print("Error creating URL for : \(kIssuer)")
            return
        }
        
//        print("Fetching configuration for issuer: \(issuer)")
        
        // discovers endpoints
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in
            
            guard let config = configuration else {
                print("Error retrieving discovery document: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                self.setAuthState(nil)
                return
            }
            
            print("Got configuration: \(config)")
            
            if let clientId = kClientID {
                self.doAuthWithAutoCodeExchange(configuration: config, clientID: clientId, clientSecret: nil, viewController: viewController, callback: callback)
            } else {
                self.doClientRegistration(configuration: config) { configuration, response in
                    guard let configuration = configuration, let clientID = response?.clientID else {
                        print("Error retrieving configuration OR clientID")
                        return
                    }
                    
                    self.doAuthWithAutoCodeExchange(configuration: configuration,
                                                    clientID: clientID,
                                                    clientSecret: response?.clientSecret, viewController: viewController, callback: callback)
                }
            }
        }
    }
    
   
    
    func authNoCodeExchange(viewController : UIViewController) {
        
        guard let issuer = URL(string: kIssuer) else {
            print("Error creating URL for : \(kIssuer)")
            return
        }
        
        print("Fetching configuration for issuer: \(issuer)")
        
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in
            
            if let error = error  {
                print("Error retrieving discovery document: \(error.localizedDescription)")
                return
            }
            
            guard let configuration = configuration else {
                print("Error retrieving discovery document. Error & Configuration both are NIL!")
                return
            }
            
            print("Got configuration: \(configuration)")
            
            if let clientId = kClientID {
                
                self.doAuthWithoutCodeExchange(configuration: configuration, clientID: clientId, clientSecret: nil, viewController: viewController)
                
            } else {
                
                self.doClientRegistration(configuration: configuration) { configuration, response in
                    
                    guard let configuration = configuration, let response = response else {
                        return
                    }
                    
                    self.doAuthWithoutCodeExchange(configuration: configuration,
                                                   clientID: response.clientID,
                                                   clientSecret: response.clientSecret, viewController: viewController)
                }
            }
        }
    }
    
    func codeExchange(callback:@escaping (Bool) -> Void) {

        guard let tokenExchangeRequest = self.authState?.lastAuthorizationResponse.tokenExchangeRequest() else {
            print("Error creating authorization code exchange request")
//            UserStateManager.sharedInstance.exitUserFromTheAccount()
            callback(false)
            return
        }
        
        print("Performing authorization code exchange with request \(tokenExchangeRequest)")
        
        OIDAuthorizationService.perform(tokenExchangeRequest) { response, error in
            
            if let tokenResponse = response {
                callback(true)
                print("Received token response with accessToken: \(tokenResponse.accessToken ?? "DEFAULT_TOKEN")")
            } else {
                print("Token exchange error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                callback(false)
            }
            self.authState?.update(with: response, error: error)
        }
    }
    
    func userinfo()->Dictionary<String, Any>? {
        guard let userinfoEndpoint = self.authState?.lastAuthorizationResponse.request.configuration.discoveryDocument?.userinfoEndpoint else {
            print("Userinfo endpoint not declared in discovery document")
            return nil
        }
        print("Performing userinfo request")
        
        var dict : Dictionary<String,Any>?
        
        let currentAccessToken: String? = self.authState?.lastTokenResponse?.accessToken
        
        self.authState?.performAction() { (accessToken, idTOken, error) in
            
            if error != nil  {
                print("Error fetching fresh tokens: \(error?.localizedDescription ?? "ERROR")")
                return
            }
            
            guard let accessToken = accessToken else {
                print("Error getting accessToken")
                return
            }
            
            if currentAccessToken != accessToken {
                print("Access token was refreshed automatically (\(currentAccessToken ?? "CURRENT_ACCESS_TOKEN") to \(accessToken))")
            } else {
                print("Access token was fresh and not updated \(accessToken)")
            }
            
            var urlRequest = URLRequest(url: userinfoEndpoint)
            urlRequest.allHTTPHeaderFields = ["Authorization":"Bearer \(accessToken)"]
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                DispatchQueue.main.async {
                    
                    guard error == nil else {
                        print("HTTP request failed \(error?.localizedDescription ?? "ERROR")")
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else {
                        print("Non-HTTP response")
                        return
                    }
                    
                    guard let data = data else {
                        print("HTTP response data is empty")
                        return
                    }
                    
                    var json: [String: Any]?
                    
                    do {
                        json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    } catch {
                        print("JSON Serialization Error")
                    }
                    
                    if response.statusCode != 200 {
                        // server replied with an error
                        let responseText: String? = String(data: data, encoding: String.Encoding.utf8)
                        print("responseText = \(String(describing: responseText))")
                        if response.statusCode == 401 {
                            // "401 Unauthorized" generally indicates there is an issue with the authorization
                            // grant. Puts OIDAuthState into an error state.
                            let oauthError = OIDErrorUtilities.resourceServerAuthorizationError(withCode: 0,
                                                                                                errorResponse: json,
                                                                                                underlyingError: error)
                            self.authState?.update(withAuthorizationError: oauthError)
                            print("Authorization Error (\(oauthError)). Response: \(responseText ?? "RESPONSE_TEXT")")
                        } else {
                            print("HTTP: \(response.statusCode), Response: \(responseText ?? "RESPONSE_TEXT")")
                        }
                        
                        return
                    }
                    
                    if let json = json {
                        print("Success: \(json)")
                        dict = json
                        return
                    }
//                    let dict = json
                   
                }
            }
            
            task.resume()
        }
        
//        print(dict)
         return dict
    }
    
    func trashClicked(viewController : UIViewController) {
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.actionSheet)
        
        let clearAuthAction = UIAlertAction(title: "Clear OAuthState", style: .destructive) { (_: UIAlertAction) in
            self.setAuthState(nil)
        }
        alert.addAction(clearAuthAction)
        
        let clearLogs = UIAlertAction(title: "Clear Logs", style: .default) { (_: UIAlertAction) in
            DispatchQueue.main.async {
                //                self.logTextView.text = ""
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alert.addAction(clearLogs)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
        
    }
}

//MARK: AppAuth Methods
extension AppAuth {
    
    func doClientRegistration(configuration: OIDServiceConfiguration, callback: @escaping PostRegistrationCallback) {
        
        guard let redirectURI = URL(string: kRedirectURI) else {
            print("Error creating URL for : \(kRedirectURI)")
            return
        }
      
        
        let request: OIDRegistrationRequest = OIDRegistrationRequest(configuration: configuration,
                                                                     redirectURIs: [redirectURI],
                                                                     responseTypes: nil,
                                                                     grantTypes: nil,
                                                                     subjectType: nil,
                                                                     tokenEndpointAuthMethod: "client_secret_post",
                                                                     additionalParameters:param.convertToDictionary()
            
        )
        // performs registration request
        print("Initiating registration request")
        
        OIDAuthorizationService.perform(request) { response, error in
            
            if let regResponse = response {
                self.setAuthState(OIDAuthState(registrationResponse: regResponse))
                print("Got registration response: \(regResponse)")
                callback(configuration, regResponse)
            } else {
                print("Registration error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                self.setAuthState(nil)
            }
        }
    }
    

    
    func updateAuthState(authState: OIDAuthState?) {
        
//        if let authState = authState {
//            let archivedAuthState = NSKeyedArchiver.archivedData(withRootObject: authState)
//            keychain.set(archivedAuthState, forKey: kAuthStateKey)
//        } else {
//           
//        }
    }
    
    

  
    func doAuthWithAutoCodeExchange(configuration: OIDServiceConfiguration, clientID: String, clientSecret: String?, viewController : UIViewController, callback: @escaping (Bool)-> Void) {
        
       
        
       
        
        guard let redirectURI = URL(string: kRedirectURI) else {
            print("Error creating URL for : \(kRedirectURI)")
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error accessing AppDelegate")
            return
        }
    
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientID,
                                              clientSecret: clientSecret,
                                              scopes: [OIDScopeOpenID, OIDScopeProfile , "b2b.api"],
                                              redirectURL:redirectURI,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: param.convertToDictionary())
        
        
        let state = "eyJ1c2VybmFtZSI6ICJ0ZXN0dXNlciIsICJwYXNzd29yZCI6ICIxMjM0NTYifQ,,"
        request.setValue(state, forKeyPath: "state")
        
        appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: viewController) { (authState, error) in
             DispatchQueue.main.async {
                if let authS = authState {
                    let entityCar = EntityCarUser()
                    entityCar.token = authS.lastTokenResponse!.accessToken ?? ""
                    entityCar.select = EntityCarUser().getDataFromDBCurrentID()[0].select
                    entityCar.addToken()
                    appDelegate.state = true
                    self.setAuthState(authS)
                    callback(true)
                } else {
                    print("Authorization error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                    appDelegate.state = false
                    callback(false)
                }
                
            }
        }

    }
    
    func doAuthWithoutCodeExchange(configuration: OIDServiceConfiguration, clientID: String, clientSecret: String?, viewController : UIViewController) {
        
        guard let redirectURI = URL(string: "kRedirectURI") else {
            print("Error creating URL for : \(kRedirectURI)")
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error accessing AppDelegate")
            return
        }
        
        // builds authentication request
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientID,
                                              clientSecret: clientSecret,
                                              scopes: [OIDScopeOpenID, OIDScopeProfile],
                                              redirectURL: redirectURI,
                                              responseType: OIDResponseTypeCode,

                                              additionalParameters: param.convertToDictionary())
        
        
        
        // performs authentication request
        print("Initiating authorization request with scope: \(request.scope ?? "DEFAULT_SCOPE")")
        
        appDelegate.currentAuthorizationFlow = OIDAuthorizationService.present(request, presenting: viewController) { (response, error) in
            self.loadState()
            if let response = response {
                let authState = OIDAuthState(authorizationResponse: response)
                self.setAuthState(authState)
                print("Authorization response with code: \(response.authorizationCode ?? "DEFAULT_CODE")")
                // could just call [self tokenExchange:nil] directly, but will let the user initiate it.
            } else {
                print("Authorization error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
            }
        }
    }
}

//MARK: OIDAuthState Delegate
extension AppAuth: OIDAuthStateChangeDelegate, OIDAuthStateErrorDelegate {

    func didChange(_ state: OIDAuthState) {
        self.stateChanged()
    }

    
    
    func authState(_ state: OIDAuthState, didEncounterAuthorizationError error: Error) {
        print("Received authorization error: \(error)")
    }
}

//MARK: Helper Methods
extension AppAuth {
    
    func saveState() {
        
        var data: Data? = nil
        
        if let authState = self.authState {
            data = NSKeyedArchiver.archivedData(withRootObject: authState)
        }
        
        UserDefaults.standard.set(data, forKey: kAppAuthAuthStateKey)
        UserDefaults.standard.synchronize()
    }
    
    func loadState() {
        guard let data = UserDefaults.standard.object(forKey: kAppAuthAuthStateKey) as? Data else {
            return
        }
        
        if let authState = NSKeyedUnarchiver.unarchiveObject(with: data) as? OIDAuthState {
            self.setAuthState(authState)
            print(data)
        }
    }
    
    func setAuthState(_ authState: OIDAuthState?) {
        if (self.authState == authState) {
            return
        }
      
        self.authState = authState;
        self.authState?.stateChangeDelegate = self;
        self.stateChanged()
    }
    
    
    func stateChanged() {
        self.saveState()
    }
    
    func isEqualObjects(_authState : OIDAuthState) -> Bool {
        return self.authState == authState
    }
}

extension String {

    func heightNeededForLabel(_ label: UILabel) -> CGFloat {
        let width = label.frame.size.width
        guard let font = label.font else {return 0}
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func capitalizingFirstLetter() -> String {
            return prefix(1).uppercased() + self.lowercased().dropFirst()
        }
        mutating func capitalizeFirstLetter() {
            self = self.capitalizingFirstLetter()
    }
    
    var replacePointToComma: String {
           return self.replacingOccurrences(of: ".", with: ",")
    }
    
    
    public func numberOfOccurrences(_ string: String) -> Int {
        return components(separatedBy: string).count - 1
    }
    
    func convertToDictionary() -> [String: String]? {
        if let data = self.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                return json
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func toDateTime(format: String) -> Date {
        
    
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from:self) ?? Date()
        
        //Return Parsed Date
        return dateFromString
    }
    
   
    func toInt()  -> Int {
        guard let text = Int(self) else {
            return 0
        }
        return text
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}
