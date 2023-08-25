//
//  ViewControllerAutorization.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 07/06/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import JMMaskTextField_Swift
//import RealmSwift
//import Realm

class ViewControllerAutorization: ViewControllerThemeColor, DelegateShowViewController {

    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var inputNumberPhone: JMMaskTextField!
    @IBOutlet weak var buttonEnter: UIButton!
    @IBOutlet weak var labelNumberPhone: UILabel!
    @IBOutlet weak var buttonReCall: UIButton!
    private var vcShow: UIViewController?
    var numberPhone = ""
    @IBOutlet weak var constreintButton: NSLayoutConstraint!
    private var keyboardHeight: CGFloat = 0
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initilization()

//        let image = UIImage(named: "cross")?.withRenderingMode(.alwaysTemplate)
//        buttonClose.setImage(image, for: .normal)
        buttonClose.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        LocalDataSource.autorizationViewController = self
        inputNumberPhone.delegate = self
        inputNumberPhone.keyboardType = .numberPad
        inputNumberPhone.layer.cornerRadius = 8
        inputNumberPhone.leftView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: 18,
                                                         height: inputNumberPhone.frame.height))
        inputNumberPhone.layer.borderWidth = 1
        inputNumberPhone.layer.borderColor = UIColor.init(rgb: 0xE3E4E6).cgColor
        
        inputNumberPhone.leftViewMode = .always
        buttonEnter.layer.cornerRadius = 30
        buttonEnter.setTitle("Получить код доступа по смс", for: .normal)
        
        buttonReCall.addTarget(self, action: #selector(recallCode), for: .touchUpInside)

    }
    
    @objc func closeVC() {
         self.navigationController!.popToRootViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initilization() {
//        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),name:UIResponder.keyboardWillShowNotification,object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
            
            if keyboardHeight > 0 {
                constreintButton.constant = (16 + keyboardHeight)
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            
            }
        }
    }
    
    func showViewController(vc: UIViewController) {
        self.vcShow = vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkField()
        
        if !CheckInternetConnection.shared.checkInternet(in: self) {
            return
        }
        
        
    }
    
    func openVcForShow()  {
        self.navigationController!.pushViewController(vcShow!, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        //TODO: Analytics
        AnalyticEvents.logEvent(.OpenAuthorization)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputNumberPhone.endEditing(true)
    }

    
    func alertInformation(message: String?, actions: [UIAlertAction?]) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        for action in actions where action != nil {
             alert.addAction(action!)
        }
        
        self.present(alert, animated: true) {
        }
    }
    
    func callNumberPhone(numberClean : String, numberMask: String? ) {
        self.buttonEnter.setTitle("Отправить код", for: .normal)
        numberPhone = numberClean
        
        if numberMask != nil {
            self.labelNumberPhone.text = "Отправлен код доступа на телефон " + numberMask!
        }
        
        self.inputNumberPhone.placeholder = "Код подтверждения"
        self.inputNumberPhone.maskString = "0000"
        self.inputNumberPhone.text = ""
        self.checkField()
    }
    
    
    func requestNumberPhone(stateRequest: (String?) = nil) {
        
        let str = (self.inputNumberPhone.unmaskedText!.isEmpty && !self.numberPhone.isEmpty) ? self.numberPhone :
            self.inputNumberPhone.unmaskedText!
        
        let numberPhoneLink = (LocalDataSource.demo ?
            "https://demo-api.rx-agent.ru/v0/EOSAGOPolicies/auth/" : "https://api.rx-agent.ru/v0/EOSAGOPolicies/auth/") + str.dropFirst() + "/null/" + (stateRequest ?? "false")
        
        UserAuthorization.sharedInstance.postRequestNumberPhoneAuthorization(link: numberPhoneLink) { (message, isError, state, code, codeError, data) in
            
            DispatchQueue.main.async {
                if isError ?? false {
                    self.alertInformation(message: message!, actions: [UIAlertAction(title: "Ок", style: .cancel, handler: nil)])
                }
                switch state {
                case 0:
                    break
                case 1:
                    self.callNumberPhone(numberClean: str, numberMask: self.inputNumberPhone.text!)
                //                        print(codeError)
                case 2:
                    self.buttonReCall.isHidden = false
                    self.alertInformation(message: message!, actions: [
                        // переотправка кода
                        UIAlertAction(title: "Переотправить код", style: .default, handler: { (UIAlertAction) in
                            self.requestNumberPhone(stateRequest: "true")
                            self.callNumberPhone(numberClean: str, numberMask: self.inputNumberPhone.text!)
                        }),
                        // повтор ввода кода
                        UIAlertAction(title: "Ввести код", style: .default, handler: { (UIAlertAction) in
//                            print("enter code")
                            self.callNumberPhone(numberClean: str, numberMask: self.inputNumberPhone.text!)
                        }),
                        UIAlertAction(title: "Отмена", style: .cancel, handler: nil)])
                case 3: //complete
                    
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    @objc func recallCode () {
        requestCode(load: true)
        let alert = UIAlertController(title: "Код отправлен", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
        
    func requestCode(load: (Bool?) = nil) {
        
        let numberAndCode = (load ?? false) ?
        String(EntityAuthorization().numberPhone) + "/" + String(EntityAuthorization().code) :
        String(numberPhone.dropFirst()) + "/" + inputNumberPhone.unmaskedText!
        
        let numberPhoneAndCodeLink = (LocalDataSource.demo ? "https://demo-api.rx-agent.ru/v0/EOSAGOPolicies/auth/" : "https://api.rx-agent.ru/v0/EOSAGOPolicies/auth/") + numberAndCode + "/" + (load == nil ? "false" : load!.description)
        
        UserAuthorization.sharedInstance.postRequestNumberPhoneAuthorization(link: numberPhoneAndCodeLink) { (message, isError, state, code, codeError, dictonary) in
            
            DispatchQueue.main.async {
                if (codeError != nil) {
                    print("error code = \(String(describing: codeError))  " + message! + " " + state!.toString())
                } else {
                    if state == 254 {
                        let entity = EntityAuthorization()
                        entity.numberPhone = self.numberPhone
                        entity.code = self.inputNumberPhone.text!
                        entity.addData()
                        
                        //TODO: Analytics
                        AnalyticEvents.logEvent(.UserAuthorizationComplete)
                        self.openVcForShow()
                    } else {
                        self.alertInformation(message: "Неверный код", actions:
                             [/*UIAlertAction(title: "Переотправить код", style: .default, handler: { (UIAlertAction) in
                                self.inputNumberPhone.text = self.numberPhone
                                self.requestNumberPhone(stateRequest: "true")
//                                self.callNumberPhone(numberClear: self.numberPhone, numberMask: nil)
                             }),*/
                            UIAlertAction(title: "Ок", style: .cancel, handler: nil)])
                    }
                }
            }
        }
    }
    
    
    func requestAuthorization(stateRequest: (String?) = nil) {
        if numberPhone.isEmpty {
            requestNumberPhone()
        } else {
            requestCode()
        }
    }
    
    @IBAction func reCallCode(_ sender: Any) {
        self.requestNumberPhone(stateRequest: "true")
    }
    
    // function call request for authorization
    @IBAction func buttonAuthorization(_ sender: Any) {
        requestAuthorization()
    }
}

extension ViewControllerAutorization: UITextFieldDelegate {
    
    func checkField() {
        
        if numberPhone.isEmpty {
            self.labelNumberPhone.text = "Введите номер телефона"
            inputNumberPhone.placeholder = "Номер телефона"
            inputNumberPhone.maskString = "+7(000) 000 00 00"
            inputNumberPhone.text = inputNumberPhone.text!.isEmpty ? "+7" : inputNumberPhone.text
        } else {
            self.labelNumberPhone.text = "Введите код подтверждения из СМС"
            inputNumberPhone.placeholder = "Код подтверждения"
            inputNumberPhone.text = inputNumberPhone.text!.isEmpty ? "" : inputNumberPhone.text
        }
        self.buttonReCall.isHidden = numberPhone.isEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        constreintButton.constant = 16
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        constreintButton.constant = 16 + keyboardHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}
