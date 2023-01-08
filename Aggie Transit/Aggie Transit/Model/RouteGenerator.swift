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
    var allRoutes: [BusRoute]?
    var allStops: [BusStop] = []
    private init() {}
//MARK: - Find the closest bus stops along two routes
    func findClosestBusStops(inRoute: BusRoute, outRoute: BusRoute) -> (BusStop?, BusStop?){
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
    func findClosestBusStops(route: BusRoute, userLocation: CLLocationCoordinate2D) -> BusStop? {
        var distance = Double.greatestFiniteMagnitude
        var closestStop: BusStop? = nil
        // simulate user location for now
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
    func findClosestBusStops(location: Location) -> [BusStop]?{
        // use distance formula to find closest bus stops
        var closestStops:[BusStop]? = nil
        if allStops.count > 0 {
            closestStops = Array(allStops.sorted(by: {
                return $0.location.distance(to: location.location) < $1.location.distance(to: location.location)
            }) [...2])
        }
        // return closest stop
        return closestStops
    }
//MARK: - Use this to find the relevant route and closest bus stop in one go
    func findRelevantBusRoutesAndClosestStops(location: Location) -> [(BusRoute,BusStop)] {
        var routesAndStops: [(BusRoute,BusStop)] = []

        // filter all routes by time constraints
        if let allRoutes = allRoutes {
            let filteredRoutes = allRoutes
            if filteredRoutes.isEmpty {
                return routesAndStops
            }
            for route in filteredRoutes {
                    let closestStop = route.stops?.sorted(by: {
                        return $0.location.distance(to: location.location) < $1.location.distance(to: location.location)
                    }).first
                    if let closestStop = closestStop {
                        routesAndStops.append((route,closestStop))
                    }
                }
            // change this to a distance buffer
            routesAndStops = routesAndStops.sorted(by: {
                $0.1.location.distance(to: location.location) < $1.1.location.distance(to: location.location)
            })
            routesAndStops = routesAndStops.filter({
                $0.1.location.distance(to: location.location) <= 645
            })
            return Array(routesAndStops)
        }
        return routesAndStops
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
        // filter the bus routes by time constraints
        for route in relevantBusRoutes {
            if let currentlyRunning = route.currentlyRunning {
                if !currentlyRunning {
                    if let index = relevantBusRoutes.firstIndex(of: route){
                        relevantBusRoutes.remove(at: index)
                    }
                }
            }
        }
        return relevantBusRoutes
    }
}



