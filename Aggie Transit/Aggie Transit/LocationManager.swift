//
//  LocationManager.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/13/23.
//

import Foundation
import CoreLocation

class LocationManager: CLLocationManager {
    static let shared = LocationManager()
    var currentLocation: CLLocation?
    private override init(){
        
    }
}
