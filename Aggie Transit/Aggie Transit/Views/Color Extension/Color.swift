//
//  Color.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/20/22.
//

import Foundation
import UIKit

extension UIColor {
    class func colorFromRGBString(string: String) -> UIColor {
        let alpha = 1.0
//        var red = 0.0
//        var green = 0.0
//        var blue = 0.0
        var colorString = string
        // remove rgb
        colorString = colorString.replacingOccurrences(of: "rgb", with: "")
        // remove parentheses
        colorString = colorString.replacingOccurrences(of: "(", with: "")
        colorString = colorString.replacingOccurrences(of: ")", with: "")
        // split by comma
        let colorArray = colorString.split(separator: ",")
        // init rgb values
        if let red = Double(colorArray[0]), let green = Double(colorArray[1]), let blue = Double(colorArray[2]) {
            return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)

        }
        return UIColor()
        
    }
}

