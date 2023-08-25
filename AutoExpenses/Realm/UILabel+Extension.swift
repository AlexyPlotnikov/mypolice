//
//  UILabel+Extension.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 10/09/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

struct NewAttrChar {
    var color: UIColor
    var font: UIFont
    var char: String
}

extension UILabel {
    
    func addSpacing(countSpace: Int) {
        guard let text = self.text else { return }
        self.text = ""
        for _ in 0..<countSpace {
            self.text! += " "
        }
        
        self.text! += text
    }
    
    func setNewChar(newAttr: NewAttrChar, standartColor: UIColor) {
        let attributedStringChar = NSAttributedString(string: newAttr.char, attributes: [NSAttributedString.Key.foregroundColor: newAttr.color, .font: newAttr.font])
        let attributedStringLabel = NSAttributedString(string: self.text!, attributes: [.foregroundColor : standartColor, .font: self.font!])
        let arrayAttr = NSMutableAttributedString()
        
        arrayAttr.append(attributedStringLabel)
        arrayAttr.append(attributedStringChar)
        self.attributedText = arrayAttr
    }
    
    func setNewChar(newArrayAttr: [NewAttrChar]) {
        
         let arrayAttr = NSMutableAttributedString()
        
        self.numberOfLines = newArrayAttr.count*2
        
        for item in newArrayAttr {
            let attributedStringChar = NSAttributedString(string: item.char, attributes: [NSAttributedString.Key.foregroundColor: item.color, .font: item.font])
            
             arrayAttr.append(attributedStringChar)
        }
        
       
        self.attributedText = arrayAttr
    }
    
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText

        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font!])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }

    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
    

    var heightLabel: CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height

    }
    
}
