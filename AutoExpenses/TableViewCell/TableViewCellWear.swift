//
//  TableViewCellWear.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 21.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class TableViewCellWear: UITableViewCell {
    
    private weak var viewWear: ViewWearSmall!
    
    func setup(model: ModelTimeAndMileageWear) {
        
        var _model = model
        
        if viewWear == nil {
            let view = ViewWearSmall()
            viewWear = view
            self.addSubview(viewWear)
        }
        
        _model.updateViewWear(viewForUpdate: viewWear, typeIfNeedReplace: .Big)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.viewWear.frame = CGRect(x: 8, y: 0, width: self.frame.width - 16, height: self.frame.height - 13)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
