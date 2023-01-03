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
    func displayBusRoutePatternOnMap(color: UIColor, points: [BusPattern])
    func displayBusRouteStopsOnMap(color: UIColor, stops: [BusStop])
    func displayBusesOnMap(buses:[Bus])
}
class BusRoute: NSObject {
    var name: String
    var number: String
    var color: UIColor
    var campus: String
    var delegate: PathMakerDelegate?
    private let dataGatherer = DataGatherer()
    init(name: String, number: String, color: UIColor, campus: String){
        self.name = name
        self.number = number
        self.color = color
        self.campus = campus
    }
    // this displays the pattern on the map
    func displayBusRoutePatternOnMap() {
        let endpoint = "route/\(number)/pattern"
        dataGatherer.delegate = self
        dataGatherer.gatherData(endpoint: endpoint)
    }
    // this displays the stops on the map
    func displayBusRouteStopsOnMap() {
        let endpoint = "route/\(number)/stops"
        dataGatherer.delegate = self
        dataGatherer.gatherData(endpoint: endpoint)
    }
    // this displays the buses on the map
    func displayBusesOnMap(){
        let endpoint = "route/\(number)/buses"
        dataGatherer.delegate = self
        dataGatherer.gatherData(endpoint: endpoint)
    }
    
}

extension BusRoute: DataGathererDelegate {
    func didGatherBusPattern(points: [BusPattern]) {
        delegate?.displayBusRoutePatternOnMap(color: color, points: points)
    }
    func didGatherBusStops(stops: [BusStop]) {
        delegate?.displayBusRouteStopsOnMap(color: color, stops: stops)
    }
    func didGatherBuses(buses: [Bus]) {
        delegate?.displayBusesOnMap(buses: buses)
    }
}



