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
    var buses: [Bus]? {
        didSet {
            if let currentlyRunning, !currentlyRunning, let buses {
                if buses.count > 0 {
                    self.currentlyRunning = true
                    gatherBuses()
                }
            }
        }
    }
    var isFavorited: Bool?
    var timeTable: [[String:Date?]]? {
        // when the time table is set, the data obtained is used to calculate the route time property
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
        gatherPattern()
        gatherStops()
        gatherTimeTable()
        gatherBuses()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)}
//MARK: - this gathers pattern data
    func gatherPattern() {
        let endpoint = "route/\(number)/pattern"
        dataGatherer.busRouteDelegate = self
        dataGatherer.gatherData(endpoint: endpoint)
    }
//MARK: - this gathers stop data
    func gatherStops() {
        let endpoint = "route/\(number)/stops"
        dataGatherer.busRouteDelegate = self
        dataGatherer.gatherData(endpoint: endpoint)
    }
//MARK: - this gathers time data
    func gatherTimeTable(){
        let endpoint = "route/\(number)/timetable"
        dataGatherer.busRouteDelegate = self
        dataGatherer.gatherData(endpoint: endpoint)
    }
//MARK: this gathers bus data
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
//MARK: - use this to display the route on the map
    func displayBusRoute() {
        if let delegate, let stops, let pattern, let buses {
            delegate.displayBusRouteOnMap(color: self.color, points: pattern, stops: stops, route: self)
            delegate.displayBusesOnMap(buses: buses)
            self.busDisplayTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { timer in
                if let delegate = self.delegate, let buses = self.buses {
                    delegate.displayBusesOnMap(buses: buses)
                }
            })
        }
    }
//MARK: -  use this to display a partial bus route
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
//MARK: - This is the function called when the invalidate timer notification is received
    @objc func invalidateTimer(){
        if let timer = busDisplayTimer {
            timer.invalidate()
        }
    }
    //MARK: - This is used to invalidate the timer when the home screen menu is collapsed
    func registerTimerInvalidationNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTimer), name: Notification.Name("invalidateTimer"), object: nil)
    }
}
extension BusRoute: BusRouteDataGathererDelegate {
    //MARK: - The data obtained from this is used to draw the bus's representation on the map
    func didGatherBusPattern(points: [BusPattern]) {
        self.pattern = points
    }
    //MARK: - This sets each bus routes bus stops
    func didGatherBusStops(stops: [BusStop]) {
        self.stops = stops
    }
    //MARK: - This is used to set each routes current buses and is updated frequently
    func didGatherBuses(buses: [Bus]) {
        self.buses = buses
    }
    //MARK: - This is used to set each routes time table, start time, and stop time
    func didGatherTimeTable(table: [[String : Date?]]) {
        self.timeTable = table
        if let timeTable = self.timeTable {
            if let firstRow = timeTable.first {
                if firstRow[" "] == nil as Date? {
                    self.startTime = nil
                    self.stopTime = nil
                    self.currentlyRunning = false
                } else {
                    for row in timeTable {
                        if row == timeTable.first {
                            if let startTime = row.values.compactMap({$0}).min(by: { $0 < $1 }) {
                                self.startTime = startTime
                            } else {
                                self.startTime = nil as Date?
                            }
                        }
                        if row == timeTable.last {
                            if let stopTime = row.values.compactMap({$0}).max(by: {$0 < $1}) {
                                self.stopTime = stopTime
                            } else {
                                self.stopTime = nil as Date?
                            }
                        }
                    }
                    if let startTime = self.startTime, let stopTime = self.stopTime {
                        let now = NSDate.now
                        if startTime < now && stopTime > now {
                            self.currentlyRunning = true
                        }
                        else if let buses, buses.count > 0 {
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



