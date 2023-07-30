//
//  DataParser.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/18/22.
//

import Foundation
import UIKit
import MapKit
class DataGatherer {
    private let baseUrl = "https://transport.tamu.edu/BusRoutesFeed/api/"
    private let dateFormatter = DateFormatter()
    var delegate: DataGathererDelegate?
    var busRouteDelegate: BusRouteDataGathererDelegate?
    var alertDelegate: AlertDelegate?
    init(){configureDateFormatter()}
    let decoder: JSONDecoder = JSONDecoder()
    //MARK: - This function gathers all the bus routes
    func gatherBusRoutes(completion: @escaping ([BusRoute]) -> Void) {
        let endpoint = "routes"
        if let url = URL(string: baseUrl+endpoint) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error {
                    let alert = UIAlertController(title: "Alert", message: "\(error.localizedDescription)", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.alertDelegate?.displayAlert(alert: alert)
                } else if let data {
                    do {
                        let routes = try self.decoder.decode([RouteData].self, from: data)
                        let busRoutes = self.gatherBusRoutes(data: routes)
                        for route in busRoutes {
                            self.gatherStops(routeNumber: route.number) { busStops in
                                route.stops = busStops
                                if route == busRoutes.last {
                                    completion(busRoutes)
                                }
                            }
                        }
                    } catch {
                        let alert = UIAlertController(title: "Alert", message: "\(error.localizedDescription)", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self.alertDelegate?.displayAlert(alert: alert)
                    }
                }
            }
            task.resume()
        }
    }
    //MARK: - This function gathers the stops for a single bus route
    func gatherStops(routeNumber: String, completion: @escaping ([BusStop]) -> Void) {
        let endpoint = "/stops"
        if let url = URL(string: baseUrl+"route/"+routeNumber+endpoint) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error {
                    let alert = UIAlertController(title: "Alert", message: "\(error.localizedDescription)", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.alertDelegate?.displayAlert(alert: alert)
                } else if let data {
                    do {
                        let stops = try self.decoder.decode([StopData].self, from: data)
                        let busStops = self.gatherBusStops(data: stops)
                        
                        completion(busStops)
                    } catch {
                        let alert = UIAlertController(title: "Alert", message: "\(error.localizedDescription)", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self.alertDelegate?.displayAlert(alert: alert)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    //    func gatherData(endpoint: String){
    //        let url = URL(string: baseUrl+endpoint)
    //        if let url = url{
    //            let task = URLSession.shared.dataTask(with: url) { data, response, error in
    //                else if let data {
    //                    do {
    //                        let decoder = JSONDecoder()
    //                        if endpoint == "routes" {
    //                            let routes = try decoder.decode([RouteData].self, from: data)
    //                            let busRoutes = self.gatherBusRoutes(data: routes)
    //                            if let delegate = self.delegate {
    //                                if let gather = delegate.didGatherBusRoutes {
    //                                    gather(busRoutes)
    //                                }
    //                            }
    //                        }
    //                        else if endpoint.split(separator: "/").last == "pattern" {
    //                            let points = try decoder.decode([PatternData].self, from: data)
    //                            let busPoints = self.gatherBusPattern(data: points)
    //                            if let busRouteDelegate = self.busRouteDelegate {
    //                                busRouteDelegate.didGatherBusPattern(points: busPoints)
    //                            }
    //                        }
    //                        else if endpoint.split(separator: "/").last == "stops" {
    //                            let stops = try decoder.decode([StopData].self, from: data)
    //                            let busStops = self.gatherBusStops(data: stops)
    //                            if let busRouteDelegate = self.busRouteDelegate {
    //                                busRouteDelegate.didGatherBusStops(stops: busStops)
    //                            }
    //                        }
    //                        else if endpoint.split(separator: "/").last == "buses" {
    //                            let busData = try decoder.decode([BusData].self, from: data)
    //                            let buses = self.gatherBuses(data: busData)
    //                            if let busRouteDelegate = self.busRouteDelegate {
    //                                busRouteDelegate.didGatherBuses(buses: buses)
    //                            }
    //                        }
    //                        else if endpoint.split(separator: "/").last == "announcements" {
    //                            let busNotifications = try decoder.decode(AnnouncementData.self, from: data)
    //                            let notifications = self.gatherNotifications(data: busNotifications.Items)
    //                            if let delegate = self.delegate {
    //                                if let gather = delegate.didGatherNotifications {
    //                                    gather(notifications)
    //                                }
    //                            }
    //                        }
    //                        else if endpoint.split(separator: "/").last == "timetable" {
    //                            let timeData = try decoder.decode([[String:String?]].self, from: data)
    //                            let timeTable = self.gatherTime(data: timeData)
    //                            if let busRouteDelegate = self.busRouteDelegate {
    //                                busRouteDelegate.didGatherTimeTable(table: timeTable)
    //                            }
    //                        }
    //                    } catch {
    
    //                    }
    //                } else {
    //                    let alert = UIAlertController(title: "Alert", message: "An error has occured.", preferredStyle: .actionSheet)
    //                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
    //                    self.alertDelegate?.displayAlert(alert: alert)
    //                }
    //            }
    //            task.resume()
    //        }
    //    }
    //MARK: - Use this to convert from decoded route data to bus routes
    private func gatherBusRoutes(data: [RouteData]) -> [BusRoute] {
        var routes: [BusRoute] = []
        for route in data {
            let busRoute = BusRoute(name: route.Name, number: route.ShortName, color: UIColor.colorFromRGBString(string: route.Color), campus: route.Group.Name)
            routes.append(busRoute)
        }
        return routes
    }
    
    //MARK: - Use this to convert from decoded pattern data to bus pattern
    private func gatherBusPattern(data: [PatternData]) -> [BusPattern] {
        var points: [BusPattern] = []
        for point in data {
            let coordinates = CoordinateConverter(latitude: point.Latitude, longitude: point.Longtitude)
            let busPoint = BusPattern(name: point.Name, location: CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1),id: point.Key)
            points.append(busPoint)
        }
        return points
    }
    //MARK: - Use this to convert from decoded stop data to bus stop
    private func gatherBusStops(data: [StopData]) -> [BusStop] {
        var stops: [BusStop] = []
        for stop in data {
            let coordinates = CoordinateConverter(latitude: stop.Latitude, longitude: stop.Longtitude)
            let busStop = BusStop(name: stop.Name, location: CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1), isTimePoint: stop.Stop.IsTimePoint, key: stop.Key)
            stops.append(busStop)
        }
        return stops
    }
    //MARK: - Use this to convert from decoded bus data to bus
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
    //MARK: - Use this to convert from decoded bus data to time data
    private func gatherTime(data: [[String:String?]]) -> [[String:Date?]] {
        var timeTable: [[String:Date?]] = []
        for row in data {
            var rowCopy: [String: Date?] = [:]
            for (key, value) in row {
                if let value = value, var date = dateFormatter.date(from: value) {
                    let nowComponents = Calendar.current.dateComponents([.day, .hour, .minute, .year, .month], from: NSDate.now)
                    let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
                    if let nowHour = nowComponents.hour, let nowDay = nowComponents.day, let nowYear = nowComponents.year, let nowMonth = nowComponents.month,let dateHour = dateComponents.hour {
                        if nowHour == 0 && dateHour == 0{
                            dateFormatter.defaultDate = NSDate.now
                            date = dateFormatter.date(from: value) ?? date
                        } else if dateHour == 0 {
                            let increasedDay = Calendar.current.date(bySetting: .day, value: nowDay+1, of: date)
                            let currentYear = Calendar.current.date(bySetting: .year, value: nowYear, of: increasedDay ?? date)
                            dateFormatter.defaultDate = Calendar.current.date(bySetting: .month, value: nowMonth, of: currentYear ?? date)
                            date = dateFormatter.date(from: value) ?? date
                        } else if nowHour == 0 {
                            let decreasedDay = Calendar.current.date(bySetting: .day, value: nowDay-1, of: date)
                            let currentYear = Calendar.current.date(bySetting: .year, value: nowYear, of: decreasedDay ?? date)
                            dateFormatter.defaultDate = Calendar.current.date(bySetting: .month, value: nowMonth, of: currentYear ?? date)
                            date = dateFormatter.date(from: value) ?? date
                        }
                        else {
                            dateFormatter.defaultDate = NSDate.now
                            date = dateFormatter.date(from: value) ?? date
                        }
                    }
                    rowCopy[key] = date
                } else {
                    rowCopy[key] = nil as Date?
                }
            }
            timeTable.append(rowCopy)
        }
        return timeTable
    }
    //MARK: - Use this to convert from decoded data to bus notifications
    private func gatherNotifications(data: [AnnouncementStruct]) -> [BusNotification]{
        var notifications:[BusNotification] = []
        for notification in data {
            guard let content = notification.Summary.Text.split(separator: ";").last?.trimmingCharacters(in: .whitespaces) else {return []}
            notifications.append(BusNotification(content: String(content), title: notification.Title.Text))
        }
        return notifications
    }
    //MARK: - use this to format the date formatter
    // use this to format the date formatter
    func configureDateFormatter() {
        dateFormatter.timeZone = TimeZone(abbreviation: "CST")
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm a")
        dateFormatter.locale = Locale(identifier: "en_US")
    }
}


