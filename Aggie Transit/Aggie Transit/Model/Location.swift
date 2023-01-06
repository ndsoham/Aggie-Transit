//
//  Location.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/3/23.
//

import Foundation
import MapKit

@objc class Location: NSObject {
    var name: String
    var location: CLLocationCoordinate2D
    var address: String
    init(name: String, location: CLLocationCoordinate2D, address: String) {
        self.name = name
        self.location = location
        self.address = address
    }
}
