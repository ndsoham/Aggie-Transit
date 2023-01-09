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
}
protocol BusRouteDataGathererDelegate {
    func didGatherBusPattern(points: [BusPattern])
    func didGatherBusStops(stops: [BusStop])
    func didGatherBuses(buses: [Bus])
    func didGatherTimeTable(table: [[String:Date?]])
}

class DataGatherer {
    private let baseUrl = "https://transport.tamu.edu/BusRoutesFeed/api/"
    private let dateFormatter = DateFormatter()
    public var delegate: DataGathererDelegate?
    public var busRouteDelegate: BusRouteDataGathererDelegate?
    init(){
        configureDateFormatter()
    }
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
                            if let busRouteDelegate = self.busRouteDelegate {
                                busRouteDelegate.didGatherBusPattern(points: busPoints)
                            }
                        }
                        else if endpoint.split(separator: "/").last == "stops" {
                            let stops = try decoder.decode([StopData].self, from: data)
                            let busStops = self.gatherBusStops(data: stops)
                            if let busRouteDelegate = self.busRouteDelegate {
                                busRouteDelegate.didGatherBusStops(stops: busStops)
                            }
                        }
                        else if endpoint.split(separator: "/").last == "buses" {
                            let busData = try decoder.decode([BusData].self, from: data)
                            let buses = self.gatherBuses(data: busData)
                            if let busRouteDelegate = self.busRouteDelegate {
                                busRouteDelegate.didGatherBuses(buses: buses)
                            }
                        }
                        else {//if endpoint.split(separator: "/").last == "TimeTable" {
                            
                            let timeData = try decoder.decode([[String:String?]].self, from: data)
                            let timeTable = self.gatherTime(data: timeData)
                            if let busRouteDelegate = self.busRouteDelegate {
                                busRouteDelegate.didGatherTimeTable(table: timeTable)
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
//MARK: - use this to convert from decoded bus data to time data
    private func gatherTime(data: [[String:String?]]) -> [[String:Date?]] {
        var timeTable: [[String:Date?]] = []
        for row in data {
            var rowCopy: [String: Date?] = [:]
            for (key, value) in row {
                if let value = value, let date = dateFormatter.date(from: value) {
                    rowCopy[key] = date
                } else {
                    rowCopy[key] = nil
                }
            }
            timeTable.append(rowCopy)
        }
        return timeTable
    }
//MARK: - use this to format the date formatter
    // use this to format the date formatter
    func configureDateFormatter() {
        dateFormatter.timeZone = TimeZone(abbreviation: "CST")
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm a")
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.defaultDate = NSDate.now
    }
}


