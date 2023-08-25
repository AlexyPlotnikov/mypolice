//
//  Timer.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 05/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

protocol UpdateTime: NSObject {
    func updateTime()
}

class TimerControll: NSObject, UNUserNotificationCenterDelegate {
    
    private var isGrantedNotificationAccess: Bool = false
    private var timeInt: Int = 0
    private var timeToEnd = 0
    private var timer: Timer? {
        willSet (time) {
            self.timeToEnd = timeInt > 60 && timeInt < 15*60 ? 60 : 15*60
        }
    }
    
   weak var delegateUpdateTime : UpdateTime?
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                print(granted)
                self.isGrantedNotificationAccess = granted
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
        stopTimer()
    }
    
    
    
    
    func stopTimer()  {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        self.timeInt = 0
        self.timer?.invalidate()
        if delegateUpdateTime != nil  {
            delegateUpdateTime?.updateTime()
        }
        
    }
    
    func getCurrentTime() -> Int {
        if isRunTimer() {
            if timeInt <= timeToEnd {
                let message = timeToEnd == 0 ? "Время кончилось" : "Осталось \(Int(timeToEnd/60)) минут"
                let identifier = timeToEnd == 0 ? "timerEnd" : "timerWarning"
                if timeInt <= 0 {
                    stopTimer()
                }
                sendNotification(time: 1, title: "Таймер бесплатной парковки", message: message, identifier: identifier)
                timeToEnd = 0
            }
        }
        return timeInt
    }
    
    func isRunTimer() -> Bool {
        return self.timer?.isValid ?? false
    }
    
    private func sendNotification(time: TimeInterval, title: String?, message: String?, identifier: String) {

        if isGrantedNotificationAccess && time > 0 {
            //add notification code here
            //Set the content of the notification
            let content = UNMutableNotificationContent()
            content.title = title ?? ""
            content.subtitle = ""
            content.body = message ?? ""
            content.sound = .default
            
            //Set the trigger of the notification -- here a timer.
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: (time),
                repeats: false)
            
            //Set the request for the notification from the above
            let request = UNNotificationRequest (
                identifier: identifier,
                content: content,
                trigger: trigger
            )
            
            //Add the notification to the currnet notification center
            UNUserNotificationCenter.current().add(request) { (error) in
                print(error as Any)
            }
        }
    }
    
    
    func startTimer(time: Date, specialText: (String?) = nil) {
        
        if isRunTimer() {
           stopTimer()
        }

        let minute = Calendar.current.component(.minute, from: time)
        let hour = Calendar.current.component(.hour, from: time)
        self.timeInt = (minute + (hour * 60)) * 60
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    self.timeInt -= 1
                    self.delegateUpdateTime?.updateTime()
                }
            }
            
        })
    }
}
