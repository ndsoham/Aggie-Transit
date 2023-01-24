//
//  SearchResultsViewController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/12/23.
//

import Foundation
import UIKit
import MapKit
import CoreData

class SearchResultsViewController: UIViewController {
    var tableView: UITableView = UITableView()
    private var tableViewRowHeight: Double = 75
    private var safeMargins: UILayoutGuide?
    private var leftInset: Double?
    private var clearNotification: Notification?
    var routeDisplayerDelegate: RouteDisplayerDelegate?
    var searchResults: [Location]?
    var closeDelegate: SearchResultsPanelClosedDelegate?
    var container: NSPersistentContainer! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var refreshDelegate: RefreshDelegate?
    //MARK: - view did load
    override func viewDidLoad() {
        layoutSubviews()
        checkContainerStatus()
    }
    //MARK: - check container status
    func checkContainerStatus() {
        guard container != nil else {
            let alert = UIAlertController(title: "Alert", message: "Database not initialized correctly.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            return
        }
    }
    //MARK: - layout subviews
    func layoutSubviews() {
        self.view.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        leftInset = 15 * Double(self.view.frame.width/375)
        safeMargins = self.view.safeAreaLayoutGuide
        // create and configure the table view
        if let leftInset = leftInset, let safeMargins = safeMargins {
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
    // row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return tableViewRowHeight * 1.15
        }
        else {
            return tableViewRowHeight
        }
    }
    // number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchResults = searchResults {
            return searchResults.count + 1
        } else {
            return -1
        }
    }
    // cell
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
            if cell.locationName == nil, cell.locationAddress == nil, cell.locationDistance == nil {
                cell.locationName = searchResults[indexPath.row-1].name
                cell.locationAddress = searchResults[indexPath.row-1].address
                cell.locationDistance = "\(String(describing: searchResults[indexPath.row-1].distance ?? 0.5)) mi"
                cell.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                return cell
            }
        }
        return UITableViewCell()
    }
    // header
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            if let searchResults = searchResults {
                if let userLocation = LocationManager.shared.currentLocation {
                    let originLocation = Location(name: "Current Location", location: userLocation.coordinate, address: "")
                    let destinationLocation = searchResults[indexPath.row-1]
                    self.generateRoute(origin: originLocation, destination: destinationLocation)
                    self.addLocationToRecentLocations(location: searchResults[indexPath.row-1])
                    self.dismiss(animated: true)
                }
            }
        }
    }
}
//MARK: - generate the route when the user clicks the table view cell
extension SearchResultsViewController {
    func generateRoute(origin: Location, destination: Location) {
            let userLocation = origin
            if let destinationRoutesAndStops = RouteGenerator.shared.findRelevantBusRoutesAndClosestStops(location: destination), let userRoutesAndStops = RouteGenerator.shared.findRelevantBusRoutesAndClosestStops(location: userLocation) {
                let (start, stops, finish, travel, distances) = RouteGenerator.shared.generateRoute(destination: destination, destinationRoutesAndStops: destinationRoutesAndStops, userRoutesAndStops: userRoutesAndStops, userLocation: userLocation)
                print("Route Generation Successful ---")
                print(start.name, "-> ", terminator: "")
                for (route, stop) in stops {
                    print(stop.name,terminator: "(\(route.name) - \(route.number)) ->")
                }
                print(finish.name, travel, separator: ":")
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
//MARK: - use this to add to recent locations
extension SearchResultsViewController {
    func addLocationToRecentLocations(location: Location) {
        let recentLocation = RecentLocation(context: container.viewContext)
        recentLocation.name = location.name
        recentLocation.address = location.address
        recentLocation.latitude = location.location.latitude
        recentLocation.longitude = location.location.longitude
        recentLocation.date = NSDate.now
        do{
            try container.viewContext.save()
            if let refreshDelegate {
                if let refresh = refreshDelegate.refreshRecentLocations {
                    refresh()
                }
            }
        } catch {
            let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert,animated: true)
        }
    }
}
