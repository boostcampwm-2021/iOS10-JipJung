//
//  UILabel+Extension.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/15.
//

import UIKit

//https://stackoverflow.com/questions/39158604/how-to-increase-line-spacing-in-uilabel-in-swift

extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else if let labelText = self.text {
            attributedString = NSMutableAttributedString(string: labelText)
        } else {
            attributedString = NSMutableAttributedString(string: "")
        }
        
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedString.length))
        attributedText = attributedString
    }
}
