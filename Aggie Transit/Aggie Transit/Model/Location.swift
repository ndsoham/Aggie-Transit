//
//  Location.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/3/23.
//

import Foundation
import MapKit
//MARK: - This class is used to designate starting and destination locations along a route
@objc class Location: NSObject {
    var name: String
    var location: CLLocationCoordinate2D
    var address: String
    var distance: Double?
    init(name: String, location: CLLocationCoordinate2D, address: String) {
        self.name = name
        self.location = location
        self.address = address
    }
}
