//
//  DirectionsViewController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/13/23.
//

import Foundation
import UIKit
import MapKit
class DirectionsViewController: UIViewController {
    private var directionsTableView: UITableView?
    private var endpointsTableView: UITableView?
    private var headingLabel: UILabel?
    private var closeButton: UIButton?
    private var safeMargins: UILayoutGuide?
    private var sidePadding: Double?
    private var topInset: Double?
    var delegate: DirectionsPanelClosedDelegate?
    var endpoints: [Location]?
    var route: [(BusRoute, BusStop)]?
    var routeDisplayerDelegate: RouteDisplayerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
    }
    func layoutSubviews() {
        self.view.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        // set up the close button and heading label
        let headingAttributes: [NSAttributedString.Key:Any] = [
            .font:UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor:UIColor(named: "textColor") ?? .black
        ]
        headingLabel = UILabel()
        closeButton = UIButton(type: .close)
        safeMargins = self.view.safeAreaLayoutGuide
        topInset = 10
        sidePadding =  22.5 *  Double(self.view.frame.width/375)
        if let headingLabel, let closeButton, let safeMargins, let topInset, let sidePadding {
            // configure
            headingLabel.translatesAutoresizingMaskIntoConstraints = false
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            headingLabel.attributedText = NSAttributedString(string: "Directions",attributes: headingAttributes)
            // add to view hierarchy
            self.view.addSubview(headingLabel)
            self.view.addSubview(closeButton)
            // constrain
            headingLabel.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor, constant: sidePadding).isActive = true
            headingLabel.topAnchor.constraint(equalTo: safeMargins.topAnchor, constant: topInset).isActive = true
            closeButton.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor, constant: -sidePadding).isActive = true
            closeButton.topAnchor.constraint(equalTo: safeMargins.topAnchor, constant: topInset).isActive = true
            // add target
            closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
            // set up the table views
            endpointsTableView = UITableView()
            if let tableView = endpointsTableView {
                tableView.register(EndpointsTableViewCell.self, forCellReuseIdentifier: "endpointsTableViewCell")
                tableView.clipsToBounds = true
                tableView.layer.cornerRadius = 15
                tableView.delegate = self
                tableView.dataSource = self
                tableView.translatesAutoresizingMaskIntoConstraints = false
                tableView.allowsSelection = false
                tableView.isScrollEnabled = false
                tableView.dragDelegate = self
                tableView.dropDelegate = self
                tableView.dragInteractionEnabled = true
                tableView.separatorColor = UIColor(named: "borderColor1")
                // add to view hierarchy
                self.view.addSubview(tableView)
                // add constraints
                tableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: topInset).isActive = true
                tableView.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor, constant: sidePadding).isActive = true
                tableView.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor, constant: -sidePadding).isActive = true
                tableView.heightAnchor.constraint(equalToConstant: 100).isActive = true
                
                directionsTableView = UITableView()
                if let directionsTableView = directionsTableView {
                    directionsTableView.backgroundColor = UIColor(named: "menuColor")
                    directionsTableView.register(DirectionsTableViewCell.self, forCellReuseIdentifier: "directionsTableViewCell")
                    directionsTableView.clipsToBounds = true
                    directionsTableView.layer.cornerRadius = 15
                    directionsTableView.delegate = self
                    directionsTableView.dataSource = self
                    directionsTableView.translatesAutoresizingMaskIntoConstraints = false
                    directionsTableView.allowsSelection = false
                    directionsTableView.isScrollEnabled = true
                    directionsTableView.separatorColor = UIColor(named: "borderColor1")
                    // add to view hierarchy
                    self.view.addSubview(directionsTableView)
                    // add constraints
                    directionsTableView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: topInset).isActive = true
                    directionsTableView.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor, constant: sidePadding).isActive = true
                    directionsTableView.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor, constant: -sidePadding).isActive = true
                    directionsTableView.bottomAnchor.constraint(equalTo: safeMargins.bottomAnchor, constant: -topInset).isActive = true
                }
            }
        }
    }
}
//MARK: - conform to delegate methods
extension DirectionsViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDragDelegate, UITableViewDropDelegate {
    // provide cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == endpointsTableView {
            return tableView.frame.height / 2.0
        } else if tableView == directionsTableView {
            return tableView.frame.height / 6.0
        }
        return -1
    }
    // provide cell count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == endpointsTableView {
            return 2
        } else if tableView == directionsTableView, let route = route {
            return route.count == 0 ? 3:route.count + 3
        }
        return -1
    }
    // provide cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let endpoints = endpoints {
            if tableView == endpointsTableView {
                let cell = tableView.dequeueReusableCell(withIdentifier: "endpointsTableViewCell") as! EndpointsTableViewCell
                cell.iconTintColor = indexPath.row == 0 ? .systemGreen:.systemRed
                cell.text = endpoints[indexPath.row].name
                cell.textField?.delegate = self
                if indexPath.row == 1 {
                    cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
                }
                return cell
            } else if tableView == directionsTableView, let route = route {
                let cell = tableView.dequeueReusableCell(withIdentifier: "directionsTableViewCell") as! DirectionsTableViewCell
                if indexPath.row == 0 {
                    cell.iconImage = UIImage(systemName: "mappin.circle.fill")
                    cell.directions = endpoints[0].name
                    cell.iconTint = .systemGreen
                } else if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
                    cell.iconImage = UIImage(systemName: "mappin.circle.fill")
                    cell.directions = endpoints[1].name
                    cell.iconTint = .systemRed
                } else {
                    let userLocation = endpoints[0].name
                    let destination = endpoints[1].name
                    if route.count == 2 {
                        let firstBus = route[0].0
                        let firstStop = route[0].1
                        let secondStop = route[1].1
                        if indexPath.row == 1 {
                            cell.iconImage = UIImage(systemName: "figure.walk")
                            cell.directions = "Walk from \(userLocation) to \(firstStop.name)"
                            cell.iconTint = UIColor(named: "textColor")
                        } else if indexPath.row == 2 {
                            cell.iconImage = UIImage(systemName: "bus")
                            cell.directions = "Ride \(firstBus.name) - \(firstBus.number) from \(firstStop.name) to \(secondStop.name)"
                            cell.iconTint = firstBus.color
                        } else if indexPath.row == 3 {
                            cell.iconImage = UIImage(systemName: "figure.walk")
                            cell.directions = "Walk from \(secondStop.name) to \(destination)"
                            cell.iconTint = UIColor(named: "textColor")
                        }
                    }
                    if route.count == 4 {
                        let firstBus = route[0].0
                        let firstStop = route[0].1
                        let secondStop = route[1].1
                        let secondBus = route[2].0
                        let thirdStop = route[2].1
                        let fourthStop = route[3].1
                        if indexPath.row == 1 {
                            cell.iconImage = UIImage(systemName: "figure.walk")
                            cell.directions = "Walk from \(userLocation) to \(firstStop.name)"
                            cell.iconTint = UIColor(named: "textColor")
                        } else if indexPath.row == 2 {
                            cell.iconImage = UIImage(systemName: "bus")
                            cell.directions = "Ride \(firstBus.name) - \(firstBus.number) from \(firstStop.name) to \(secondStop.name)"
                            cell.iconTint = firstBus.color
                        } else if indexPath.row == 3 {
                            cell.iconImage = UIImage(systemName: "figure.walk")
                            cell.directions = "Walk from \(secondStop.name) to \(thirdStop.name)"
                            cell.iconTint = UIColor(named: "textColor")
                        } else if indexPath.row == 4 {
                            cell.iconImage = UIImage(systemName: "bus")
                            cell.directions = "Ride \(secondBus.name) - \(secondBus.number) from \(thirdStop.name) to \(fourthStop.name)"
                            cell.iconTint = secondBus.color
                        } else if indexPath.row == 5 {
                            cell.iconImage = UIImage(systemName: "figure.walk")
                            cell.directions = "Walk from \(fourthStop.name) to \(destination)"
                            cell.iconTint = UIColor(named: "textColor")
                        }
                    }
                    if route.count == 0 {
                        cell.iconImage = UIImage(systemName: "figure.walk")
                        cell.directions = "Walk from \(userLocation) to \(destination)"
                        cell.iconTint = UIColor(named: "textColor")
                    }
                }
                return cell
            }
        }
        return UITableViewCell()
        
    }
    // deal with dragging
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
       if let endpoints = endpoints {
           let itemProvider = NSItemProvider()
            let dragItem = UIDragItem(itemProvider: itemProvider)
               dragItem.localObject = endpoints[indexPath.row]
            return [dragItem]
       }
        return []
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
       
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        endpoints?.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession) {
        if let endpoints = endpoints {
            self.generateRoute(origin: endpoints[0], destination: endpoints[1])
            self.dismiss(animated: true)
        }
    }
}
//MARK: - deal with button press
extension DirectionsViewController {
    @objc func closeButtonPressed(sender: UIButton) {
        if let delegate = delegate {
            delegate.closeDirectionsPanel()
        }
    }
}
//MARK: - Use this to generate a route when user changes the location
extension DirectionsViewController {
    private func generateRoute(origin: Location, destination: Location) {
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
//MARK: - deal with text field delegate methods
extension DirectionsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    
    }
}
