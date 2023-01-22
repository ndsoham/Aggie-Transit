//
//  CoordinateConverter.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/22/22.
//

import Foundation
//MARK: - This function converts from a mercator project coordinate to a global coordinate
func CoordinateConverter(latitude: Double, longitude: Double) -> (Double, Double) {
    let radius = 6378137.0
    let newLat = (atan(sinh(latitude/radius)) * 180.0) / Double.pi
    let newLong = (longitude / radius * 180.0) / Double.pi
    return (newLat, newLong)
}
