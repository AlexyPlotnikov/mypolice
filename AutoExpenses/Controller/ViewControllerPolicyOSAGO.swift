//
//  ViewControllerPolicyOSAGO.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 13/05/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


struct StatusRequest {
    var colorText: UIColor
    var colorBack: UIColor
    var text: String
}


class ViewControllerPolicyOSAGO: ViewControllerThemeColor {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonUpdate: UIButton!
    
    @IBOutlet weak var buttonSelectedCar: UIButton!
    
    private var scrollView: UIScrollView!
    @IBOutlet weak var buttonChekerRequestPolicy: UIButton!
    
    enum TypeRequestPay: String {
        case tryOpenURL, OpenURL, getPolicy, downloadPolicy
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    private var arrayView: [ViewInfoOsago] = []
    lazy var indicatorDownloadPolicy = UIActivityIndicatorView()
    
    
    private var currentModel: ModelPolicyOSAGO! {
        didSet (model) {
            buildFields(model: currentModel)
        }
    }
    
    private var modelList: ListPolicysOSAGO!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.buttonChekerRequestPolicy.layer.masksToBounds = true
        self.buttonChekerRequestPolicy.layer.cornerRadius = 13
        
        self.buttonClose.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        self.buttonUpdate.addTarget(self, action: #selector(updateStatus), for: .touchUpInside)
        
        self.scrollView = UIScrollView()
        self.view.insertSubview(self.scrollView, at: 0)
        self.scrollView.alwaysBounceVertical = true
      
        
        self.view.addSubview(self.indicatorDownloadPolicy)
        self.indicatorDownloadPolicy.color = #colorLiteral(red: 0, green: 0.469440639, blue: 1, alpha: 1)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.indicatorDownloadPolicy.insertSubview(blurEffectView, at: 0)
        
        self.indicatorDownloadPolicy.startAnimating()
        RequestPolicyOSAGO().loadData {[weak self] (model) in
        
            guard let _model = model else {
                self?.alertShow(title: "Ошибка", message: "Нет данных полиса") { (UIAlertAction) in
                    self?.closeVC()
                }
                return
            }
            
//            if _model.isError {
//                self?.alertShow(title: "Ошибка", message: _model.message!) { (UIAlertAction) in
//                    self?.closeVC()
//                }
//                return
//            }
            
            self?.modelList = _model
            
            if self?.currentModel == nil {
                self?.currentModel = model?.data?[0]
            }
            
            self?.indicatorDownloadPolicy.stopAnimating()
        }
        
    }

    
    private func buildFields(model: ModelPolicyOSAGO?) {
        
        self.indicatorDownloadPolicy.startAnimating()
        
        arrayView.forEach { (view) in
            view.removeFromSuperview()
        }
        arrayView.removeAll()
        
        print(model?.arrayFields)
        
        guard let array = model?.arrayFields else {
            self.indicatorDownloadPolicy.stopAnimating()
            return
        }
        
        
        for str in array where str.description != nil {
            let view = /*i==4 ? ViewInfoDriverOsago():*/ ViewInfoOsago()
            view.headerLabel?.text = "\(str.header)"
            view.infoLabel?.text = " \(str.description ?? "Нет данных")"
            self.arrayView.append(view)
            self.scrollView.addSubview(view)
        }
                
        self.updateStatus()
        self.updateViews()
        
        buttonSelectedCar.setTitle(getFullNameCar(model: model), for: .normal)
        self.indicatorDownloadPolicy.stopAnimating()
    }
    
