//
//  HomeScreenMenuViewController+SearchBarInteractions.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/29/23.
//

import Foundation
import UIKit
import MapKit

extension HomeScreenMenuViewController: UISearchBarDelegate {
    //MARK: - text changed by user
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let map else {return}
        searchCompleter.delegate = self
        searchCompleter.queryFragment = searchText
        searchCompleter.region = map.region
    }
    //MARK: - edidting began by user
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let map else {return}
        // configure the search bar
        searchBar.showsCancelButton = true
        searchBar.text = nil
        // configure the map
        map.isScrollEnabled = false
        map.isZoomEnabled = false
        map.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.614965, longitude: -96.340584), span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
        // remove the favorites and recents view
        self.defaultCollectionView?.removeFromSuperview()
        self.setupSearchCollectionView()
    }
    //MARK: - editing ended
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let map else {return}
        searchBar.showsCancelButton = false
        // configure the map
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.614965, longitude: -96.340584), span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
        // add the collection view back to hierarchy and remove the search collection view
        self.searchCollectionView?.removeFromSuperview()
        self.setupDefaultCollectionView()
    }
    //MARK: - cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    //    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //        searchBar.endEditing(true)
    //        if let map = map {
    //            activityIndicator.startAnimating()
    //            let searchRequest = MKLocalSearch.Request()
    //            searchRequest.naturalLanguageQuery = searchBar.text
    //            searchRequest.region = map.region
    //            let search = MKLocalSearch(request: searchRequest)
    //            search.start { response, error in
    //                if let error = error {
    //                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .actionSheet)
    //                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
    //                    self.activityIndicator.stopAnimating()
    //                    self.displayAlert(alert: alert)
    //                }
    //                if let response {
    //                    var locations:[Location] = []
    //                    for item in response.mapItems {
    //                        if let name = item.name, let address = item.placemark.title, address.lowercased().contains("bryan") || address.lowercased().contains("college station") {
    //                            let location = Location(name: name, location: item.placemark.coordinate, address: address)
    //                            if let currentLocation = LocationManager.shared.currentLocation {
    //                                // do this to round to two decimal places
    //                                location.distance = round((location.location.distance(to: currentLocation.coordinate) * 0.0006213712)*10)/10.0
    //                            }
    //                            locations.append(location)
    //                        }
    //                    }
    //                    locations = locations.sorted {
    //                        if let firstDistance = $0.distance, let secondDistance = $1.distance {
    //                            return firstDistance < secondDistance
    //                        } else {
    //                            return false
    //                        }
    //                    }
    //                    if let locationIdentifierDelegate = self.locationIdentifierDelegate {
    //                        self.activityIndicator.stopAnimating()
    //                        locationIdentifierDelegate.displaySearchResults(results: locations)
    //                    }
    //                    self.collapseNotification = Notification(name: Notification.Name(rawValue: "collapseMenu"))
    //                    if let collapseNotification = self.collapseNotification {
    //                        NotificationCenter.default.post(collapseNotification)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
}

//MARK: - search completer's delegate

extension HomeScreenMenuViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        if !completer.results.isEmpty {
            searchCompleterResults.removeAll()
            for result in completer.results {
                searchCompleterResults.append(Location(name: result.title, location: CLLocationCoordinate2D(), address: result.subtitle))
            }
            DispatchQueue.main.async {
                self.searchCollectionView?.reloadData()
            }
        }
    }
}

