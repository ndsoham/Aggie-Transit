//
//  AddLocationsScreenViewController+SearchBarInteractions.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/30/23.
//

import Foundation
import UIKit
import MapKit
extension AddLocationScreenViewController: UISearchBarDelegate {
    //MARK: - text changed by user
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let map else {return}
        searchCompleter.delegate = self
        searchCompleter.queryFragment = searchText
        searchCompleter.region = map.region
    }
    //MARK: - editing began by user
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let map else {return}
        // configure the search bar
        searchBar.showsCancelButton = true
        searchBar.text = nil
        // configure the map
        map.isScrollEnabled = false
        map.isZoomEnabled = false
        map.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.614965, longitude: -96.340584), span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
    }
    //MARK: - editing ended
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let map else {return}
        searchBar.showsCancelButton = false
        // configure the map
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.614965, longitude: -96.340584), span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
    }
    //MARK: - cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    //MARK: - search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let map else {return}
        guard let text = searchBar.text else {return}
        searchBar.endEditing(true)
        searchForLocations(map: map, text: text)
    }
}

extension AddLocationScreenViewController: MKLocalSearchCompleterDelegate {
    //MARK: - update autocomplete results
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
    //MARK: - handle search functionality
    func searchForLocations(map: MKMapView, text: String) {
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = map.region
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let error {
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            } else if let response {
                let _ = response.mapItems.map { item in
                    if let name = item.name, let address = item.placemark.title,address.lowercased().contains("bryan") || address.lowercased().contains("college station") {
                        let location = Location(name: name, location: item.placemark.coordinate, address: address)
                        if let currentLocation = LocationManager.shared.currentLocation {
                            location.distance = round((location.location.distance(to: currentLocation.coordinate) * 0.0006213712)*10)/10.0
                        }
                        self.searchResults.append(location)
                    }
                }
                self.searchResults = self.searchResults.sorted {
                    if let firstDistance = $0.distance, let secondDistance = $1.distance {
                        return firstDistance < secondDistance
                    } else {
                        return false
                    }
                }
                for result in self.searchResults {
                    print(result.name, result.address, result.location)
                }
            }
        }
    }
}


