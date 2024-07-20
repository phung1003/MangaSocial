//
//  Extension.swift
//  MangaSocial
//
//  Created by ATULA on 15/03/2024.
//

import Foundation
import UIKit
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension UIImageView {
    
    func makeRounded() {
        
        
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}

extension UIButton {
    func createImage(withSize size: CGSize, named imageName: String) -> UIImage? {
        // Load the image from the asset catalog
        if let image = UIImage(named: imageName) {
            // Resize the image to the desired size
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resizedImage
        }
        return nil
    }
    
    func configButton(img: String, imgSize: Double, attributes: [NSAttributedString.Key: Any]) {
        let image = createImage(withSize: CGSize(width: imgSize, height: imgSize), named: img)
        setImage(image, for: .normal)
        clipsToBounds = true
       
        
        let title = NSAttributedString(string: title(for: .normal) ?? "", attributes: attributes)
        setAttributedTitle(title, for: .normal)
        
    }
}


extension UITextField {
    
    func addLeftImage(name: String) {
        let imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: name)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        container.addSubview(imageView)
        leftView = container
        leftViewMode = .always
        self.tintColor = UIColor.lightGray
    }
    
    func addRightImage(name: String) {
        let imageView = UIImageView(frame: CGRect(x: -5, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: name)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        container.addSubview(imageView)
        rightView = container
        rightViewMode = .always
        self.tintColor = UIColor.lightGray
    }
    
    func bottomBorder(color: CGColor) {
        let bottomLine = CALayer()
        let borderWidth = CGFloat(1.0)
        bottomLine.borderColor = color
        bottomLine.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - 1), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        bottomLine.borderWidth = borderWidth
        self.layer.addSublayer(bottomLine)
        self.layer.masksToBounds = true
    }
}

extension UITextView {
    func bottomBorder(color: UIColor) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: self.frame.minX, y: self.superview!.frame.maxY - 1, width: self.frame.size.width, height: 1)
        self.layer.masksToBounds = true
        self.superview!.addSubview(border)
    }
    
    func changeBottomBorder(color: UIColor) {
        if let latestView = self.superview!.subviews.last {
            latestView.removeFromSuperview()
        }
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: self.frame.minX, y: self.superview!.frame.maxY - 1, width: self.frame.size.width, height: 1)
        self.layer.masksToBounds = true
        self.superview!.addSubview(border)
    }
    
}

extension UIImage {
    func toBase64() -> String {
        if let imageData = self.jpegData(compressionQuality: 1.0) {
            let base64String = imageData.base64EncodedString()
            return base64String
        } else {
            if let imageData = self.pngData() {
                let base64String = imageData.base64EncodedString()
                return base64String
            }
        }
        return("Can't Convert To Base64")
    }
}



extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}


func colorFromHex(hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if cString.hasPrefix("#") {
        cString.remove(at: cString.startIndex)
    }

    if cString.count != 6 {
        return UIColor.gray
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}

// Sử dụng hàm để tạo UIColor từ mã hex

