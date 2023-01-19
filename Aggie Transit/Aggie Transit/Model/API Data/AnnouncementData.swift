//
//  Announcement.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/16/23.
//

import Foundation
//MARK: - this class parses announcement data
struct AnnouncementData: Codable {
    var Items: [AnnouncementStruct]
}

struct AnnouncementStruct: Codable {
    var Summary: SummaryStruct
    var Title: SummaryStruct
}

struct SummaryStruct: Codable {
    var Text: String
}
