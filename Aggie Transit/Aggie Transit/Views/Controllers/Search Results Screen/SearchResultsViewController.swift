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
    
    private var clearNotification: Notification?
    var routeDisplayerDelegate: RouteDisplayerDelegate?
    var searchResults: [Location] = []
    var container: NSPersistentContainer! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var headerLabel: UILabel = UILabel()
    var subHeaderLabel: UILabel = UILabel()
    var headerStack: UIStackView = UIStackView()
    var backButton: UIButton = UIButton(type: .system)
    var locationName: String?
    var numResults: String?
    var resultsCollectionView: UICollectionView?
    var singleColumnLayout: SingleColumnLayout = SingleColumnLayout()
   
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
        setupSelf()
        setupHeaderLabel()
        setupBackButton()
        setupResultsCollectionView()
    }
}



//MARK: - generate the route when the user clicks the table view cell
//extension SearchResultsViewController {
//    func generateRoute(origin: Location, destination: Location) {
//            let userLocation = origin
//            if let destinationRoutesAndStops = RouteGenerator.shared.findRelevantBusRoutesAndClosestStops(location: destination), let userRoutesAndStops = RouteGenerator.shared.findRelevantBusRoutesAndClosestStops(location: userLocation) {
//                let (start, stops, finish, travel, distances) = RouteGenerator.shared.generateRoute(destination: destination, destinationRoutesAndStops: destinationRoutesAndStops, userRoutesAndStops: userRoutesAndStops, userLocation: userLocation)
////                print("Route Generation Successful ---")
////                print(start.name, "-> ", terminator: "")
////                for (route, stop) in stops {
////                    print(stop.name,terminator: "(\(route.name) - \(route.number)) ->")
////                }
////                print(finish.name, travel, separator: ":")
//                if let routeDisplayerDelegate = routeDisplayerDelegate {
//                    routeDisplayerDelegate.displayRouteOnMap(userLocation: start, route: stops, destination: finish, routeTimes: travel, walkDistances: distances)
//                }
//            } else {
//                if let routeDisplayerDelegate = routeDisplayerDelegate {
//                    let (walkTime, walkDistance) = RouteGenerator.shared.findWalkingETA(source: MKMapItem(placemark: MKPlacemark(coordinate: userLocation.location)), destination: MKMapItem(placemark: MKPlacemark(coordinate: destination.location)))
//                    let start = NSDate.now
//                    let arrive = start.addingTimeInterval(walkTime*60)
//                    routeDisplayerDelegate.displayRouteOnMap(userLocation: userLocation, route: [], destination: destination, routeTimes: [start, arrive], walkDistances: [walkDistance])
//                }
//            }
//
//    }
//}
////MARK: - Handle close button pressed
//extension SearchResultsViewController: CloseDelegate {
//    func handleCloseButtonPressed(sender: UIButton) {
//        clearNotification = Notification(name: Notification.Name("clearLocationsFromMap"))
//        if let clearNotification = clearNotification {
//            NotificationCenter.default.post(clearNotification)
//            if let closeDelegate = closeDelegate {
//                closeDelegate.closeSearchResultsPanel()
//            }
//        }
//
//    }
//}
//MARK: - use this to add to recent locations
//extension SearchResultsViewController {
//    func addLocationToRecentLocations(location: Location) {
//        let recentLocation = RecentLocation(context: container.viewContext)
//        recentLocation.name = location.name
//        recentLocation.address = location.address
//        recentLocation.latitude = location.location.latitude
//        recentLocation.longitude = location.location.longitude
//        recentLocation.date = NSDate.now
//        do{
//            try container.viewContext.save()
//            if let refreshDelegate {
//                if let refresh = refreshDelegate.refreshRecentLocations {
//                    refresh()
//                }
//            }
//        } catch {
//            let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
//            self.present(alert,animated: true)
//        }
//    }
//}
