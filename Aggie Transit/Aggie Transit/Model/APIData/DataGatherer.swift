//
//  DataParser.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/18/22.
//

import Foundation
import UIKit
protocol DataGathererDelegate {
    func didGatherBusRoutes(onCampusRoutes: [BusRoute], offCampusRoutes: [BusRoute])
    func didGatherBusPattern(points: [BusPattern])
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
                            self.delegate?.didGatherBusRoutes(onCampusRoutes: onCampusRoutes, offCampusRoutes: offCampusRoutes)
                        }
                        else if endpoint.split(separator: "/").last == "pattern" {
                            let stops = try decoder.decode([PatternData].self, from: data)
                            let busStops = self.gatherBusStops(data: stops)
                            self.delegate?.didGatherBusPattern(points: busStops)
                        }
                    } catch {
                        print("An error has occured: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    func gatherOnCampusBusRoutes(data: [RouteData]) -> [BusRoute] {
        var routes: [BusRoute] = []
        for route in data {
            if route.Group.Name == "On Campus" {
                let busRoute = BusRoute(name: route.Name, number: route.ShortName, color: UIColor.colorFromRGBString(string: route.Color), campus: route.Group.Name)
                routes.append(busRoute)
            }
        }
        return routes
    }
    func gatherOffCampusBusRoutes(data: [RouteData]) -> [BusRoute] {
        var routes: [BusRoute] = []
        for route in data {
            if route.Group.Name == "Off Campus" {
                let busRoute = BusRoute(name: route.Name, number: route.ShortName, color: UIColor.colorFromRGBString(string: route.Color), campus: route.Group.Name)
                routes.append(busRoute)
            }
        }
        return routes
    }
    func gatherBusStops(data: [PatternData]) -> [BusPattern] {
        var stops: [BusPattern] = []
        for stop in data {
            let busStop = BusPattern(name: stop.Name, latitude: stop.Latitude, longitude: stop.Longtitude)
            stops.append(busStop)
        }
        return stops
    }
}




