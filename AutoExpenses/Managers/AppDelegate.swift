//
//  AppDelegate.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 12/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import AppAuth
import UserNotifications
import CoreLocation
import Reachability
import RealmSwift
import Flurry_iOS_SDK
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    private var checkKeybord: CheckShowKeyboard?
    var window: UIWindow?
    var siren: Siren?
    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    var state : Bool = false
    
    override init() {
        super.init()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
       
        if let authorizationFlow = self.currentAuthorizationFlow, authorizationFlow.resumeExternalUserAgentFlow(with: url) {
            
           
            
            self.currentAuthorizationFlow = nil
            return true
        }
        return false
    }
    
    func migrationDataBase() {
        let config = Realm.Configuration(
            schemaVersion: 18,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 18) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
//                    while(true) {
//                        print("up version realm data base")
//                    }
                } else {

                }
        })
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        Realm.Configuration.defaultConfiguration = config
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        var state = true
        
//          print(UIDevice.current.identifierForVendor!.uuidString) //print for check current device id 
//        DispatchQueue.main.async {
            self.migrationDataBase()
        
        
        let entity = EntityCarUser()
        LocalDataSource.identificatorUserCar = entity.getCurrentAuto().id
      //  UIApplication.shared.isIdleTimerDisabled = true
       
        let ent = EntityAdditionally()
        if ent.getAllDataFromDB().count <= 0 {
            ent.first = true
            ent.addData()
        }
        
        
//        let content = UNMutableNotificationContent()
//        content.title = "Don't forget"
//        content.body = "Buy some milk"
//        content.sound = UNNotificationSound.default
//
//        var component = DateComponents()
//        component.month = 10
//        component.year = 2019
//        component.day = 21
//        component.hour = 16
//        component.minute = 22
//        component.second = 5
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
//
//        let request = UNNotificationRequest(
//            identifier: "identifier",
//            content: content,
//            trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
//            if error != nil {
//                //handle error
//            } else {
//                //notification set up successfully
//            }
//        })
             
        
        
//        for family in UIFont.familyNames {
//            for font in UIFont.fontNames(forFamilyName: family) {
//                print(font)
//            }
//        }
        
        // создание сессии для проверки интернет соединения
        CheckInternetConnection.shared.createSessionCheckInternetConnection()
    
        //TODO: init analytics
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
        let builder = FlurrySessionBuilder.init()
            .withAppVersion(version)
            .withLogLevel(FlurryLogLevelAll)
            .withCrashReporting(true)
        
        Flurry.startSession("Y988C9D4JVS5GSH5DXK2", with: builder)
        
        // TODO: Analytics
        AnalyticEvents.logEvent(.OpenApplication)
        
        
        
        siren = Siren.shared
               siren!.presentationManager = PresentationManager(alertTitle: "Внимание!",alertMessage: "Версия приложения устарела. Для дальнейшей работы необходимо выполнить обновление.",updateButtonTitle:"Обновить")
               siren!.apiManager = APIManager(countryCode: "RU")
               siren!.rulesManager = RulesManager(globalRules: .critical,
                  showAlertAfterCurrentVersionHasBeenReleasedForDays: 0)
               
               siren!.wail(performCheck: .onForeground, completion: {
                   results in
                   switch results {
                   case .failure(_):
                       state = false
                   case .success(_):
                       state = true
                   }
               })
        
        
        return state
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
       
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins                                                    the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

}

