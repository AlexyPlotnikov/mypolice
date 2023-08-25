//
//  ModelService.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 11.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//


import UIKit
import CoreLocation

struct CoordinatesPoint {
    var location: CLLocation
    var address: String
}


protocol IServiceInfo {
    var nameService: String {get set}
    var numbersPhones: [String] {get set}
    var shortDescription: String {get set}
    var fullDescription: String {get set}
    var imageBackground: UIImage {get set}
    var location: CoordinatesPoint {get set}
}

class ModelService: IServiceInfo {
    var id: String
    var nameService: String
    var numbersPhones: [String]
    var shortDescription: String
    var fullDescription: String
    var imageBackground: UIImage
    var logo: UIImage
    var location: CoordinatesPoint
    var arrayModelCar: [String]

    
    init(id: String, nameService: String, numbersPhones: [String], shortDescription: String, fullDescription: String, imageBackground: UIImage, logo: UIImage, location: CoordinatesPoint, arrayModelCar: [String]) {
        
        self.id = id
        self.nameService = nameService
        self.numbersPhones = numbersPhones
        self.shortDescription = shortDescription
        self.fullDescription = fullDescription
        self.imageBackground = imageBackground
        self.logo = logo
        self.location = location
        self.arrayModelCar = arrayModelCar
    }

}
