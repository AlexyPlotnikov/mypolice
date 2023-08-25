//
//  ViewControllerPreviewService.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 12.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewControllerPreviewService: UIViewController {
    

    @IBOutlet weak var viewVideoPreview: ViewPlayerForVideo!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var buttonOpenWriteToService: UIButton!
    
    private var modelService: ModelService!
    
    init(modelService: ModelService) {
        super.init(nibName: nil, bundle: nil)
        self.modelService = modelService
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("deinit_ViewControllerPreviewService")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.buttonOpenWriteToService.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        buttonOpenWriteToService.layer.cornerRadius = 26
        let path = UIBezierPath(roundedRect: backView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 14, height: 14))
        let rectShape = CAShapeLayer()
        rectShape.bounds = backView.frame
        rectShape.position = backView.center
        rectShape.path = path.cgPath
        self.backView.layer.mask = rectShape
        // Do any additional setup after loading the view.
    }
  
    @objc private func actionButton() {
        self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerSelecterServices"), animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewVideoPreview.configure()
        viewVideoPreview.isLoop = true
        viewVideoPreview.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewVideoPreview.pause()
    }
    
}
