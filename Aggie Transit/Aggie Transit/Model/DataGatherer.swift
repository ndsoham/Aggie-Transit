//
//  DataParser.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/18/22.
//

import Foundation
import UIKit
@objc protocol DataGathererDelegate {
    @objc optional func didGatherBusRoutes(onCampusRoutes: [BusRoute], offCampusRoutes: [BusRoute])
    @objc optional func didGatherBusPattern(points: [BusPattern])
}
class DataGatherer {
    private let baseUrl = "https://transport.tamu.edu/BusRoutesFeed/api/"
    public var delegate: DataGathererDelegate?
    init(){}
    func gatherData(endpoint: String){
        let url = URL(string: baseUrl+endpoint)
        if let url = url{
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("An error has occured")
                    print(error.localizedDescription)
                }
                else {
                    guard let data = data else {
                        fatalError("An error has occured")
                    }
                    do {
                        let decoder = JSONDecoder()
                        if endpoint == "Routes" {
                            let routes = try decoder.decode([RouteData].self, from: data)
                            let onCampusRoutes = self.gatherOnCampusBusRoutes(data: routes)
                            let offCampusRoutes = self.gatherOffCampusBusRoutes(data: routes)
                            if let delegate = self.delegate {
                                if let gather = delegate.didGatherBusRoutes {
                                    gather(onCampusRoutes, offCampusRoutes)
                                }
                                    
                            }
                        }
                        else if endpoint.split(separator: "/").last == "pattern" {
                            let stops = try decoder.decode([PatternData].self, from: data)
                            let busStops = self.gatherBusStops(data: stops)
                            if let delegate = self.delegate {
                                if let gather = delegate.didGatherBusPattern {
                                    gather(busStops)
                                }
                            }
                        }
                    } catch {
                        print("An error has occured: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    private func gatherOnCampusBusRoutes(data: [RouteData]) -> [BusRoute] {
        var routes: [BusRoute] = []
        for route in data {
            if route.Group.Name == "On Campus" {
                let busRoute = BusRoute(name: route.Name, number: route.ShortName, color: UIColor.colorFromRGBString(string: route.Color), campus: route.Group.Name)
                routes.append(busRoute)
            }
        }
        return routes
    }
    private func gatherOffCampusBusRoutes(data: [RouteData]) -> [BusRoute] {
        var routes: [BusRoute] = []
        for route in data {
            if route.Group.Name == "Off Campus" {
                let busRoute = BusRoute(name: route.Name, number: route.ShortName, color: UIColor.colorFromRGBString(string: route.Color), campus: route.Group.Name)
                routes.append(busRoute)
            }
        }
        return routes
    }
    private func gatherBusStops(data: [PatternData]) -> [BusPattern] {
        var stops: [BusPattern] = []
        for stop in data {
            let coordinates = CoordinateConverter(latitude: stop.Latitude, longitude: stop.Longtitude)
            let busStop = BusPattern(name: stop.Name, latitude: coordinates.0, longitude: coordinates.1)
            stops.append(busStop)
        }
        return stops
    }
}




