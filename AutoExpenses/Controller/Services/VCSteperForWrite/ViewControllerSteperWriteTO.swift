//
//  ViewControllerSteperWriteTO.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 23.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import FSCalendar

class ViewControllerSteperWriteTO: ViewControllerThemeColor {
    
    @IBOutlet weak private var labelStep: UILabel!
    @IBOutlet weak private var imageStep: UIImageView!
    @IBOutlet weak private var descriptionStep: UILabel!
    @IBOutlet weak private var viewProgress: ViewProgress!
    @IBOutlet weak private var viewBottom: ViewPanelToNextStep!
    private var viewComplete: ViewScreenCompletionWriteTO?
    private var managerWriteTO: ManagerWriteStationScheduledTO?
    private var viewData: UIView?
    
    // initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        managerWriteTO = ManagerWriteStationScheduledTO()
    }
    
    // initialization
    init() {
        super.init(nibName: nil, bundle: nil)
        managerWriteTO = ManagerWriteStationScheduledTO()
    }
    
    // initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        managerWriteTO = ManagerWriteStationScheduledTO()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
          // Do any additional setup after loading the view.
        changeStepAndUpdateAllElements()
        updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let pointUp = descriptionStep.frame.origin.y + descriptionStep.frame.height
        viewData!.frame = CGRect(x: 0, y: pointUp, width: self.view.frame.width, height: viewBottom.frame.origin.y - pointUp - 16)
        
        viewComplete?.frame = self.view.bounds
    }

    
    private func changeStepAndUpdateAllElements() {
            
        var header = ""
        var description = ""
        self.descriptionStep.text = ""
        
        viewData?.removeFromSuperview()
        
        switch managerWriteTO?.currentStep {
        case 1:
            viewData = ViewSelectedPicker(frame: self.view.bounds, array: managerWriteTO?.arrayNamesTO() ?? [], delegate: self, indexMileage: managerWriteTO?.currentIndexTO ?? 1)
        
            header = "Выберите пробег планового ТО "
            description = " "
            self.view.addSubview(viewData!)
            
        case 2:
            viewData = ViewSelectedPartsQuality(frame: self.view.bounds, delegate: self, typeSelected: (managerWriteTO?.getModelWriteTO().typeParts)!)
            
            header = "Запчасти \n"
            description = "Какие запчасти использовать для замены?"
            self.view.addSubview(viewData!)
            
        case 3:
            viewData = ViewCalendar(frame: self.view.bounds, delegate: self)
        
            header = "Запись \n"
            description = "Выберите удобный для Вас день и время"
            self.view.addSubview(viewData!)
            
        case 4:
            viewData = ViewInformationAditional(frame: self.view.bounds, delegate:  self)
            header = "Дополнительно \n"
            description = "Укажите дополнительные опции"
            self.view.addSubview(viewData!)
            
        case 5:
            viewComplete = ViewScreenCompletionWriteTO(frame: self.view.bounds, delegate: self)
            viewComplete!.backgroundColor = .white
            self.viewComplete!.alpha = 0
            self.view.addSubview(viewComplete!)
            
            UIView.animate(withDuration: 0.3) {
                self.viewComplete!.alpha = 1
            }
            
        default:
            break
        }
        
         
        
        let attrHeader  = NewAttrChar(color: UIColor.black, font: UIFont(name: "SFProDisplay-Medium", size: 19)!, char: header)
        let attrDescr = NewAttrChar(color: UIColor.init(rgb: 0x959595), font: UIFont(name: "SFProDisplay-Regular", size: 15)!, char: description)
        self.descriptionStep.setNewChar(newArrayAttr: [attrHeader,attrDescr])
        
        updateData()
        viewProgress.setPriogressInPercentages(percentages: Float((100 / managerWriteTO!.totalStep) * managerWriteTO!.currentStep), colorForProgress: UIColor.init(rgb: 0x1F6BFF))
    }

    
   private func updateData () {
        labelStep.text = "Шаг \(managerWriteTO!.currentStep)"
        imageStep.image = UIImage(named: "step_icon_write_station\(managerWriteTO!.currentStep)")
        viewBottom.setup(colorBack: UIColor.init(rgb: 0x1F6BFF), cost: managerWriteTO?.getModelWriteTO().getCostTo(), titleButton: managerWriteTO!.currentStep >= 4 ? "Записаться" :  "Продолжить")
        viewBottom.vc = self
        self.view.setNeedsDisplay()
    }
    
    @IBAction func backAction(_ sender: Any) {
        if managerWriteTO?.currentStep ?? 0 <= 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            prevStep()
        }
    }
    
    @IBAction func openListWorkingRepairs(_ sender: Any) {
        // open new vc with table view
        let vc = ViewControllerWorkingRepairs(array: managerWriteTO!.getModelWriteTO().dataTO!.listRepairsWorking)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: selected swith step
extension ViewControllerSteperWriteTO: DelegateSwitchStep {
    
    func nextStep() {
    
        if (managerWriteTO?.currentStep ?? 0) + 1 == managerWriteTO?.totalStep {
            
                  let alert = UIAlertController(title: "Запись на тех. осмотр", message: "Выбранная дата для проведения тех. осмотра\n" + (managerWriteTO?.selectedCurrentModel?.dateVisit?.toString(format: "d MMMM yyyy \n в H:mm"))!, preferredStyle: .alert)
                  let actionOk = UIAlertAction(title: "Записаться", style: .default) { (alert) in
                    self.managerWriteTO?.currentStep += 1
                    self.changeStepAndUpdateAllElements()
                  }
                  let actionCancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
                  
                  alert.addAction(actionOk)
                  alert.addAction(actionCancel)
                  
                  self.present(alert, animated: true, completion: nil)
            
              } else {
            
            managerWriteTO?.currentStep += 1
            changeStepAndUpdateAllElements()
        
        }
    }
    
    func prevStep() {
        managerWriteTO?.currentStep -= 1
        changeStepAndUpdateAllElements()
    }
    
}

//MARK: selected TO to mileage
extension ViewControllerSteperWriteTO: DelegateSelectedToIndex {
    func setIndex(index: Int) {
        managerWriteTO?.setIndex(index: index)
        updateData()
    }
}

//MARK: selected quality parts
extension ViewControllerSteperWriteTO: DelegateSelectedQualityParts {
    
    func setQualityParts(type: ModelWriteScheduledTO.TypeParts) {
        self.managerWriteTO?.setType(type: type)
        updateData()
    }
    
    
}

//MARK: selected date
extension ViewControllerSteperWriteTO: DelegateSetDate {
 
    var dateSelected: Date? {
        get {
            return self.managerWriteTO?.selectedCurrentModel?.dateVisit
        }
        set (date) {
            self.managerWriteTO?.selectedCurrentModel?.dateVisit = date
        }
    }
    
}

//MARK: additional information
extension ViewControllerSteperWriteTO: DelegateInformationAditional {
    
    var needSelectProtectEngine: Bool {
        get {
            return self.managerWriteTO?.selectedCurrentModel?.protectedEngine ?? false
        }
        set (_protectedEngine) {
           self.managerWriteTO?.selectedCurrentModel?.protectedEngine = _protectedEngine
        }
    }
    
    var additionalInfo: String {
        get {
            return managerWriteTO?.selectedCurrentModel?.aditionalInfo ?? "Комментарий"
        }
        set (info) {
            managerWriteTO?.selectedCurrentModel?.aditionalInfo = info
        }
    }
    
    
}

//MARK: done writing
extension ViewControllerSteperWriteTO: DelegateEndSessionWriting {
    func exit() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}