    @objc func closeVC() {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    func updateViews(){
         self.scrollView.frame = CGRect(x: 0,
                                              y: header.frame.origin.y + header.frame.height,
                                              width: self.view.frame.width,
                                              height: buttonChekerRequestPolicy.frame.origin.y - (header.frame.origin.y + header.frame.height))
               
               self.indicatorDownloadPolicy.center = self.view.center
               
                       let height: CGFloat = 71.0
                       self.indicatorDownloadPolicy.frame = self.view.bounds
                       
                       self.scrollView.frame = CGRect(x: 0,
                                                      y: header.frame.origin.y + header.frame.height,
                                                      width: self.view.frame.width,
                                                      height: buttonChekerRequestPolicy.frame.origin.y - (header.frame.origin.y + header.frame.height))
                       self.scrollView!.contentSize.height = (height + 11) * (arrayView.count+1).toCGFloat()
                       
                       for i in 0..<arrayView.count {
                  
                           let view = self.arrayView[i]
                           view.frame = CGRect(x: 0,
                                               y: self.header.frame.height + i.toCGFloat() * (height + 11.0),
                                               width: self.scrollView.bounds.width,
                                               height: height)
                           
   
                       }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in 0..<self.navigationController!.viewControllers.count where self.navigationController!.viewControllers[i] is ViewControllerAutorization {
                   self.navigationController!.viewControllers.remove(at: i)
               }
        
        if !CheckInternetConnection.shared.checkInternet(in: self) {
            closeVC()
            return
        }
 
    }
    
    
    func alertShow(title: String?, message: String?, callback: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ок", style: .cancel, handler: callback)
        alert.addAction(actionOk)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private var checkRXPolicy: Bool {
        
//        let _super = RequesPolicyOSAGO(typeData: .superState)
//        let dateSent = RequesPolicyOSAGO(typeData: .dateSent)
//        let _state = RequesPolicyOSAGO(typeData: .state)
//        let paid = RequesPolicyOSAGO(typeData: .paid)
//
        if modelList == nil {
            return false
        }
//        _super.loadingData { (load) in
//            dateSent.loadingData { (load) in
//                _state.loadingData { (load) in
//                    paid.loadingData { (load) in
        return (currentModel.super ?? "").isEmpty && !(currentModel.dateSent ?? "").isEmpty && currentModel.state ?? 0 == 254 && currentModel.paid ?? false
//                        complete(_rx)
//                    }
//                }
//            }
//        }
    }
    
    func checkDownloadPolicy(callFunction: Bool ,callback: @escaping (_ state: Bool) -> Void) {
        
        if checkRXPolicy { 

                 self.buttonChekerRequestPolicy.alpha = 0
                 self.downloadAcross(callFunction: callFunction) { (state) in
                     callback(state)
                 }
             } else {
                self.requestForDownload(callback: { (dict, data, resp, error) in
                    if let httpResponse = resp as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 200..<300:
                            DispatchQueue.main.async {
                                self.buttonChekerRequestPolicy.alpha = 1
                                self.buttonChekerRequestPolicy.setTitle("Скачать полис", for: .normal)
                                if callFunction {
                                    self.sharePolicy(data: data!)
                                }
                                callback(true)
                            }
                            
                        default:
                           DispatchQueue.main.async {
                            self.buttonChekerRequestPolicy.alpha = 0
                            self.indicatorDownloadPolicy.stopAnimating()
                            if let messages = (dict?["errors"] as? [String]) {
                                    if callFunction {
                                        self.alertShow(title: "Ошибка", message: messages[0], callback: nil)
                                    }
                                }
                            }
                            callback(false)
                        }
                    }
                })
            
        }
    }
    
    
  func downloadAcross(callFunction: Bool, callback: @escaping (_ allowDownload: Bool) -> Void) {
  
        if (currentModel.pageID ?? 0) != 0 {
              
             self.buttonChekerRequestPolicy.alpha = 1
              self.buttonChekerRequestPolicy.setTitle("Скачать полис", for: .normal)
              if callFunction {
                let urlString = LocalDataSource.demo ? "https://demo-api.rx-agent.ru/v0/attachments/data/\(String(describing: currentModel.pageID))" : "https://api.rx-agent.ru/v0/attachments/data/\(String(describing: currentModel.pageID))"
                  self.sharePolicy(data: self.load(url: urlString)?.jpegData(compressionQuality: 1))
              }
              callback(false)
             }
          else {
              callback(true)
              }
  }
    
    
    func load(url: String) -> UIImage? {
       
                let data = try? Data(contentsOf: NSURL(string: url)! as URL)
                if(data != nil){
                    var image = UIImage(data: data!)
                    if(image==nil){
                        image = drawPDFfromURL(url: NSURL(string: url)! as URL)
                    }
                    return image!
                } else {
                    return nil
                }
    }

    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            ctx.cgContext.drawPDFPage(page)
        }
        
