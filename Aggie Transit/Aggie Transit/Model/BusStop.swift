//
//  BusStop.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/26/22.
//

import Foundation
import MapKit
@objc class BusStop: NSObject {
    var name: String
    var location: CLLocationCoordinate2D
    var isTimePoint: Bool
    init(name: String, location: CLLocationCoordinate2D,  isTimePoint: Bool) {
        self.name = name
        self.location = location
        self.isTimePoint = isTimePoint
    }
}
