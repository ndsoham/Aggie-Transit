//
//  Bus.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/2/23.
//

import Foundation
import MapKit
class Bus: NSObject {
    var location: CLLocationCoordinate2D
    var direction: CLLocationDirection
    var name: String
    var nextStop: String
    init(location: CLLocationCoordinate2D, direction: CLLocationDirection, name: String, nextStop: String) {
        self.location = location
        self.direction = direction
        self.name = name
        self.nextStop = nextStop
    }
}
