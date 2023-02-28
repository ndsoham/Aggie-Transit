//
//  BusRoute.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/19/22.
//

import Foundation
//MARK: - This class is used to parse route data
struct RouteData: Codable {
    var Group: GroupStruct
    var Icon: String?
    var TimeTableOverride: TimeTableOvverrideStruct
    var WebLink: Bool
    var Color: String
    var Pattern: PatternStruct
    var Key: String
    var Name: String
    var ShortName: String
    var Description: String
    var RouteType: TypeStruct
}

struct GroupStruct: Codable {
    var Name: String
    var Order: Int
    var IsGameDay: Bool
}

struct TimeTableOvverrideStruct: Codable {
    var Enabled: Bool
    var Before: Double
    var During: Bool
    var After: Double
}

struct PatternStruct: Codable {
    var Key: String
    var Name: String
    var ShortName: String
    var Description: String
    var Direction: [String: String]
    var LineInfo: InfoStruct
    var TimePointInfo: InfoStruct
    var BusStopInfo: InfoStruct
    var IsDisplay: Bool
    var IsPrimary: Bool
}

struct InfoStruct: Codable {
    var Color: String
    var `Type`: Int
    var Symbol: Int
    var Size: Int
}

struct TypeStruct: Codable {
    var Key: String
    var Name: String
    var Description: String
}


