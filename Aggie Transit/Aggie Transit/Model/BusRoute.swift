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
    func displayBusesOnMap(buses:[Bus])
    func displayBusRouteOnMap(color: UIColor, points: [BusPattern], stops: [BusStop])
}
class BusRoute: NSObject {
    var name: String
    var number: String
    var color: UIColor
    var campus: String
    var delegate: PathMakerDelegate?
    var stops: [BusStop]?
    var pattern: [BusPattern]?
    var buses: [Bus]?
    private var timer: Timer?
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
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // this gathers pattern data
    func gatherPattern() {
        let endpoint = "route/\(number)/pattern"
        dataGatherer.delegate = self
        dataGatherer.gatherData(endpoint: endpoint)
    }
    // this gathers stop data
    func gatherStops() {
        let endpoint = "route/\(number)/stops"
        dataGatherer.delegate = self
        dataGatherer.gatherData(endpoint: endpoint)
    }
    // this gathers bus data
    func gatherBuses(){
        DispatchQueue.main.async{
            let endpoint = "route/\(self.number)/buses"
            self.dataGatherer.delegate = self
            self.dataGatherer.gatherData(endpoint: endpoint)
            self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { timer in
                let endpoint = "route/\(self.number)/buses"
                self.dataGatherer.delegate = self
                self.dataGatherer.gatherData(endpoint: endpoint)
            })
        }
    }
    // use this to display the route on the map
    func displayBusRoute() {
        if let delegate = delegate, let stops = stops, let pattern = pattern {
            delegate.displayBusRouteOnMap(color: self.color, points: pattern, stops: stops)
        }
    }
    // use this to display the buses on the map
    func displayBuses(){
        gatherBuses()
    }
    // use this to invalidate the timer
    @objc func invalidateTimer(){
        if let timer = timer {
            timer.invalidate()
        }
    }
    // use this to register the relevant notification
    func registerTimerInvalidationNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTimer), name: Notification.Name("invalidateTimer"), object: nil)
    }
  
}

extension BusRoute: DataGathererDelegate {
    func didGatherBusPattern(points: [BusPattern]) {
        self.pattern = points
    }
    func didGatherBusStops(stops: [BusStop]) {
        self.stops = stops
    }
    func didGatherBuses(buses: [Bus]) {
        self.buses = buses
        if let delegate = delegate, let buses = self.buses {
            delegate.displayBusesOnMap(buses: buses)
        }
    }
}



