//
//  Protocols.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/15/23.
//

import Foundation
import UIKit
// This file contains all of the protocols used within this project
//MARK: - Panel display
protocol DirectionsPanelClosedDelegate {
    func closeDirectionsPanel()
}
protocol BusInformationPanelClosedDelegate {
    func closeBusInformationPanel()
}
protocol SearchResultsPanelClosedDelegate {
    func closeSearchResultsPanel()
}
protocol CloseDelegate {
    func handleCloseButtonPressed(sender: UIButton)
}
//MARK: - Bus Route Display
protocol PathMakerDelegate {
    func displayBusesOnMap(buses:[Bus])
    func displayBusRouteOnMap(color: UIColor, points: [BusPattern], stops: [BusStop], route: BusRoute)
    func displayPartialRouteOnMap(color: UIColor, points: [BusPattern], startStop: BusStop, endStop: BusStop)
}
protocol RouteDisplayerDelegate {
    func displayRouteOnMap(userLocation: Location, route: [(BusRoute, BusStop)], destination: Location, routeTimes: [Date], walkDistances: [Double])
}
//MARK: - loading animation
protocol RouteGenerationProgressDelegate {
    func routeGenerationDidStart()
    func routeGenerationDidEnd()
}
//MARK: - Data related protocols
@objc protocol DataGathererDelegate {
    @objc optional func didGatherNotifications(notifications: [BusNotification])
    
}
protocol BusRouteDataGathererDelegate {
    func didGatherBusPattern(points: [BusPattern])
    func didGatherBuses(buses: [Bus])
    func didGatherTimeTable(table: [[String:Date?]])
}

