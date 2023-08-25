//
//  ManagerServiceInformation.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 11.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import CoreLocation

class ManagerServiceInformation {
    let locationService = LocationService()
    private var arrayServices: [ModelService]?
    
    deinit {
        print("deinit ManagerServiceInformation")
    }
    
    init() {
        arrayServices = [ModelService]()
        
        let autoriyekyOne = ModelService(id: "Авториеки Ст,83а", nameService: "Авториеки", numbersPhones: ["+79833138868", "+73833047104"],
                                      shortDescription: "Сервисный центр «Авториеки» ремонтирует и обслуживает автомобили Toyota и Lexus строго по регламенту завода-изготовителя. Наш…",
                                      fullDescription: "Сервисный центр «Авториеки» ремонтирует и обслуживает автомобили Toyota и Lexus строго по регламенту завода-изготовителя. Наши клиенты — физические и юридические лица. Наши мастера понятно и доступно объяснят все детали ремонта и заранее согласуют с вами смету на обслуживание. Вы можете наблюдать за ремонтом вашего авто лично или через видеокамеру.",
                                      imageBackground: UIImage(named: "autoriyeki_back")!,
                                      logo: UIImage(named: "autoriyeki_logo")!,
                                      location: CoordinatesPoint(location: CLLocation(latitude: CLLocationDegrees(exactly: 54.995756)!, longitude: CLLocationDegrees(exactly: 82.815204)!),
                                                                 address: "Cтанционная, 83а"),
                                      arrayModelCar: ["Lexus", "Toyota"])
        
        let autoriyekyTwo = ModelService(id: "Авториеки Бол,125/3", nameService: "Авториеки", numbersPhones: ["+79833138868", "+73833047104"],
                                                                    shortDescription: "Сервисный центр «Авториеки» ремонтирует и обслуживает автомобили Toyota и Lexus строго по регламенту завода-изготовителя. Наш…",
                                                                    fullDescription: "Сервисный центр «Авториеки» ремонтирует и обслуживает автомобили Toyota и Lexus строго по регламенту завода-изготовителя. Наши клиенты — физические и юридические лица. Наши мастера понятно и доступно объяснят все детали ремонта и заранее согласуют с вами смету на обслуживание. Вы можете наблюдать за ремонтом вашего авто лично или через видеокамеру.",
                                                                    imageBackground: UIImage(named: "autoriyeki_back")!,
                                                                    logo: UIImage(named: "autoriyeki_logo")!,
                                                                    location: CoordinatesPoint(location: CLLocation(latitude: CLLocationDegrees(exactly: 54.995756)!, longitude: CLLocationDegrees(exactly: 82.815204)!),
                                                                                               address: "​Большевистская, 125/3"),
                                                                    arrayModelCar: ["Lexus", "Toyota"])
        
        arrayServices?.append(autoriyekyOne)
        arrayServices?.append(autoriyekyTwo)
    }
    
    func getListServices(mark: String) -> [ModelService] {
        return arrayServices!
    }
    
    
    private func getDistance(location: CLLocation) -> Double {
        guard let myCoordinate = locationService.lastLocation else { return 0 }
        let distanceInMeters = location.distance(from: myCoordinate)
        return distanceInMeters
    }
    
}
