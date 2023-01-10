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
    private init() {}
//MARK: - Find the closest bus stops along two routes
    func findClosestBusStops(inRoute: BusRoute, outRoute: BusRoute) -> (BusStop, BusStop){
        var distance = Double.greatestFiniteMagnitude
        var closestStops: (BusStop, BusStop) = (BusStop(name: "empty", location: CLLocationCoordinate2D(), isTimePoint: false),BusStop(name: "empty", location: CLLocationCoordinate2D(), isTimePoint: false))
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
//MARK: - Use this to find the closest stops on the possible paths
    func findClosestBusStops(destination: Location, destinationRoutesAndStops: [(BusRoute,BusStop)], userRoutesAndStops: [(BusRoute, BusStop)], userLocation: Location, completion: @escaping ((Location, [(BusRoute, BusStop)], Location, Double))->()) {
        var minTravelTime: Double = Double.greatestFiniteMagnitude
        var route: (Location, [(BusRoute, BusStop)], Location, Double)? = nil
        // arrays have been filterd at this point so all there is to find is the fastest route to the destination
        for (userRoute, userStop) in userRoutesAndStops {
            var travelTime: Double = 0
            var originWalkTime: Double = 0
            
            // first calculate the time it will take for the user to walk to the origin bus stop
            let userStopMapItem = MKMapItem(placemark:MKPlacemark(coordinate: userStop.location))
            let userLocationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.location))
            findWalkingETA(source: userStopMapItem, destination: userLocationMapItem) {
                originWalkTime = $0

                // next calculate the time it will take for the user to ride the bus to the next bus stop he/she gets off at
                for (desRoute, desStop) in destinationRoutesAndStops {
                    if userRoute != desRoute {
                        var firstRideTime: Double = 0
                        var layoverTime: Double = 0
                        var secondRideTime: Double = 0
                        var destinationWalkTime: Double = 0
                        let (inStop, outStop) = self.findClosestBusStops(inRoute: userRoute, outRoute: desRoute)
                        // no point on getting on and off a bus instantly
                       
                        firstRideTime = outStop == desStop ? 1000:self.findRideETA(origin: userStop, destination: inStop, route: userRoute)
                        // calculate the time it will take for the user to walk between the two bus stops
                        let firstStop = MKMapItem(placemark: MKPlacemark(coordinate: inStop.location))
                        let secondStop = MKMapItem(placemark: MKPlacemark(coordinate: outStop.location))
                        self.findWalkingETA(source: firstStop, destination: secondStop) {
                            layoverTime = $0
                            
                            secondRideTime = self.findRideETA(origin: outStop, destination: desStop, route: desRoute)
                            // finally find the time it will take for the user to walk from the desintation bus stop to the location
                            let destinationStopMapItem = MKMapItem(placemark: MKPlacemark(coordinate: desStop.location))
                            let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination.location))
                            self.findWalkingETA(source: destinationStopMapItem, destination: destinationMapItem) {
                                destinationWalkTime = $0
                                travelTime = originWalkTime + firstRideTime + layoverTime + secondRideTime + destinationWalkTime
//                                print(userLocation.address, "->", userStop.name, "->", "(\(userRoute.name) - \(userRoute.number))", "->", inStop.name, "->", outStop.name, "->", "(\(desRoute.name) - \(desRoute.number))", "->", desStop.name, "->", destination.name, ": ", travelTime, "\n")
                                if travelTime < minTravelTime {
                                    minTravelTime = travelTime
                                    route = (userLocation, [(userRoute, userStop), (userRoute, inStop), (desRoute, outStop), (desRoute, desStop)], destination, travelTime)
                                }
                                if (userRoute,userStop) == userRoutesAndStops.last! && (desRoute, desStop) == destinationRoutesAndStops.last! {
                                    
                                    if let route = route {
                                        completion(route)
                                    } else {
                                        fatalError("No routes are available")
                                    }
                                }
                            }
                            
                        }
                    } else if userRoute == desRoute {
                        var firstRideTime: Double = 0
                        var destinationWalkTime: Double = 0
                        // if the route the user gets on and off at is the same simply calculate the ride time
                        firstRideTime = self.findRideETA(origin: userStop, destination: desStop, route: userRoute)
                        if userStop == desStop {
                            if (userRoute,userStop) == userRoutesAndStops.last! {
                                if let route = route {
                                    completion(route)
                                } else {
                                    print("it is a possibility that no routes are available")
                                }
                            }
                            continue
                        }
                        // find the time it will take for the user to walk from the destination bus stop to the location
                        let destinationStopMapItem = MKMapItem(placemark: MKPlacemark(coordinate: desStop.location))
                        let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination.location))
                        self.findWalkingETA(source: destinationStopMapItem, destination: destinationMapItem) {
                            destinationWalkTime = $0
                            travelTime = originWalkTime + firstRideTime + destinationWalkTime
//                            print(userLocation.address, "->", userStop.name, "->", "(\(userRoute.name) - \(userRoute.number))", "->", desStop.name, "->", destination.name, ": ", travelTime)
                            if travelTime <= minTravelTime {
                                minTravelTime = travelTime
                                route = (userLocation, [(userRoute, userStop), (desRoute, desStop)], destination, travelTime)
                            }
                            if (userRoute,userStop) == userRoutesAndStops.last! {
                                if let route = route {
                                    completion(route)
                                } else {
                                    fatalError("possibility that no routes are available")
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    // use this to find the time it takes to travel to a certain bus stop from the current one on the same bus route
    func findRideETA(origin: BusStop, destination: BusStop, route: BusRoute) -> Double{
        if var stops = route.stops, let time = route.timeDiffMin {
            stops = Array(stops[0..<stops.count-1])
            guard let first = stops.firstIndex(of: origin) else {
                fatalError("Something went wrong")
            }
            stops.rotateLeft(positions: first)
            let avgTimePerStop = (time/Double(stops.count))/60
            guard let last = stops.firstIndex(of: destination) else {
                fatalError("Something went wrong")
            }
            let diff = Double(last - 0)
            return diff * avgTimePerStop
        }
        return -1000
    }
    
    // use this to find the time it takes to walk from one point to another
    func findWalkingETA(source: MKMapItem, destination: MKMapItem, completion: @escaping (Double) -> ()) {
        var eta: Double = 0
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.transportType = .walking
        let directions = MKDirections(request: request)
        if let src = source.placemark.location, let dst = destination.placemark.location {
            if src.distance(from: dst) < 500{
                eta = src.distance(from: dst) * 1.3
                directions.cancel()
                completion(eta/60)
                return
            }
        }
        if !directions.isCalculating{
            directions.calculateETA { etaResponse, error in
                if let error = error {
                    
                    print(error)
                    print("\nSource: \(source.placemark.location!.coordinate.latitude), \(source.placemark.location!.coordinate.longitude)","Destination: \(destination.placemark.location!.coordinate.latitude), \(destination.placemark.location!.coordinate.longitude)\n")
                    
                } else {
                    if let etaResponse = etaResponse {
                        eta = etaResponse.expectedTravelTime
                        completion(eta/60)
                    }
                }
            }
        }
    }

//MARK: - Use this to find the relevant route and closest bus stop in one go
    func findRelevantBusRoutesAndClosestStops(location: Location) -> [(BusRoute,BusStop)]? {
        var routesAndStops: [(BusRoute,BusStop)] = []
        // filter all routes by time constraints
        if let allRoutes = allRoutes {
            let filteredRoutes = allRoutes.filter {
                if let running = $0.currentlyRunning {
                    return running
                } else {
                    return false
                }
            }
            if filteredRoutes.isEmpty {
                return nil
            }
            for route in filteredRoutes {
                    let closestStop = route.stops?.sorted(by: {
                        return $0.location.distance(to: location.location) < $1.location.distance(to: location.location)
                    }).first
                    if let closestStop = closestStop {
                        routesAndStops.append((route,closestStop))
                    }
                }
            // sort by distance then apply a distance buffer
            routesAndStops = routesAndStops.sorted(by: {
                $0.1.location.distance(to: location.location) < $1.1.location.distance(to: location.location)
            })
            let routesAndStopsCopy = routesAndStops
            routesAndStops = routesAndStops.filter({
                $0.1.location.distance(to: location.location) <= 645
            })
//            for (route, stop) in routesAndStops {
//                print(route.name, stop.name, location.name)
//
//            }
//            routesAndStops = routesAndStops.count > 5 ? Array(routesAndStops[..<5]):routesAndStops
            print(routesAndStops.count, location.name)
            return routesAndStops.count == 0 ? routesAndStopsCopy:routesAndStops
        }
        return nil
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



