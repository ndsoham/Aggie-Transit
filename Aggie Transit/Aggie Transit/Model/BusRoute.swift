//
//  BusRoute.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/20/22.
//

import Foundation
import UIKit
import MapKit
protocol PathMakerDelegate {
    func displayBusRoutePatternOnMap(color: UIColor, points: [CLLocationCoordinate2D])
}
class BusRoute: NSObject {
    var name: String
    var number: String
    var color: UIColor
    var campus: String
    var delegate: PathMakerDelegate?
    init(name: String, number: String, color: UIColor, campus: String){
        self.name = name
        self.number = number
        self.color = color
        self.campus = campus
    }
    func displayBusRoutePatternOnMap() {
        var endpoint = "route/{route}/pattern"
        endpoint = endpoint.replacingOccurrences(of: "{route}", with: number)
        let dataGatherer = DataGatherer()
        dataGatherer.gatherData(endpoint: endpoint)
        dataGatherer.delegate = self
    }
}

extension BusRoute: DataGathererDelegate {
    func didGatherBusPattern(points: [BusPattern]) {
        var pattern:[CLLocationCoordinate2D] = []
        for point in points {
            pattern.append(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
        }
        delegate?.displayBusRoutePatternOnMap(color: color, points: pattern)
    }
}



