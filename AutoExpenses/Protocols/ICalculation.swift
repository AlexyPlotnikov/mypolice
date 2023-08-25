//
//  ICalculation.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20/09/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

enum TypeCalculation: String {
    case AverageExpenseToPeriod = "Средняя сумма"
    case MileageCurrentPeriod = "За период"
    case TopToExpenses = "Популярный расход"
    case CostOneKM = "1 км"
    case RubInDay = "В день"
    case ConsuptionFuel = "на 100 км"
}

protocol ICalculation {
    var value: Float { get }
    var typeCalculation: TypeCalculation { get }
}
