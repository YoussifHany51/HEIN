//
//  CustomClasses.swift
//  HEIN
//
//  Created by Marco on 2024-09-18.
//

import Foundation
import UIKit

//@IBDesignable
class CustomButton: UIButton {
    @IBInspectable var isRounded: Bool = false {
        didSet {
            layer.cornerRadius = isRounded ? min(frame.width, frame.height) / 2 : 0
            layer.masksToBounds = isRounded ? true : false
        }
    }
}

//@IBDesignable
class CustomView: UIView {
    @IBInspectable var Rounded: Bool = false {
        didSet {
            layer.cornerRadius = Rounded ? 10 : 0
            //layer.masksToBounds = Rounded ? true : false
        }
    }
    
    @IBInspectable var Shadowed: Bool = false {
        didSet {
            layer.shadowRadius = 12
            layer.shadowOpacity = 0.28
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowColor = UIColor.gray.cgColor
            //layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            //clipsToBounds = false
        }
    }

}

//@IBDesignable
class CustomImageView: UIImageView {
    @IBInspectable var Rounded: Bool = false {
        didSet {
            layer.cornerRadius = Rounded ? 10 : 0
            //layer.masksToBounds = Rounded ? true : false
        }
    }
    
    @IBInspectable var Shadowed: Bool = false {
        didSet {
            layer.shadowRadius = 12
            layer.shadowOpacity = 0.28
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowColor = UIColor.gray.cgColor
            //layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            //clipsToBounds = false
        }
    }

}
