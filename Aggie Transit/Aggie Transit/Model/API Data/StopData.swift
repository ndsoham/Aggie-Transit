//
//  StopData.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/26/22.
//

import Foundation

struct StopData: Codable {
    var Key: String
    var Name: String
    var Description: String
    var Rank: Int
    var Longtitude: Double
    var Latitude: Double
    var PointTypeCode: Int
    var Stop: StopStruct
    var RouteHeaderRank: Int
}
