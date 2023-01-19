//
//  LocationManager.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/13/23.
//

import Foundation
import CoreLocation

// this class is used to manage the user's current location
class LocationManager: CLLocationManager {
    static let shared = LocationManager()
    var currentLocation: CLLocation?
    private override init(){}
}
