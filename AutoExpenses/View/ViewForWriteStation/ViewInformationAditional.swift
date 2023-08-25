//
//  ViewInformationAditional.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 07.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit


protocol DelegateInformationAditional: class {
    var needSelectProtectEngine: Bool { get set }
    var additionalInfo: String { get set }
}

struct SettingsTextView {
    
    var needPlaceholder: Bool {
        get {
            return text.isEmpty || text == "Комментарий"
        }
        set {
            
        }
    }
    
    var text: String {
        didSet (_text) {
            self.text = needPlaceholder || _text.isEmpty ? "Комментарий" : _text
        }
    }
    
    var color: UIColor {
        get {
            return text.isEmpty || text == "Комментарий" ? UIColor.init(rgb: 0x9D9D9D) : .black
        }
    }
    
}

class ViewInformationAditional: UIView {

    enum PosTextView {
        case Up
        case Default
    }
    
    private var viewSelectedProtectEngine: ViewSelectedProtectedEngine?
    private var textView: UITextView?
    private var viewBack: UIView?
    private let windowView = UIApplication.shared.keyWindow!
    private weak var delegate: DelegateInformationAditional!
    private var posTextView: PosTextView = .Default
    private var keyboardHeight: CGFloat = 0
    
    init(frame: CGRect, delegate: DelegateInformationAditional) {
        super.init(frame: frame)
        self.delegate = delegate
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // натификашка вызова клавиатуры
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
            
            self.posTextView = .Up
            viewBack?.addSubview(self.textView!)
            UIView.animate(withDuration: 0.2) {
                self.viewBack?.alpha = 1
            }
        }
    }
    
    @objc private func tapScreen() {
        textView!.endEditing(true)
    }
    
    @objc private func keyboardHide(_ notification: Notification) {
        
        self.posTextView = .Default
        self.addSubview(self.textView!)
        UIView.animate(withDuration: 0.2) {
            self.viewBack?.alpha = 0
        }
    }
    
    private func setup() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)),name:UIResponder.keyboardWillHideNotification,object: nil)
        
        viewSelectedProtectEngine = ViewSelectedProtectedEngine(frame: self.bounds, text: "Имеется защита двигателя", delegate: delegate)
        self.addSubview(viewSelectedProtectEngine!)
    
        if #available(iOS 13.0, *) {
            windowView.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        viewBack = UIView()
        windowView.addSubview(viewBack!)
        viewBack!.backgroundColor = .white
        viewBack?.alpha = 0
        viewBack?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapScreen)))
    
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        toolbar.barStyle = .default
        toolbar.backgroundColor = .white
        toolbar.sizeToFit()
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                         UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(tapScreen))]
        
        textView = UITextView()
        textView?.delegate = self
        textView?.inputAccessoryView = toolbar
        checkText(text: delegate.additionalInfo, clear: false)
        textView?.layer.cornerRadius = 6
        textView?.textContainerInset = UIEdgeInsets(top: 11, left: 12, bottom: 11, right: 12)
        textView?.layer.borderColor = UIColor.init(rgb: 0xCCCCCC).cgColor
        textView?.layer.borderWidth = 1
        textView?.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        self.addSubview(textView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        self.endEditing(true)
        
        let spacing: CGFloat = 8
        viewSelectedProtectEngine!.frame = CGRect(x: -1, y: spacing, width: self.frame.width + 2, height: self.frame.height * 0.20 - spacing)
        viewSelectedProtectEngine?.setNeedsLayout()
        
        let heightArea = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        viewBack?.frame = CGRect(x: 0, y: heightArea, width: UIApplication.shared.keyWindow!.frame.width, height: UIApplication.shared.keyWindow!.frame.height - heightArea * 2)
        
        switch posTextView {
        case .Default:
             textView?.frame = CGRect(x: 22, y: viewSelectedProtectEngine!.frame.origin.y + viewSelectedProtectEngine!.frame.height + 20, width: self.frame.width - 22 * 2, height: self.frame.height - (viewSelectedProtectEngine!.frame.height + 20 * 2))
        case .Up:
            
            textView?.frame = CGRect(x: 16, y: 8, width: viewBack!.frame.width - 32, height: viewBack!.frame.height - keyboardHeight - 16)
        }
    }
    
    
    private func checkText(text: String, clear: Bool) {
        if text.isEmpty || text == "Комментарий" {
            if clear {
                textView!.text.removeAll()
                textView!.textColor = .black
            } else {
                textView!.text = "Комментарий"
                textView!.textColor = UIColor.init(rgb: 0x9D9D9D)
            }
        } else {
            textView!.textColor = .black
            textView!.text = text
        }
    }
    
}

extension ViewInformationAditional: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        checkText(text: textView.text, clear: true)
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
         self.delegate.additionalInfo = textView.text
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        checkText(text: textView.text, clear: false)
    }
}
