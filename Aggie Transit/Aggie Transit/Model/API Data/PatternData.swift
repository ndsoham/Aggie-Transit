//
//  StopData.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/21/22.
//

import Foundation
//MARK: - this class is used to parse pattern data
struct PatternData: Codable {
    var Key: String
    var Name: String
    var Description: String
    var Rank: Int
    var Longtitude: Double
    var Latitude: Double
    var PointTypeCode: Int
    var Stop: StopStruct?
    var RouteHeaderRank: Int
}

struct StopStruct: Codable {
    var Key: String
    var Rank: Int
    var Name: String
    var StopCode: String
    var IsTimePoint: Bool
}
