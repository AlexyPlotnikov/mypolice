//
//  TableViewCellStatisticGraphics.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 22/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


class TableViewCellStatisticGraphics: UITableViewCell {

    private var vc: UIViewController?
    var chart: IViewControll?

    @IBOutlet weak var viewForDiagramm: UIView!
    
    func initializationCell(vc: UIViewController) {
        self.vc = vc
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
          updateCharts()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func updateCharts() {
//        let structDate = StructDateForSelect(year: SelectedDate.shared.getStringYear().toInt(), month: SelectedDate.shared.getSelectedIndexMonth())
//        
//        self.chart?.delete()
//        var arraySegments: [ModelSegment] = []
//        for category in LocalDataSource.arrayCategory where (category as! BaseCategory).getAllSum(year_month: structDate) > 0 {
//            let categorySum = (category as! BaseCategory).getAllSum(year_month: structDate)
//            arraySegments.append(ModelSegment(color: (category as! BaseCategory).colorHead, value: Double(categorySum)))
//        }
//        self.chart = AdapterDiagramCircle(in: viewForDiagramm, rect: self.viewForDiagramm.bounds, segments: arraySegments)
//        self.chart?.create()
    }
    
   
}
