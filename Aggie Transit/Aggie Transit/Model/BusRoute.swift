//
//  BusRoute.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/20/22.
//

import Foundation
import UIKit
import MapKit
class BusRoute: NSObject {
    var name: String
    var number: String
    var color: UIColor
    var campus: String
    var delegate: PathMakerDelegate?
    var stops: [BusStop]? 
    var pattern: [BusPattern]?
    var buses: [Bus]?
    var isFavorited: Bool?
    var timeTable: [[String:Date?]]? {
        didSet {
            if let timeTable = timeTable {
                let middleRow = timeTable[timeTable.count/2]
                    if let maxTime = middleRow.values.max(by: {
                        if let first = $0, let second = $1 {
                            return first < second
                        } else {
                            return false
                        }
                    }) as? Date,
                    let minTime = middleRow.values.min(by: {
                        if let first = $0, let second = $1 {
                            return first < second
                        } else {
                            return false
                        }
                    }) as? Date {
                        let difference = maxTime.timeIntervalSince(minTime)
                        self.routeTime = difference + 300
                    }
            }
        }
    }
    var currentlyRunning: Bool?
    var startTime: Date?
    var stopTime: Date?
    var routeTime: Double?
    private var busUpdateTimer: Timer?
    private var busDisplayTimer: Timer?
    private let dataGatherer = DataGatherer()
    init(name: String, number: String, color: UIColor, campus: String){
        self.name = name
        self.number = number
        self.color = color
        self.campus = campus
        super.init()
        registerTimerInvalidationNotification()
        // gather everything except for buses when first initialized to avoid showing the buses on the map
        gatherPattern()
        gatherStops()
        gatherTimeTable()
        gatherBuses()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // this gathers pattern data
    func gatherPattern() {
        let endpoint = "route/\(number)/pattern"
        dataGatherer.busRouteDelegate = self
        dataGatherer.gatherData(endpoint: endpoint)
    }
    // this gathers stop data
    func gatherStops() {
        let endpoint = "route/\(number)/stops"
        dataGatherer.busRouteDelegate = self
        dataGatherer.gatherData(endpoint: endpoint)
    }
    // this gathers time data
    func gatherTimeTable(){
        let endpoint = "route/\(number)/timetable"
        dataGatherer.busRouteDelegate = self
        dataGatherer.gatherData(endpoint: endpoint)
    }
    // this gathers bus data
    func gatherBuses(){
        DispatchQueue.main.async{
            let endpoint = "route/\(self.number)/buses"
            self.dataGatherer.busRouteDelegate = self
            self.dataGatherer.gatherData(endpoint: endpoint)
            self.busUpdateTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { timer in
                if let currentlyRunning = self.currentlyRunning {
                    if !currentlyRunning {
                        timer.invalidate()
                    }
                }
                let endpoint = "route/\(self.number)/buses"
                self.dataGatherer.busRouteDelegate = self
                self.dataGatherer.gatherData(endpoint: endpoint)
            })
        }
    }
    // use this to display the route on the map
    func displayBusRoute() {
        if let delegate = delegate, let stops = stops, let pattern = pattern {
            delegate.displayBusRouteOnMap(color: self.color, points: pattern, stops: stops, route: self)
        }
    }
    // use this to display a partial bus route
    func displayPartialRoute(startStop: BusStop, endStop: BusStop) {
        if let delegate = delegate, var pattern = pattern {
            if let startIndex = pattern.firstIndex(where: {$0.key==startStop.key}) {
                pattern.rotateLeft(positions: startIndex)
                if let stopIndex = pattern.firstIndex(where: { $0.key == endStop.key}){
                    delegate.displayPartialRouteOnMap(color: self.color, points: Array(pattern[0...stopIndex]), startStop: startStop, endStop: endStop)
                }
            }
        }
    }
    // use this to display the buses on the map
    func displayBuses(){
        if let delegate = self.delegate, let buses = self.buses {
            delegate.displayBusesOnMap(buses: buses)
        }
        self.busDisplayTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { timer in
            if let delegate = self.delegate, let buses = self.buses {
                if let currentlyRunning = self.currentlyRunning {
                    if !currentlyRunning {
                        timer.invalidate()
                    }
                }
                delegate.displayBusesOnMap(buses: buses)
            }
        })
    }
    // use this to invalidate the timer
    @objc func invalidateTimer(){
        if let timer = busDisplayTimer {
            timer.invalidate()
        }
    }
    // use this to register the relevant notification
    func registerTimerInvalidationNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTimer), name: Notification.Name("invalidateTimer"), object: nil)
    }
 
    
  
}

extension BusRoute: BusRouteDataGathererDelegate {
    func didGatherBusPattern(points: [BusPattern]) {
        self.pattern = points
    }
    func didGatherBusStops(stops: [BusStop]) {
        self.stops = stops
    }
    func didGatherBuses(buses: [Bus]) {
        self.buses = buses
    }
    func didGatherTimeTable(table: [[String : Date?]]) {
        self.timeTable = table
        if let timeTable = self.timeTable {
            if let firstRow = timeTable.first {
                if firstRow.isEmpty {
                    self.startTime = nil
                    self.stopTime = nil
                    self.currentlyRunning = false
                } else {
                    for row in timeTable {
                        if row == timeTable.first {
                             if let startTime = row.values.min(by: {
                                if let first = $0, let second = $1 {
                                    return first < second
                                } else {
                                    return false
                                }
                             }) {
                                 self.startTime = startTime
                             } else {
                                 self.startTime = nil
                             }
                        }
                        if row == timeTable.last {
                            if let stopTime = row.values.max(by: {
                                if let first = $0, let second = $1 {
                                    return first < second
                                } else {
                                    return false
                                }
                            }) {
                                self.stopTime = stopTime
                            } else {
                                self.stopTime = nil
                            }
                        }
                    }
                    if let startTime = self.startTime, let stopTime = self.stopTime {
                        let now = NSDate.now
                        let formatter = DateFormatter()
                        formatter.setLocalizedDateFormatFromTemplate("hh:mm a")
                        if startTime < now && stopTime > now {
                            self.currentlyRunning = true
                        } else {
                            self.currentlyRunning = false
                        }
                    }
                }
            }
        }
    }
}



