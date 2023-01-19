//
//  RouteGenerator.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/6/23.
//

import Foundation
import MapKit

// this class is used to generate the actual route between two endpoints, and display the walking route between two endpoints
class RouteGenerator {
    static let shared = RouteGenerator()
    var progressDelegate: RouteGenerationProgressDelegate?
    var allRoutes: [BusRoute]?
    var alertDelegate: AlertDelegate?
    private let dataGatherer = DataGatherer()
    private init() {}
    //MARK: - Find the closest bus stops along two routes
    func findClosestBusStops(inRoute: BusRoute, outRoute: BusRoute) -> (BusStop, BusStop){
        var distance = Double.greatestFiniteMagnitude
        var closestStops: (BusStop, BusStop) = (BusStop(name: "empty", location: CLLocationCoordinate2D(), isTimePoint: false, key: "none"),BusStop(name: "empty", location: CLLocationCoordinate2D(), isTimePoint: false, key: "none"))
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
    //MARK: - Use this to generate the route
    func generateRoute(destination: Location, destinationRoutesAndStops: [(BusRoute,[BusStop])], userRoutesAndStops: [(BusRoute, [BusStop])], userLocation: Location) -> (Location, [(BusRoute, BusStop)], Location, Double){
        progressDelegate?.routeGenerationDidStart()
        var minTravelTime: Double = Double.greatestFiniteMagnitude
        // the route array contains the starting location, followed by a series of intermediate steps namely bus routes/stops and the destination location
        var route: (Location, [(BusRoute, BusStop)], Location, Double)? = nil
        // arrays have been filtered at this point so all there is to find is the fastest route to the destination
        for (userRoute, userStops) in userRoutesAndStops {
            var travelTime: Double = 0
            var originWalkTime: Double = 0
            for userStop in userStops {
                // first calculate the time it will take for the user to walk to the origin bus stop
                let userStopMapItem = MKMapItem(placemark:MKPlacemark(coordinate: userStop.location))
                let userLocationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.location))
                originWalkTime = findWalkingETA(source: userLocationMapItem, destination: userStopMapItem)
                // next calculate the time it will take for the user to ride the bus to the next bus stop he/she gets off at
                for (desRoute, desStops) in destinationRoutesAndStops {
                    var busArrivalTime: Double = 0
                    var firstRideTime: Double = 0
                    var stopChangeTime: Double = 0
                    var secondBusArrivalTime: Double = 0
                    var secondRideTime: Double = 0
                    var destinationWalkTime: Double = 0
                    for desStop in desStops{
                        // this is the case that the user has to change bus stops
                        if userRoute != desRoute {
                            // first find the closest bus stops between the two bus routes
                            let (inStop, outStop) = self.findClosestBusStops(inRoute: userRoute, outRoute: desRoute)
                            // check how long it will take for the bus to get there
                            busArrivalTime = findBusETA(destination: userStop, route: userRoute, arrivalTime: NSDate.now.addingTimeInterval(originWalkTime*60))
                            // no point on getting on and off a bus instantly, so declare an invalid first ride time if that is the case
                            firstRideTime = userStop == inStop ? -1000:self.findRideETA(origin: userStop, destination: inStop, route: userRoute)
                            // calculate the time it will take for the user to walk between the two bus stops
                            let firstStop = MKMapItem(placemark: MKPlacemark(coordinate: inStop.location))
                            let secondStop = MKMapItem(placemark: MKPlacemark(coordinate: outStop.location))
                            stopChangeTime = firstRideTime > 0 ? self.findWalkingETA(source: firstStop, destination: secondStop):-1000
                            // calculate the time it will take for the bus to get to a certain location
                            let secondStopArrivalTime = NSDate.now.addingTimeInterval((originWalkTime + firstRideTime + stopChangeTime)*60)
                            secondBusArrivalTime = (firstRideTime > 0 && firstRideTime > 0 && stopChangeTime > 0) ? self.findBusETA(destination: outStop, route: desRoute, arrivalTime: secondStopArrivalTime):-1000
                            // find the time the user will spend on the second bus
                            secondRideTime = (outStop == desStop || outStop.location.distance(to: desStop.location) <= 650 || secondBusArrivalTime < 0) ? -1000:self.findRideETA(origin: outStop, destination: desStop, route: desRoute)
                            // finally find the time it will take for the user to walk from the desintation bus stop to the location
                            let destinationStopMapItem = MKMapItem(placemark: MKPlacemark(coordinate: desStop.location))
                            let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination.location))
                            destinationWalkTime = secondRideTime > 0 ? self.findWalkingETA(source: destinationStopMapItem, destination: destinationMapItem):-1000
                            travelTime = originWalkTime + busArrivalTime + firstRideTime + stopChangeTime + secondBusArrivalTime + secondRideTime + destinationWalkTime
                            if travelTime < minTravelTime && (originWalkTime > 0 && firstRideTime > 0 && stopChangeTime > 0 && secondRideTime > 0 && destinationWalkTime > 0 && busArrivalTime > 0 && secondBusArrivalTime > 0) {
                                minTravelTime = travelTime
                                route = (userLocation, [(userRoute, userStop), (userRoute, inStop), (desRoute, outStop), (desRoute, desStop)], destination, travelTime)
                            }
                            //   print(originWalkTime, busArrivalTime, firstRideTime, stopChangeTime, secondRideTime, destinationWalkTime)
                            //   print(userLocation.address, "->", userStop.name, "->", "(\(userRoute.name) - \(userRoute.number))", "->", inStop.name, "->", outStop.name, "->", "(\(desRoute.name) - \(desRoute.number))", "->", desStop.name, "->", destination.name, ": ", travelTime, "\n")
                        }
                        // this is the case where the user will only have to take a single bus
                        else if userRoute == desRoute {
                            // find how long it will take for the bus to get there
                            busArrivalTime = findBusETA(destination: userStop, route: userRoute, arrivalTime: NSDate.now.addingTimeInterval((originWalkTime*60)))
                            // if the route the user gets on and off at is the same simply calculate the ride time
                            firstRideTime = userStop == desStop ? -1000:self.findRideETA(origin: userStop, destination: desStop, route: userRoute)
                            // find the time it will take for the user to walk from the destination bus stop to the location
                            let destinationStopMapItem = MKMapItem(placemark: MKPlacemark(coordinate: desStop.location))
                            let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination.location))
                            destinationWalkTime = firstRideTime > 0 ? self.findWalkingETA(source: destinationStopMapItem, destination: destinationMapItem):-1000
                            travelTime = originWalkTime + busArrivalTime + firstRideTime + destinationWalkTime
                            if travelTime <= minTravelTime && (busArrivalTime>0 && originWalkTime>0 && firstRideTime>0 && destinationWalkTime>0) {
                                minTravelTime = travelTime
                                route = (userLocation, [(userRoute, userStop), (desRoute, desStop)], destination, travelTime)
                            }
                             print(originWalkTime, busArrivalTime, firstRideTime, destinationWalkTime)
                             print(userLocation.address, "->", userStop.name, "->", "(\(userRoute.name) - \(userRoute.number))", "->", desStop.name, "->", destination.name, ": ", travelTime)
                        }
                    }
                }
            }
        }
        // check if just faster to walk from your current location to destination location and if so recommend a walking route
        let fullWalkTime = findWalkingETA(source: MKMapItem(placemark: MKPlacemark(coordinate: userLocation.location)), destination: MKMapItem(placemark: MKPlacemark(coordinate: destination.location)))
        if fullWalkTime < minTravelTime - 5 {
            minTravelTime = fullWalkTime
            route = (userLocation, [], destination, fullWalkTime)
        }
        if let route = route {
            return route
        } else {
            // in case no route can ge generated for whatever reason
            let alert = UIAlertController(title: "Alert", message: "No suitable route found.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            alertDelegate?.displayAlert(alert: alert)
            return (Location(name: "", location: CLLocationCoordinate2D(), address: ""),[(BusRoute(name: "", number: "", color: .clear, campus: ""),BusStop(name: "", location: CLLocationCoordinate2D(), isTimePoint: false, key: ""))], Location(name: "", location: CLLocationCoordinate2D(), address: ""),-1)
        }
    }
    //MARK: - use this to find the time it takes to travel to a certain bus stop from the current one on the same bus route; returns in minutes
    func findRideETA(origin: BusStop, destination: BusStop, route: BusRoute) -> Double{
        if var stops = route.stops, let time = route.routeTime {
            guard let first = stops.firstIndex(of: origin) else {
                return -1000
            }
            stops.rotateLeft(positions: first)
            let avgTimePerStop = (time/Double(stops.count-1))/60
            guard let last = stops.firstIndex(of: destination) else {
                return -1000
            }
            let diff = Double(last)
            return diff * avgTimePerStop
        }
        return -1000
    }
    //MARK: - use this to find the time it will take for a live bus to travel from one place to another; returns in minutes
    func findBusETA(destination: BusStop, route: BusRoute, arrivalTime: Date) -> Double{
        var travelTime: Double = Double.greatestFiniteMagnitude
        let timeDiff = arrivalTime.timeIntervalSinceNow
        if let buses = route.buses, var stops = route.stops, let time = route.routeTime {
            let avgTimePerStop = (time/Double(stops.count-1))
            let stopDiff  = Int(floor((1/avgTimePerStop)/timeDiff))
            stops = Array(stops[0..<stops.count-1])
            for bus in buses {
                let potentialNextStops = stops.filter({$0.name == bus.nextStop})
                let nextStop = potentialNextStops.min(by: {$0.location.distance(to: bus.location) < $1.location.distance(to: bus.location)})
                if let nextStop {
                    if let closestStopIndex = stops.firstIndex(of: nextStop) {
                        stops.rotateLeft(positions: closestStopIndex + stopDiff)
                        if let diff = stops.firstIndex(of: destination) {
                            var potentialTravelTime = Double(diff) * avgTimePerStop
                            if let stopTime = route.stopTime, arrivalTime.addingTimeInterval(potentialTravelTime) > stopTime {
                                potentialTravelTime = -1000
                            }
                            if potentialTravelTime < travelTime && potentialTravelTime > 0 {
                                travelTime = potentialTravelTime
                            }
                        }
                        
                    }
                }
            }
        }
        return travelTime/60
    }
    //MARK: - use this to find the time it takes to walk from one point to another, approximate halfway between greatest and smallest logical distance; returns in minutes
    func findWalkingETA(source: MKMapItem, destination: MKMapItem) -> Double {
        var eta: Double = -1000
        if let src = source.placemark.location, let dst = destination.placemark.location {
            let minDistance = src.distance(from: dst)
            let maxDistance = minDistance*cos(rad(90)) + minDistance*sin(rad(90))
            let approxDistance = (maxDistance + minDistance)/2
            eta = approxDistance * (1/1.3)
            return eta/60
        }
        // this is if the source or destination are invalid
        return eta
    }
    
    //MARK: - Use this to find the relevant route and closest bus stop in one go
    func findRelevantBusRoutesAndClosestStops(location: Location) -> [(BusRoute,[BusStop])]? {
        var routesAndStops: [(BusRoute,[BusStop])] = []
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
                if var stops = route.stops{
                    stops = Array(stops[0..<stops.count-1])
                    var closestStops = stops.sorted(by: {
                        return $0.location.distance(to: location.location) < $1.location.distance(to: location.location)
                    })
                    let closestStopsCopy = closestStops
                    closestStops = closestStops.filter({
                        $0.location.distance(to: location.location) <= 1000
                    })
                    closestStops.count == 0 ? routesAndStops.append((route, [closestStopsCopy[0]])) : routesAndStops.append((route,closestStops))
                    
                }
            }
            // sort by distance then apply a distance buffer
            routesAndStops = routesAndStops.sorted(by: {
                if let closestStop1 = $0.1.first, let closestStop2 = $1.1.first {
                    return closestStop1.location.distance(to: location.location) < closestStop2.location.distance(to: location.location)
                } else {
                    return false
                }
            })
            return routesAndStops
        }
        return nil
    }
    //MARK: - Use this to generate a walking path
    func findWalkingRoute(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping (MKPolyline, RouteGenerationProgressDelegate?)->()) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: origin))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                self.progressDelegate?.routeGenerationDidEnd()
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.alertDelegate?.displayAlert(alert: alert)
            } else {
                if let response = response {
                    let bestRoute = response.routes.reduce(response.routes.first) {
                        if let partialResult = $0 {
                            if partialResult.expectedTravelTime < $1.expectedTravelTime {
                                return partialResult
                            } else {
                                return $1
                            }
                        } else {
                            return $1
                        }
                    }
                    if let bestRoute = bestRoute {
                        completion(bestRoute.polyline, self.progressDelegate)
                    }
                }
            }
        }
    }
}

