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
    
    private var scrollView: UIScrollView!
    @IBOutlet weak var buttonChekerRequestPolicy: UIButton!
    
    enum TypeRequestPay: String {
        case tryOpenURL, OpenURL, getPolicy, downloadPolicy
    }
    
    private var arrayView: [ViewInfoOsago] = []
    lazy var indicatorDownloadPolicy = UIActivityIndicatorView()
    
    let array = [FieldInformationOSAGO(typeData: .FullName),
                 FieldInformationOSAGO(typeData: .Mark),
                 FieldInformationOSAGO(typeData: .VIN),
                 FieldInformationOSAGO(typeData: .NumberBody),
                 FieldInformationOSAGO(typeData: .NumberAuto),
                 FieldInformationOSAGO(typeData: .StartDate),
                 FieldInformationOSAGO(typeData: .CountMonth)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonChekerRequestPolicy.layer.masksToBounds = true
        self.buttonChekerRequestPolicy.layer.cornerRadius = 30
        
        buttonClose.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        buttonUpdate.addTarget(self, action: #selector(updateStatus), for: .touchUpInside)
        
        self.scrollView = UIScrollView()
        self.view.insertSubview(self.scrollView, at: 0)
        self.scrollView.alwaysBounceVertical = true
      
            for _ in 0..<array.count {
                let view = /*i==4 ? ViewInfoDriverOsago():*/ ViewInfoOsago()
                self.arrayView.append(view)
                self.scrollView.addSubview(view)
            }
        
        self.view.addSubview(self.indicatorDownloadPolicy)
        self.indicatorDownloadPolicy.color = #colorLiteral(red: 0, green: 0.469440639, blue: 1, alpha: 1)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.alpha = 0.8
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.indicatorDownloadPolicy.insertSubview(blurEffectView, at: 0)
        
    }

    
    @objc func closeVC() {
        self.navigationController!.popToViewController(LocalDataSource.servicesViewController, animated: true)
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = CGRect(x: 0,
                                       y: header.frame.origin.y + header.frame.height,
                                       width: self.view.frame.width,
                                       height: buttonChekerRequestPolicy.frame.origin.y - (header.frame.origin.y + header.frame.height))
        
        self.indicatorDownloadPolicy.center = self.view.center
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !CheckInternetConnection.shared.checkInternet(in: self) {
            closeVC()
            return
        }
        
        self.indicatorDownloadPolicy.startAnimating()
        self.updateStatus()
        
        let height: CGFloat = 71.0
        self.indicatorDownloadPolicy.frame = self.view.bounds
        
        self.scrollView.frame = CGRect(x: 0,
                                       y: header.frame.origin.y + header.frame.height,
                                       width: self.view.frame.width,
                                       height: buttonChekerRequestPolicy.frame.origin.y - (header.frame.origin.y + header.frame.height))
        self.scrollView!.contentSize.height = (height + 11) * (array.count+1).toCGFloat()
        
        var arrayLoad: [Bool] = []
        
        for i in 0..<array.count {
   
            let view = self.arrayView[i]
            view.frame = CGRect(x: 0,
                                y: self.header.frame.height + i.toCGFloat() * (height + 11.0),
                                width: self.scrollView.bounds.width,
                                height: height)
            
            self.array[i].loadingData {(load) in
                
                (view).headerLabel?.text = self.array[i].headerField
                (view).infoLabel?.text = " \(self.array[i].info)"
                
                if load {
                    arrayLoad.append(load)
                }

                if arrayLoad.count == self.array.count + 1 {
                    if arrayLoad.contains(true) {
                        self.indicatorDownloadPolicy.stopAnimating()
                    } else {
                        self.indicatorDownloadPolicy.stopAnimating()
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for i in 0..<self.navigationController!.viewControllers.count where self.navigationController!.viewControllers[i] is ViewControllerAutorization {
            self.navigationController!.viewControllers.remove(at: i)
        }
        
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        if !UserAuthorization.sharedInstance.getActivateUser() {
            closeVC()
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    func alertShow(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        
        alert.addAction(actionOk)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func checkRXPolicy(complete: @escaping (_ rx: Bool) -> Void) {
        
        let _super = FieldInformationOSAGO(typeData: .Super)
        let dateSent = FieldInformationOSAGO(typeData: .DateSent)
        let _state = FieldInformationOSAGO(typeData: .State)
        let paid = FieldInformationOSAGO(typeData: .Paid)
        
        _super.loadingData { (load) in
            dateSent.loadingData { (load) in
                _state.loadingData { (load) in
                    paid.loadingData { (load) in
                        let _rx = _super.info.isEmpty && !dateSent.info.isEmpty && _state.info == "254" && !paid.info.isEmpty
                        complete(_rx)
                    }
                }
            }
        }

    }
    
    func checkDownloadPolicy(callFunction: Bool ,callback: @escaping (_ state: Bool) -> Void) {
        
        checkRXPolicy { (rx) in

             if rx {
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
                                        self.alertShow(title: "Ошибка", message: messages[0])
                                    }
                                }
                            }
                            callback(false)
                        }
                    }
                })
            }
        }
    }
    
    
  func downloadAcross(callFunction: Bool, callback: @escaping (_ allowDownload: Bool) -> Void) {
  
      let padeID = FieldInformationOSAGO(typeData: .PageID)
          padeID.loadingData { (loading) in
              if loading && !padeID.info.isEmpty {
              
             self.buttonChekerRequestPolicy.alpha = 1
              self.buttonChekerRequestPolicy.setTitle("Скачать полис", for: .normal)
              if callFunction {
              let urlString = LocalDataSource.demo ? "https://demo-api.rx-agent.ru/v0/attachments/data/\(padeID.info)" : "https://api.rx-agent.ru/v0/attachments/data/\(padeID.info)"
                  self.sharePolicy(data: self.load(url: urlString)?.jpegData(compressionQuality: 1))
              }
              callback(false)
             }
          else {
              callback(true)
              }
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
//            print(request)
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
        
        let image = getImage(data: data)
        let activityViewController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
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
                                        self.alertShow(title: "Ошибка", message: messages[0])
                                        self.indicatorDownloadPolicy.stopAnimating()
                                    }
                                }
                            }
                            else {
                                self.indicatorDownloadPolicy.stopAnimating()
                            }
                            break
                        case 200..<300:
                            self.requestForPay(type: .OpenURL, callback: {(dictonary, data, url, error) in
                                if let items = dictonary?["result"] as? [String: Any] {
                                    DispatchQueue.main.async {
                                        let cost = items["companyCost"] as! NSNumber
                                        self.buttonChekerRequestPolicy.alpha = 1
                                        self.buttonChekerRequestPolicy.setTitle("Оплатить \(cost) ₽", for: .normal)
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
                            self.buttonChekerRequestPolicy.alpha = 0
                            self.indicatorDownloadPolicy.stopAnimating()
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
    
    
    private func getImage(data: Data?) -> UIImage?{
            var image = UIImage(data: data!)
                if(image == nil) {
                    createPDF(data: data!)
                    image = drawPDFfromPath(url: loadPDF())
                }
                return image!
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
    
}


