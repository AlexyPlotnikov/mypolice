//
//  ViewTimerParking.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewTimerParking: ViewFunction {

    var timerParking: TimerControll?

    
    init() {
        super.init(text: "Время парковки", image: UIImage(named: "plusTimer"))
        timerParking = TimerControll()
        timerParking?.delegateUpdateTime = self
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTimer)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
 
    func controllButton() {
        let isRun = timerParking!.isRunTimer()
              
              UIView.animate(withDuration: 0.2) {
                  let angle = isRun ? 45*CGFloat.pi/180 : 0
                  self.icon?.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
              }
             
    }
    
    @objc func tapTimer() {
           
           let vc = UIApplication.shared.keyWindow?.rootViewController
            
            let alertDataPicker = CustomDataPickerController(parentView: vc!.view, title: "Время бесплатной парковки", message: "", pickerMode: .time)
            
            let actionOk = CustomAlertAction(title: "Установить таймер", styleAction: .default) {
               self.timerParking!.startTimer(time: alertDataPicker.dataPicker.date)
                // TODO: Analytics
                AnalyticEvents.logEvent(.AddedTimeParking)
               self.controllButton()
            }
            
            let actionStop = CustomAlertAction(title: "Выключить таймер", styleAction: .default) {
               self.timerParking!.stopTimer()
               self.controllButton()
            }
            
           let actionCancel = CustomAlertAction(title: "Отмена", styleAction: .default) {

           }
           
            alertDataPicker.addAction(actionCancel)
            
            if timerParking!.isRunTimer() {
                alertDataPicker.addAction(actionStop)
            }
            
            alertDataPicker.addAction(actionOk)
            alertDataPicker.showAlert()
            alertDataPicker.dataPicker.date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        }
    
}

extension ViewTimerParking: UpdateTime {
    
    func updateTime() {
        self.labelText?.text = timerParking!.getCurrentTime() > 0 ? timerParking!.getCurrentTime().secondsToHoursMinutesSeconds() : "Время парковки"
    
      
        if !timerParking!.isRunTimer() {
            controllButton()
        }
    }
     
   
    
  
}

