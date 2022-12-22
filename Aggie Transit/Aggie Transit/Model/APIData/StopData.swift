//
//  StopData.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/21/22.
//

import Foundation

struct StopData: Codable {
    var Key: String
    var Name: String
    var Description: String
    var Longtitude: Float
    var Latitude: Float
    var PointTypeCode: Int
    var Stop: StopStruct
    var RouteHeaderRank: Int
}

struct StopStruct: Codable {
    var Key: String
    var Rank: Int
    var Name: String
    var StopCode: String
    var IsTimePoint: Bool
}
