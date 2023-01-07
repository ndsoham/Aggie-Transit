//
//  BusData.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/2/23.
//

import Foundation

struct BusData: Codable {
    var route: String
    var key: String
    var lat: String
    var lng: String
    var direction: String
    var occupancy: String
    var nextStop: String
    var estDepart: String
}
