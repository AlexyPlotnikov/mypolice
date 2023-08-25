//
//  ViewControllerHealthCar.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import AppAuth

class ViewControllerHealthCar: ViewControllerThemeColor {

    private var viewFunctions: ViewFunctionsForEveryViewController?
    
    private var labelHeaderWear: UILabel?
    private var scrollForUrgentlyElemens: ScrollListStateParts?
    
    private var viewStateParts: ViewStateParts?
    private var viewHeaderParts: ViewHeader?
    
    private var viewStub: ViewStub?
    
    private var managerWear: ManagerHandlerDataToWear?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc private func showAll() {
        let arrayMedium = managerWear!.getArrayFromLevel()[1]
        let arrayLow = managerWear!.getArrayFromLevel()[0]
        
        let viewList = ViewControllerWearHealthList(arrayArrays: [[], arrayMedium, arrayLow])
        self.navigationController?.pushViewController(viewList, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        managerWear = ManagerHandlerDataToWear()
        
        viewFunctions = ViewFunctionsForEveryViewController(arrayFunctions: [ViewMyCars(text: ""), ViewTimerParking()])
        self.view.addSubview(viewFunctions!)
        
        viewStub = ViewStub(frame: .zero, image: UIImage(named: "ok")!, text: "В данный момент Ваш автомобиль в полном порядке")
        self.view.addSubview(viewStub!)
        
        labelHeaderWear = UILabel()
        labelHeaderWear?.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        labelHeaderWear?.setNewChar(newArrayAttr: [NewAttrChar(color: UIColor.init(rgb: 0xFF4444), font: UIFont(name: "SFProDisplay-Bold", size: 16)!, char: "\u{2022} "),
                                                   NewAttrChar(color: UIColor.white, font: labelHeaderWear!.font, char: "Необходимый ремонт")])
        self.view.addSubview(labelHeaderWear!)
        
        scrollForUrgentlyElemens = ScrollListStateParts(arrayModels: managerWear!.getArrayFromLevel()[2], delegate: self, typeWearView: .Big)
        self.view.addSubview(scrollForUrgentlyElemens!)
        
        
        let _leftLabelSettings = TextStruct(font: UIFont(name: "SFProDisplay-Regular", size: 16)!,
                                text: "Состояние агрегатов",
                                colorText: UIColor.init(rgb: 0x8C8C8C))
        let _rightLabelSettings = TextStruct(font: UIFont(name: "SFProDisplay-Regular", size: 16)!,
                                      text: "См. все",
                                      colorText: UIColor.init(rgb: 0x447AFF))
        
        viewHeaderParts = ViewHeader(leftLabelSettings: _leftLabelSettings, rightLabelSettings: _rightLabelSettings)
        viewHeaderParts?.addTarget(self, action: #selector(showAll), for: .touchUpInside)
        self.view.addSubview(viewHeaderParts!)
        
        var array: [ModelTimeAndMileageWear] = managerWear!.getArrayFromLevel()[0]
        array.append(contentsOf: managerWear!.getArrayFromLevel()[1])
        viewStateParts = ViewStateParts(models: array, delegate: self)
        self.view.addSubview(viewStateParts!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        JMTConnector().auth()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // deinit hands
        managerWear = nil
        
        viewFunctions?.removeFromSuperview()
//        viewFunctions = nil
        
        viewStub?.removeFromSuperview()
        
        viewHeaderParts?.removeFromSuperview()
//        viewHeaderParts = nil
        
        scrollForUrgentlyElemens?.removeFromSuperview()
//        scrollForUrgentlyElemens = nil
        
        viewStateParts?.removeFromSuperview()
//        viewStateParts = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewFunctions?.frame = CGRect(x: 12, y: 5, width: self.view.frame.width - 12 * 2, height: 40)
        
        labelHeaderWear?.frame = CGRect(x: 12, y: viewFunctions!.frame.maxY + 11, width: self.view.frame.width - 12, height: 23)
        
        scrollForUrgentlyElemens?.frame = CGRect(x: 0, y: labelHeaderWear!.frame.maxY + 11, width: self.view.frame.width, height: 174)
        
        viewStub?.frame = scrollForUrgentlyElemens!.frame
        
        viewHeaderParts?.frame = CGRect(x: 0, y: scrollForUrgentlyElemens!.frame.maxY + 17, width: self.view.frame.width, height: 40)
        
        viewStateParts?.frame = CGRect(x: 0, y: viewHeaderParts!.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - viewHeaderParts!.frame.maxY)
    }
}

extension ViewControllerHealthCar : DelegateOpenAdditionalScreen {
 
    func openAlert(_ panelProtocol: PanelDropForWriteProtocol) {
        panelProtocol.show(complete: nil)
    }
    
    func closeAlert() {
        
    }
    
    func openScreen(_ vcForOpen: UIViewController) {
        if CheckInternetConnection.shared.checkInternet(in: self) {
            StationTechnicalService().presentVC(vc: self)
        }
    }
}
