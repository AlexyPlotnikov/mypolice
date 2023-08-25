//
//  TimeParking.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import RealmSwift



class TimeParking : BaseAutoInfo {
    
    var timer = TimerControll()
    
    override init() {
        super.init()
        self.id = "TimeParking"
        self.headerField = "Парковка"
        self.icon = UIImage(named: "timer_info")
    }
    
    func updateInfo() {
        self.id = "TimeParking"
        self.info = self.timer.getCurrentTime() > 0 ? self.timer.getCurrentTime().secondsToHoursMinutesSeconds() : "Выкл"
    }
    
   override func addInfo(comletion: @escaping (String) -> Void) {

        let vc = LocalDataSource.headViewController
        
        let alertDataPicker = CustomDataPickerController(parentView: vc!.view, title: "Время бесплатной парковки", message: "", pickerMode: .time)
        
        let actionOk = CustomAlertAction(title: "Установить таймер", styleAction: .default) {
            self.timer.startTimer(time: alertDataPicker.dataPicker.date)
            
            // TODO: Analytics
            AnalyticEvents.logEvent(.AddedTimeParking)
            
            comletion(self.info)
        }
        
        let actionStop = CustomAlertAction(title: "Выключить таймер", styleAction: .default) {
            self.timer.stopTimer()
            comletion(self.info)
        }
        
        let actionCancel = CustomAlertAction(title: "Отмена", styleAction: .default, handler: nil)
        
        alertDataPicker.addAction(actionCancel)
        
        if self.timer.isRunTimer() {
            alertDataPicker.addAction(actionStop)
        }
        
        alertDataPicker.addAction(actionOk)
        alertDataPicker.showAlert()
        alertDataPicker.dataPicker.date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        
    }
    
    //selected date func
    func dateSelected(date : Date)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "ru_MD")
        return dateFormatter.string(from: date)
    }
    
}