        return img
    }
    
    
    func requestForPay(type: TypeRequestPay, callback: @escaping ([String: Any]?, Data?, URLResponse?, Error?)->Void) {
        let urlString = LocalDataSource.demo ? "https://demo-api.rx-agent.ru/v0/EOSAGOPolicies/" : "https://api.rx-agent.ru/v0/EOSAGOPolicies/"
        
        var request = URLRequest(url: NSURL(string: "\(urlString)\(type)/\(EntityAuthorization().getAllDataFromDB()[0].numberPhone.dropFirst())/")! as URL)
        
        if !EntityCarUser().getDataFromDBCurrentID()[0].token.isEmpty {
            request.addValue("Bearer \(EntityCarUser().getDataFromDBCurrentID()[0].token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "PATCH"
            
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
           
            var movieData: [String: Any]?
            do {
                 guard let data = data else { return }
                movieData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                callback(movieData, nil, response, error)
            } catch _ as NSError {
                print("error")
                callback(nil, data, response, error)
            }
        })
        task.resume()
    }
    
    func requestForDownload(callback: @escaping ([String: Any]?, Data?, URLResponse?, Error?) -> Void) {
        let urlString = LocalDataSource.demo ? "https://demo-api.rx-agent.ru/v0/EOSAGOPolicies/" : "https://api.rx-agent.ru/v0/EOSAGOPolicies/"
        
        var request = URLRequest(url: NSURL(string: "\(urlString)\(TypeRequestPay.downloadPolicy)/\(EntityAuthorization().getAllDataFromDB()[0].numberPhone.dropFirst())")! as URL)
        
        if !EntityCarUser().getDataFromDBCurrentID()[0].token.isEmpty {
            request.addValue("Bearer \(EntityCarUser().getDataFromDBCurrentID()[0].token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "PATCH"
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            do {
                guard let data = data else { return }
                callback(nil, data, response, nil)
            } catch _ as NSError {
                print("error")
                callback(nil, nil, response, error)
            }
        })
        task.resume()
    }
    
    
    private func controllerButtons(state: Bool) {
        for btn in [self.buttonUpdate, self.buttonChekerRequestPolicy] {
            btn!.isUserInteractionEnabled = state
//            btn!.alpha = state ? 1 : 0.5
        }
    }
    
    @objc private func updateStatus() {
        if !CheckInternetConnection.shared.checkInternet(in: self) {
            return
        }
        
        controllerButtons(state: false)
        updateState(callFunction: false)
        
        UIView.animate(withDuration: 0.7, animations: {
            UIView.setAnimationRepeatCount(Float(Int.random(in: 0 ..< 5)))
            UIView.setAnimationBeginsFromCurrentState(true)
            self.buttonUpdate.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
        }) { (state) in
            self.buttonUpdate.transform = CGAffineTransform.init(rotationAngle: 0)
            self.controllerButtons(state: true)
        }
        
        
    }
    
    private func sharePolicy(data: Data?) {
        
        guard let image = getImage(data: data) else {
            self.indicatorDownloadPolicy.stopAnimating()
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.buttonChekerRequestPolicy
        
        //TODO: Analytics
        AnalyticEvents.logEvent(.DownloadPolicy)
        
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
        
        self.indicatorDownloadPolicy.stopAnimating()
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func updateState(callFunction: Bool) {
        
        if !CheckInternetConnection.shared.checkInternet(in: self) {
            return
        }

        checkDownloadPolicy(callFunction: callFunction) {(state) in
            if !state {
                self.requestForPay(type: .tryOpenURL) {(dict, data, resp, error) in
                    if let httpResponse = resp as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 400:
                            if let messages = (dict?["errors"] as? [String]) {
                                DispatchQueue.main.async {
                                    if callFunction {
                                        self.alertShow(title: "Ошибка", message: messages[0], callback: nil)
                                        self.indicatorDownloadPolicy.stopAnimating()
                                    }
                                }
                            } else {
                                self.indicatorDownloadPolicy.stopAnimating()
                            }
                            
                            break
                        case 200..<300:
                            self.requestForPay(type: .OpenURL, callback: {(dictonary, data, url, error) in
                                if let items = dictonary?["result"] as? [String: Any] {
                                    DispatchQueue.main.async {
                                        let cost: NSNumber = items["companyCost"] as? NSNumber ?? NSNumber(value: 0)
                                        
                                        let title: String = Int(truncating: cost) > 0 ? "Оплатить \(cost) ₽" : "Оплатить"
                                        
                                        self.buttonChekerRequestPolicy.alpha = 1
                                        self.buttonChekerRequestPolicy.setTitle(title, for: .normal)
                                        let companyState = items["companyState"] as? Int
                                        
                                        switch companyState {
                                        case 3:
                                            if callFunction, let url = URL(string: items["companyURL"] as! String) {
                                                UIApplication.shared.open(url)
                                            }
                                            break
                                        case 4:
                                            self.requestForPay(type: .getPolicy, callback: { (dict, data, resp, error) in
                                            })
                                            break
                                        default:
                                            break
                                        }
                                    }
                                }
                            })
                            break
                        default:
                            
                            DispatchQueue.main.async {
                                self.buttonChekerRequestPolicy.alpha = 0
                                self.indicatorDownloadPolicy.stopAnimating()
                            }
                            break
                        }
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func buttonTest(_ sender: UIButton) {
        self.indicatorDownloadPolicy.startAnimating()
       updateState(callFunction: true)
    }
    
    
    private func getFullNameCar(model: ModelPolicyOSAGO?) -> String {
        return String(format: "%@ %@", model?.vehicleMark ?? "", model?.vehicleModel ?? "")
    }
    
    private func getImage(data: Data?) -> UIImage?{
        
        guard let _data = data else {
            return nil
        }
        
            var image = UIImage(data: _data)
                if(image == nil) {
                    createPDF(data: _data)
                    image = drawPDFfromPath(url: loadPDF())
                }
                return image!
    }
    
    @IBAction func selectedCar(_ sender: Any) {
        
        let alert = UIAlertController(title: "Выбор авто", message: "Выберите авто", preferredStyle: .actionSheet)
        
            for model in self.modelList.data! where self.modelList.data != nil {
                let action = UIAlertAction(title: self.getFullNameCar(model: model), style: .default) { (alert) in
                    self.currentModel = model
                }
                alert.addAction(action)
            }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func loadPDF() -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let url = URL(fileURLWithPath: documentsPath, isDirectory: true).appendingPathComponent("file").appendingPathExtension("pdf")
        return url
    }

    private func createPDF(data: Data) {
//        let data = //the stuff from your web request or other method of getting pdf
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = NSURL(fileURLWithPath:"\(documentsPath)/file.pdf")

        try! data.write(to: filePath as URL, options: .atomicWrite)
    }

    private func drawPDFfromPath(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }

        return img
    }
    



