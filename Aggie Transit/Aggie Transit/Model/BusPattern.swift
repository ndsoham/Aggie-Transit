//
//  BusStop.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/21/22.
//

import Foundation
import MapKit
//MARK: - This is a representation of a single point within a bus route's traveling pattern
@objc class BusPattern: NSObject {
    var name: String
    var location: CLLocationCoordinate2D
    var key: String
    init(name: String, location: CLLocationCoordinate2D, id: String) {
        self.name = name
        self.location = location
        self.key = id
    }
}
