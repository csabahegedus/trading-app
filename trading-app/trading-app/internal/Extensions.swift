//
//  Extensions.swift
//  trading-app
//
//  Created by Hegedűs Csaba on 2021. 02. 19..
//

import UIKit


extension UIAlertController{
    class func showAlertViewWithTitle(_ title : String, message : String, buttonTitle: String, buttonAction:(()->())?, parentController:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (action) -> Void in
            buttonAction?()
        }))
        parentController.present(alert, animated: true, completion: nil)
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return ((self * divisor).rounded() / divisor)
    }
}

extension NSMutableAttributedString {
    var fontSize: CGFloat { return 16 }
    var normalFont: UIFont { return UIFont.systemFont(ofSize: fontSize) }
    var boldFont: UIFont { return UIFont.boldSystemFont(ofSize: fontSize) }

    func normal(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func small(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 10),
            .foregroundColor : UIColor.darkText
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func bold(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func gray(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  UIFont.systemFont(ofSize: 10),
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.gray
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  boldFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
