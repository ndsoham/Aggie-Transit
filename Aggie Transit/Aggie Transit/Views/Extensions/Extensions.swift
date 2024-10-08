//
//  Extensions.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/20/22.
//

import Foundation
import UIKit
import MapKit
import FloatingPanel
//MARK: - UI Color Extension to create rgb color from string
extension UIColor {
     static func colorFromRGBString(string: String) -> UIColor {
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
         // these are default colors returned for the bus routes that do not specify an rgb value
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
    func inverseColor() -> UIColor {
        var alpha: CGFloat = 1.0
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: alpha)
        }
        fatalError("Not possible to get this color's inverse")
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
//MARK: - UIImage view extension to point the bus in the right direction
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}
//MARK: - use to convert to radians
func rad(_ number: Double) -> Double {
    return number * Double.pi / 180
}
//MARK: - Use to find distance
extension CLLocationCoordinate2D {
    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        MKMapPoint(self).distance(to: MKMapPoint(to))
    }
}
//MARK: - Use this to order the bus stops, insertions
extension Array {
    mutating func rotateLeft(positions: Int) {
        let index = self.index(startIndex, offsetBy: positions, limitedBy: endIndex) ?? endIndex
        let slice = self[..<index]
        removeSubrange(..<index)
        insert(contentsOf: slice, at: endIndex)
    }
    mutating func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else {return}
        let item = self[sourceIndex]
        self.remove(at: sourceIndex)
        self.insert(item, at: destinationIndex)
    }
}
