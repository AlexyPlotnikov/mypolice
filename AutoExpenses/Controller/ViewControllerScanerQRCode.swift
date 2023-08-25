//
//  ViewControllerScanerQRCode.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 08/08/2019.
//  Copyright © 2019 rx. All rights reserved.
//
import AVFoundation
import UIKit


protocol DelegateDataFromQRCode {
    func newExpensesSum(sum: Float, date: Date)
}

class ViewControllerScanerQRCode: ViewControllerThemeColor, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var frameView: UIView!
    private var frameRect = CGRect.zero
    @IBOutlet weak var viewMask: UIView!
    var delegate: DelegateDataFromQRCode?
    @IBOutlet weak var labelDescription: UILabel!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        self.frameRect = CGRect(x: 16,
                                y: self.view.frame.midY - self.view.frame.height * 0.25,
                                width: self.view.frame.width-32,
                                height: self.view.frame.width-16)
        
        let overlay = createOverlay()
        self.frameView.addSubview(overlay)
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            metadataOutput.rectOfInterest = self.frameView.bounds
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.viewCamera.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.viewCamera.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            found(code: stringValue)
        }
    }
    
    func createOverlay() -> UIView {
        
        let overlayView = UIView(frame: self.viewCamera.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let path = CGMutablePath()
        path.addRect(self.view.bounds)
        
        path.addRoundedRect(in: frameRect, cornerWidth: 15, cornerHeight: 15)
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        return overlayView
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func found(code: String) {
        
        let separators = CharacterSet(charactersIn: "&")
        let words = code.components(separatedBy: separators)
        
        let sum = getParsing(symbol: "s", stringsToReading: words)
        let date = getParsing(symbol: "t", stringsToReading: words)?.toDateTime(format: "yyyyMMdd") ?? Date()
        
        if sum == nil {
            self.labelDescription.text = "Не удается распознать \n QR - код"
            return
        }
        
        self.labelDescription.text = "QR - код считан"
        captureSession.stopRunning()
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        if self.delegate != nil {
            self.delegate?.newExpensesSum(sum: (Float(sum!))!, date: date)
        }
        
        self.dismiss(animated: true)
    }
    
    
    func getParsing(symbol: Character, stringsToReading: [String]) -> String? {
        for item in stringsToReading where item.first == symbol {
            let arrayChars = item.split(separator: "=")
            if arrayChars.count > 0 {
                let str = arrayChars[arrayChars.count-1].description
                return str.split(separator: "T")[0].description
            }
        }
         return nil
    }
    
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
    }
