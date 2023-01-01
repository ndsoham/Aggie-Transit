//
//  BusStop.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/21/22.
//

import Foundation
import MapKit
@objc class BusPattern: NSObject {
    var name: String
    var location: CLLocationCoordinate2D
    init(name: String, location: CLLocationCoordinate2D) {
        self.name = name
        self.location = location
    }
}
