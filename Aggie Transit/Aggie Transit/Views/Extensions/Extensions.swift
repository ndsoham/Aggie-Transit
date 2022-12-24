//
//  Color.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/20/22.
//

import Foundation
import UIKit
//MARK: - UI Color Extension to create rgb color from string
extension UIColor {
    class func colorFromRGBString(string: String) -> UIColor {
        if string.contains("rgb"){
            let alpha = 1.0
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
        }
        else if string == "Firebrick" {
            return UIColor(red: 178/255, green: 34/255, blue: 34/255, alpha: 1.0)
        }
        else if string == "DarkOrchid" {
            return UIColor(red: 153/255, green: 50/255, blue: 204/255, alpha: 1.0)
        }
        else if string == "Purple" {
            return UIColor(red: 128/255, green: 4/255, blue: 128/255, alpha: 1.0)
        }
        else if string == "RoyalBlue" {
            return UIColor(red: 65/255, green: 105/255, blue: 225/255, alpha: 1.0)
        }
        else if string == "Crimson" {
            return UIColor(red: 220/255, green: 20/255, blue: 61/255, alpha: 1.0)
        }

        return UIColor(red: 80/255, green: 0, blue: 0, alpha: 1.0)
        
    }
}
//MARK: - UISegementedControl extension to conform to UIScrollViewDelegate
extension UISegmentedControl: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.selectedSegmentIndex = scrollView.currentPage
    }
}
//MARK: - UIScrollView Extension to create a page property
extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)
    }
}
