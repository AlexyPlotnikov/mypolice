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
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var buttonListWorks: UIButton!
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak private var labelStep: UILabel!
    @IBOutlet weak private var imageStep: UIImageView!
    @IBOutlet weak private var descriptionStep: UILabel!
    @IBOutlet weak private var viewProgress: ViewProgress!
    @IBOutlet weak private var viewBottom: ViewPanelToNextStep!
    private var viewComplete: ViewScreenCompletionWriteTO?
    private var managerWriteTO: ManagerWriteStationScheduledTO?
    private var viewData: UIView?
    private var auto: AutoForServices?
    private var serviceID: String?
    
    // initialization
    init(serviceID: String?) {
        super.init(nibName: nil, bundle: nil)
        self.serviceID = serviceID
        managerWriteTO = ManagerWriteStationScheduledTO()
    }
    
    // initialization
    init(auto: AutoForServices?,serviceID: String?) {
        super.init(nibName: nil, bundle: nil)
        
        self.serviceID = serviceID
        self.auto = auto
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
        indicator.isHidden = true
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
        
        if viewData is ViewInformationAditional {
            NotificationCenter.default.removeObserver(viewData!, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(viewData!, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
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
            self.buttonSkip.setImage(UIImage(named: "back_black"), for: .normal)
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
        viewProgress.setPriogressInPercentages(percentages: Float((100 / managerWriteTO!.totalStep) * managerWriteTO!.currentStep), colorForProgress: #colorLiteral(red: 1, green: 0.7764705882, blue: 0.2588235294, alpha: 1))
    }

    
   private func updateData () {
    
        labelStep.text = "Шаг \(managerWriteTO!.currentStep)"
        imageStep.image = UIImage(named: "step_icon_write_station\(managerWriteTO!.currentStep)")
    viewBottom.setup(colorBack: .clear/*UIColor.init(rgb: 0x111624)*/, cost: !(auto?.stateToBase ?? true) ? managerWriteTO?.getModelWriteTO().getCostTo() : "", titleButton: managerWriteTO!.currentStep >= 4 ? "Записаться" :  "Продолжить")
        viewBottom.vc = self
    
        self.buttonListWorks.isHidden = auto?.stateToBase ?? true
    
        self.buttonSkip.setImage(UIImage(named: managerWriteTO?.currentStep ?? 0 <= 1 ? "arrow_bottom" : "backBlack"), for: .normal)
    
        self.view.setNeedsDisplay()
    
    }
    
    @IBAction func backAction(_ sender: Any) {
        if managerWriteTO?.currentStep ?? 0 <= 1 {
            self.dismiss(animated: true, completion: nil)
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
    
        let url = LocalDataSource.demo ? "https://demo-api.rx-agent.ru/v0/smsMessages" : "https://api.rx-agent.ru/v0/smsMessages"
        
        if (managerWriteTO?.currentStep ?? 0) + 1 == managerWriteTO?.totalStep {
            
            if !CheckInternetConnection.shared.checkInternet(in: self) {
                return
            }
            
            let alert = UIAlertController(title: "Запись на тех. осмотр", message: "Выбранная дата для проведения тех. осмотра\n" + (managerWriteTO?.selectedCurrentModel?.dateVisit?.toString(format: "d MMMM yyyy \n в H:mm"))!, preferredStyle: .alert)
            
                let actionCancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
                let actionOk = UIAlertAction(title: "Записаться", style: .default) { (alert) in

                    self.indicator.isHidden = false
                    let phone = self.phoneSorted(encodePhone: "0002999309")
                    let text = "ID: \(self.serviceID ?? ""); " + "\(EntityAuthorization().getAllDataFromDB()[0].numberPhone); " + (self.managerWriteTO?.selectedCurrentModel?.getDataForRequest() ?? "")
                    
                    
                    RequestWithParametrs().executeRequest(methodRequest: "POST", url: url, parameters: InfoForWriteService(numberPhone: phone, text: text).toJSON()!) { (data, code, error) in
                        
                        if code == 200 {
                            DispatchQueue.main.async {
                                self.indicator.isHidden = true
                                self.managerWriteTO?.currentStep += 1
                                self.changeStepAndUpdateAllElements()
                            }
                        }
                    }
                }
            
                  
            alert.addAction(actionOk)
            alert.addAction(actionCancel)
                  
            self.present(alert, animated: true, completion: nil)
            
        } else {
            managerWriteTO?.currentStep += 1
            changeStepAndUpdateAllElements()
        }
    }
    
    func phoneSorted(encodePhone: String) -> String {
        return String(encodePhone.reversed())
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
    
    func exit(text: String) {
        print(text)
        self.dismiss(animated: true, completion: nil)
    }
        
}



