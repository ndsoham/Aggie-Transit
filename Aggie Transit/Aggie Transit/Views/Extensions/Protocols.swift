//
//  Protocols.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/15/23.
//

import Foundation
import UIKit

protocol DirectionsPanelClosedDelegate {
    func closeDirectionsPanel()
}
protocol BusInformationPanelClosedDelegate {
    func closeBusInformationPanel()
}
protocol PathMakerDelegate {
    func displayBusesOnMap(buses:[Bus])
    func displayBusRouteOnMap(color: UIColor, points: [BusPattern], stops: [BusStop], route: BusRoute)
    func displayPartialRouteOnMap(color: UIColor, points: [BusPattern], startStop: BusStop, endStop: BusStop)
}
protocol RouteDisplayerDelegate {
    func displayRouteOnMap(userLocation: Location, route: [(BusRoute, BusStop)], destination: Location, ETA: Double)
}
protocol SearchResultsPanelClosedDelegate {
    func closeSearchResultsPanel()
}
@objc protocol RefreshDelegate {
    @objc optional func refreshRecentLocations()
    @objc optional func refreshFavoriteBusRoutes()
}
protocol CloseDelegate {
    func handleCloseButtonPressed(sender: UIButton)
}
protocol RouteGenerationProgressDelegate {
    func routeGenerationDidStart()
    func routeGenerationDidEnd()
}
protocol LocationIdentifierDelegate {
    func displaySearchResults(results: [Location])
}
