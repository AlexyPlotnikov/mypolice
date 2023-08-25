//
//  IDiagrammaControll.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 09/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import UIKit

protocol IChartControll: IViewControll{
    func insertNewSegmentInChart(segment: ModelSegment)
}
