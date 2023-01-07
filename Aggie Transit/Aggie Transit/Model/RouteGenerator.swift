//
//  RouteGenerator.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/6/23.
//

import Foundation
import MapKit

class RouteGenerator {
    static let shared = RouteGenerator()
    private let dataGatherer = DataGatherer()
    var allRoutes: [BusRoute]? {
        didSet {
            if let allRoutes = allRoutes {
                for route in allRoutes {
                    dataGatherer.gatherData(endpoint: "route/\(route.number)/stops")
                }
            }
        }
    }
    private var allStops: [BusStop] = []
    private init() {
        dataGatherer.delegate = self
//        dataGatherer.gatherData(endpoint: "Routes")
       
    }
//MARK: - Find the closest bus stops along two routes
    func findClosestBusStop(inRoute: BusRoute, outRoute: BusRoute) -> (BusStop?, BusStop?){
        var distance = Double.greatestFiniteMagnitude
        var closestStops: (BusStop?, BusStop?)
        if let inRouteStops = inRoute.stops, let outRouteStops = outRoute.stops {
            for inStop in inRouteStops {
                for outStop in outRouteStops {
                    if outStop.location.distance(to: inStop.location) < distance {
                        closestStops = (inStop, outStop)
                        distance = outStop.location.distance(to: inStop.location)
                    }
                }
            }
        }
        return closestStops
    }
//MARK: - Find closest bus stop along a bus route to a user
    func findClosestBusStops(route: BusRoute) -> BusStop? {
        var distance = Double.greatestFiniteMagnitude
        var closestStop: BusStop? = nil
        // simulate user location for now
        let userLocation = CLLocationCoordinate2D(latitude: 30.62138417079569, longitude: -96.34249946007645)
            if let stops = route.stops{
                for stop in stops {
                    if stop.location.distance(to: userLocation) < distance {
                        closestStop = stop
                        distance = stop.location.distance(to: userLocation)
                    }
                }
            }
        return closestStop
    }
//MARK: - Find closest bus stop from a location
    func findClosestBusStops(location: Location) -> BusStop?{
        // use distance formula to find closest bus stops
        var distance = Double.greatestFiniteMagnitude
        var closestStop:BusStop? = nil
        if allStops.count > 0 {
            for stop in allStops {
                if location.location.distance(to: stop.location) < distance {
                    closestStop = stop
                    distance = location.location.distance(to: stop.location)
                }
            }
        }
        // return closest stop
        return closestStop
    }
    //MARK: - Find relevant routes
    func findRelevantBusRoutes(stop: BusStop) -> [BusRoute]? {
        var relevantBusRoutes: [BusRoute] = []
        if let allRoutes = allRoutes {
            for route in allRoutes {
                if let stops = route.stops {
                    for routeStop in stops {
                        if routeStop.location.latitude == stop.location.latitude && routeStop.location.longitude == stop.location.longitude && !relevantBusRoutes.contains(route){
                            relevantBusRoutes.append(route)
                        }
                    }
                }
            }
        }
        return relevantBusRoutes
    }
}

//MARK: - find routes that utilize said bus stop

// deal with delegate here
extension RouteGenerator: DataGathererDelegate {
    func didGatherBusStops(stops: [BusStop]) {
        allStops.append(contentsOf: stops)
    }
}


