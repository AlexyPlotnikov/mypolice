//
//  IDiagrammaControll.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 09/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation
import UIKit

protocol IChartControll {

    func insertNewSegmentInChart(segment: Segment)
    func removeSegmentFromChart(segment: Segment)
    func createChart()
    func deleteChart()
    func updateChart()
}
