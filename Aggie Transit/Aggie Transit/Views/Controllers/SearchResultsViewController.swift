//
//  SearchResultsViewController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/12/23.
//

import Foundation
import UIKit
import MapKit
protocol RouteDisplayerDelegate {
    func displayRouteOnMap(userLocation: Location, route: [(BusRoute, BusStop)], destination: Location, ETA: Double)
}
protocol searchResultsPanelClosedDelegate {
    func closeSearchResultsPanel()
}
class SearchResultsViewController: UIViewController {
    private var tableView: UITableView?
    private var tableViewRowHeight: Double = 75
    private var safeMargins: UILayoutGuide?
    private var leftInset: Double?
    public var routeDisplayerDelegate: RouteDisplayerDelegate?
    var searchResults: [Location]?
    private var clearNotification: Notification?
    var closeDelegate: searchResultsPanelClosedDelegate?
    override func viewDidLoad() {
        layoutSubviews()
    }
    func layoutSubviews() {
        self.view.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        leftInset = 15 * Double(self.view.frame.width/375)
        safeMargins = self.view.safeAreaLayoutGuide
        // create and configure the table view
        tableView = UITableView()
        if let tableView = tableView, let leftInset = leftInset, let safeMargins = safeMargins {
            // register cell and header view
            tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: "searchResultsTableViewCell")
            tableView.register(SearchResultsHeaderTableViewCell.self, forCellReuseIdentifier: "searchResultsTableViewHeaderCell")
            // configure the table view
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = tableViewRowHeight
            tableView.separatorStyle = .singleLine
            tableView.separatorColor = UIColor(named: "borderColor1")
            tableView.separatorInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
            tableView.allowsMultipleSelection = false
            tableView.allowsSelection = true
            // add to view hierarchy
            self.view.addSubview(tableView)
            // add constraints
            tableView.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor).isActive = true
            tableView.topAnchor.constraint(equalTo: safeMargins.topAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: safeMargins.bottomAnchor).isActive = true
        }
    }
}


//MARK: - conform to table view delegate methods
extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return tableViewRowHeight * 1.15
        }
        else {
            return tableViewRowHeight
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchResults = searchResults {
            return searchResults.count + 1
        } else {
            return -1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let searchResults = searchResults {
                let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsTableViewHeaderCell") as! SearchResultsHeaderTableViewCell
                cell.resultsNumber = "\(searchResults.count)"
                cell.closeDelegate = self
                return cell
            }
            return UITableViewCell()
        }
        else if let searchResults = searchResults {
            let cell = tableView.dequeueReusableCell(withIdentifier:"searchResultsTableViewCell") as! SearchResultsTableViewCell
            cell.locationName = searchResults[indexPath.row-1].name
            cell.locationAddress = searchResults[indexPath.row-1].address
            cell.locationDistance = "0.5 mi"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewRowHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            if let searchResults = searchResults {
                let userLocation = Location(name: "User Location", location: CLLocationCoordinate2D(latitude: 30.599268155848463, longitude: -96.34196677916258), address: "Park West")
                let destinationLocation = searchResults[indexPath.row-1]
                self.generateRoute(origin: userLocation, destination: destinationLocation)
                self.dismiss(animated: true)
            }
        }
    }
    
}
//MARK: - generate the route when the user clicks the table view cell
extension SearchResultsViewController {
    func generateRoute(origin: Location, destination: Location) {
            let userLocation = origin
            if let destinationRoutesAndStops = RouteGenerator.shared.findRelevantBusRoutesAndClosestStops(location: destination), let userRoutesAndStops = RouteGenerator.shared.findRelevantBusRoutesAndClosestStops(location: userLocation) {
                let (start, stops, finish, travel) = RouteGenerator.shared.generateRoute(destination: destination, destinationRoutesAndStops: destinationRoutesAndStops, userRoutesAndStops: userRoutesAndStops, userLocation: userLocation)
                print("Route Generation Successful ---")
                print(start.name, "-> ", terminator: "")
                for (route, stop) in stops {
                    print(stop.name,terminator: "(\(route.name) - \(route.number)) ->")
                }
                print(finish.name, travel, separator: ":")
                if let routeDisplayerDelegate = routeDisplayerDelegate {
                    routeDisplayerDelegate.displayRouteOnMap(userLocation: start, route: stops, destination: finish, ETA: travel)
                }
            } else {
                if let routeDisplayerDelegate = routeDisplayerDelegate {
                    routeDisplayerDelegate.displayRouteOnMap(userLocation: userLocation, route: [], destination: destination, ETA: RouteGenerator.shared.findWalkingETA(source: MKMapItem(placemark: MKPlacemark(coordinate: userLocation.location)), destination: MKMapItem(placemark: MKPlacemark(coordinate: destination.location))))
                }
            }
        
    }
}
//MARK: - Handle close button pressed
extension SearchResultsViewController: CloseDelegate {
    func handleCloseButtonPressed(sender: UIButton) {
        clearNotification = Notification(name: Notification.Name("clearLocationsFromMap"))
        if let clearNotification = clearNotification {
            NotificationCenter.default.post(clearNotification)
            if let closeDelegate = closeDelegate {
                closeDelegate.closeSearchResultsPanel()
            }
        }
        
    }
}
