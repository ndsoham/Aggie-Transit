//
//  DataParser.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/18/22.
//

import Foundation
import UIKit
import MapKit
@objc protocol DataGathererDelegate {
    @objc optional func didGatherBusRoutes(onCampusRoutes: [BusRoute], offCampusRoutes: [BusRoute])
    @objc optional func didGatherBusPattern(points: [BusPattern])
    @objc optional func didGatherBusStops(stops: [BusStop])
    @objc optional func didGatherBuses(buses: [Bus])
    @objc optional func didUpdateBuses(buses: [Bus])
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
                            let points = try decoder.decode([PatternData].self, from: data)
                            let busPoints = self.gatherBusPattern(data: points)
                            if let delegate = self.delegate {
                                if let gather = delegate.didGatherBusPattern {
                                    gather(busPoints)
                                }
                            }
                        }
                        else if endpoint.split(separator: "/").last == "stops" {
                            let stops = try decoder.decode([StopData].self, from: data)
                            let busStops = self.gatherBusStops(data: stops)
                            if let delegate = self.delegate {
                                if let gather = delegate.didGatherBusStops {
                                    gather(busStops)
                                }
                            }
                        }
                        else if endpoint.split(separator: "/").last == "buses" {
                            let busData = try decoder.decode([BusData].self, from: data)
                            let buses = self.gatherBuses(data: busData)
                            if let delegate = self.delegate {
                                if let gather = delegate.didGatherBuses {
                                    gather(buses)
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
    func updateBuses(endpoint: String) {
        let url = URL(string: baseUrl+endpoint)
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("An error has occured \(error)")
                } else {
                    do{
                        guard let data = data else {return}
                        let decoder = JSONDecoder()
                        let busData = try decoder.decode([BusData].self, from: data)
                        let buses = self.gatherBuses(data: busData)
                        if let delegate = self.delegate {
                            if let update = delegate.didUpdateBuses {
                                update(buses)
                            }
                        }
                    } catch {
                        print("An error has occured \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    //MARK: - Use this to convert from decoded route data to bus routes
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
//MARK: - use this to convert from decoded pattern data to bus pattern
    private func gatherBusPattern(data: [PatternData]) -> [BusPattern] {
        var points: [BusPattern] = []
        for point in data {
            let coordinates = CoordinateConverter(latitude: point.Latitude, longitude: point.Longtitude)
            let busPoint = BusPattern(name: point.Name, location: CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1))
            points.append(busPoint)
        }
        return points
    }
//MARK: - use this to convert from decoded stop data to bus stop
    private func gatherBusStops(data: [StopData]) -> [BusStop] {
        var stops: [BusStop] = []
        for stop in data {
            let coordinates = CoordinateConverter(latitude: stop.Latitude, longitude: stop.Longtitude)
            let busStop = BusStop(name: stop.Name, location: CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1), isTimePoint: stop.Stop.IsTimePoint)
            stops.append(busStop)
        }
        return stops
    }
//MARK: - use this to convert from decoded bus data to bus
    private func gatherBuses(data: [BusData]) -> [Bus] {
        var buses: [Bus] = []
        for bus in data {
            if let latitude = Double(bus.lat), let longitude = Double(bus.lng), let direction = CLLocationDirection(bus.direction) {
                let coordinates = CoordinateConverter(latitude: latitude, longitude: longitude)
                let routeBus = Bus(location: CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1), direction: direction,name: bus.route, nextStop: bus.nextStop)
                buses.append(routeBus)
            }
            
        }
        return buses
    }
}

