//
//  HomeScreenMenuViewController+Route Generation.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/15/23.
//

import Foundation
import MapKit
extension HomeScreenMenuViewController {
    func generateRoute(origin: Location, destination: Location) {
        let userLocation = origin
        if let destinationRoutesAndStops = RouteGenerator.shared.findRelevantBusRoutesAndClosestStops(location: destination), let userRoutesAndStops = RouteGenerator.shared.findRelevantBusRoutesAndClosestStops(location: userLocation) {
            let (start, stops, finish, travel, distances) = RouteGenerator.shared.generateRoute(destination: destination, destinationRoutesAndStops: destinationRoutesAndStops, userRoutesAndStops: userRoutesAndStops, userLocation: userLocation)
//            print("Route Generation Successful ---")
//            print(start.name, "-> ", terminator: "")
//            for (route, stop) in stops {
//                print(stop.name,terminator: "(\(route.name) - \(route.number)) ->")
//            }
//            print(finish.name, travel, separator: ":")
            if let routeDisplayerDelegate = routeDisplayerDelegate {
                routeDisplayerDelegate.displayRouteOnMap(userLocation: start, route: stops, destination: finish, routeTimes: travel, walkDistances: distances)
            }
        } else {
            if let routeDisplayerDelegate = routeDisplayerDelegate {
                let (walkTime, walkDistance) = RouteGenerator.shared.findWalkingETA(source: MKMapItem(placemark: MKPlacemark(coordinate: userLocation.location)), destination: MKMapItem(placemark: MKPlacemark(coordinate: destination.location)))
                let start = NSDate.now
                let arrive = start.addingTimeInterval(walkTime*60)
                routeDisplayerDelegate.displayRouteOnMap(userLocation: userLocation, route: [], destination: destination, routeTimes: [start, arrive], walkDistances: [walkDistance])
            }
        }
        
    }
}
