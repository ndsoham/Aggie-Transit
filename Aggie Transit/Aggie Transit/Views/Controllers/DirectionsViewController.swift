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
    private var endpointsTableView: UITableView = UITableView()
    private var headingLabel: UILabel = UILabel()
    private var closeButton: UIButton = UIButton(type: .close)
    private var safeMargins: UILayoutGuide?
    private var sidePadding: Double?
    private var topInset: Double = 10
    var delegate: DirectionsPanelClosedDelegate?
    var endpoints: [Location]?
    var route: [(BusRoute, BusStop)]?
    var routeDisplayerDelegate: RouteDisplayerDelegate?
    var eta: Double?
    var walkDistances: [Double]?
    var directionsTableView: UITableView = UITableView()
    //MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
    }
    //MARK: - layout subviews
    func layoutSubviews() {
        self.view.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        // set up the close button and heading label
        let headingAttributes: [NSAttributedString.Key:Any] = [
            .font:UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor:UIColor(named: "textColor") ?? .black
        ]
        safeMargins = self.view.safeAreaLayoutGuide
        sidePadding =  22.5 *  Double(self.view.frame.width/375)
        if let safeMargins, let sidePadding {
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
            endpointsTableView.register(EndpointsTableViewCell.self, forCellReuseIdentifier: "endpointsTableViewCell")
            endpointsTableView.clipsToBounds = true
            endpointsTableView.layer.cornerRadius = 15
            endpointsTableView.delegate = self
            endpointsTableView.dataSource = self
            endpointsTableView.translatesAutoresizingMaskIntoConstraints = false
            endpointsTableView.allowsSelection = false
            endpointsTableView.isScrollEnabled = false
            endpointsTableView.dragDelegate = self
            endpointsTableView.dropDelegate = self
            endpointsTableView.dragInteractionEnabled = true
            endpointsTableView.separatorColor = UIColor(named: "borderColor1")
            // add to view hierarchy
            self.view.addSubview(endpointsTableView)
            // add constraints
            endpointsTableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: topInset).isActive = true
            endpointsTableView.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor, constant: sidePadding).isActive = true
            endpointsTableView.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor, constant: -sidePadding).isActive = true
            endpointsTableView.heightAnchor.constraint(equalToConstant: 100).isActive = true
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
            directionsTableView.topAnchor.constraint(equalTo: endpointsTableView.bottomAnchor, constant: topInset).isActive = true
            directionsTableView.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor, constant: sidePadding).isActive = true
            directionsTableView.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor, constant: -sidePadding).isActive = true
            directionsTableView.bottomAnchor.constraint(equalTo: safeMargins.bottomAnchor, constant: -topInset).isActive = true
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
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm a")
        if let endpoints = endpoints {
            if tableView == endpointsTableView {
                let cell = tableView.dequeueReusableCell(withIdentifier: "endpointsTableViewCell") as! EndpointsTableViewCell
                cell.iconTintColor = indexPath.row == 0 ? .systemGreen:.systemRed
                cell.text = endpoints[indexPath.row].name
                if indexPath.row == 1 {
                    cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
                }
                return cell
            } else if tableView == directionsTableView, let route, let walkDistances {
                let cell = tableView.dequeueReusableCell(withIdentifier: "directionsTableViewCell") as! DirectionsTableViewCell
                if indexPath.row == 0 {
                    cell.iconImage = UIImage(systemName: "mappin.circle.fill")
                    cell.directions = "Start at \(dateFormatter.string(from: NSDate.now))"
                    cell.directionsHeader = endpoints[0].name
                    cell.iconTint = .systemGreen
                } else if indexPath.row == tableView.numberOfRows(inSection: 0) - 1, let eta {
                    cell.iconImage = UIImage(systemName: "mappin.circle.fill")
                    cell.directionsHeader = endpoints[1].name
                    cell.directions = "Arrive at \(dateFormatter.string(from: NSDate.now.addingTimeInterval(eta*60)))"
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
                            cell.directionsHeader = "Walk"
                            cell.directions = "From \(userLocation) to \(firstStop.name)"
                            cell.iconTint = UIColor(named: "textColor")
                            cell.walkingDistance = walkDistances[0]
                        } else if indexPath.row == 2 {
                            cell.iconImage = UIImage(systemName: "bus")
                            cell.directionsHeader = "Ride \(firstBus.name) - \(firstBus.number)"
                            cell.directions = "From \(firstStop.name) to \(secondStop.name)"
                            cell.iconTint = firstBus.color
                        } else if indexPath.row == 3 {
                            cell.iconImage = UIImage(systemName: "figure.walk")
                            cell.directionsHeader = "Walk"
                            cell.directions = "From \(secondStop.name) to \(destination)"
                            cell.iconTint = UIColor(named: "textColor")
                            cell.walkingDistance = walkDistances[1]
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
                            cell.directions = "From \(userLocation) to \(firstStop.name)"
                            cell.directionsHeader = "Walk"
                            cell.iconTint = UIColor(named: "textColor")
                            cell.walkingDistance = walkDistances[0]
                        } else if indexPath.row == 2 {
                            cell.iconImage = UIImage(systemName: "bus")
                            cell.directions = "From \(firstStop.name) to \(secondStop.name)"
                            cell.directionsHeader = "Ride \(firstBus.name) - \(firstBus.number)"
                            cell.iconTint = firstBus.color
                        } else if indexPath.row == 3 {
                            cell.iconImage = UIImage(systemName: "figure.walk")
                            cell.directionsHeader = "Walk"
                            cell.directions = "From \(secondStop.name) to \(thirdStop.name)"
                            cell.iconTint = UIColor(named: "textColor")
                            cell.walkingDistance = walkDistances[1]
                        } else if indexPath.row == 4 {
                            cell.iconImage = UIImage(systemName: "bus")
                            cell.directionsHeader = "Ride \(secondBus.name) - \(secondBus.number)"
                            cell.directions = "From \(thirdStop.name) to \(fourthStop.name)"
                            cell.iconTint = secondBus.color
                        } else if indexPath.row == 5 {
                            cell.iconImage = UIImage(systemName: "figure.walk")
                            cell.directionsHeader = "Walk"
                            cell.directions = "From \(fourthStop.name) to \(destination)"
                            cell.iconTint = UIColor(named: "textColor")
                            cell.walkingDistance = walkDistances[2]
                        }
                    }
                    if route.count == 0 {
                        cell.iconImage = UIImage(systemName: "figure.walk")
                        cell.directions = "From \(userLocation) to \(destination)"
                        cell.directionsHeader = "Walk"
                        cell.iconTint = UIColor(named: "textColor")
                        cell.walkingDistance = walkDistances[0]
                    }
                }
                return cell
            }
        }
        return UITableViewCell()
        
    }
    //MARK: - handle dragging
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return []
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        endpoints?.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession) {
        if let endpoints = endpoints {
            self.dismiss(animated: true)
            self.generateRoute(origin: endpoints[0], destination: endpoints[1])
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
            let (start, stops, finish, travel, distances) = RouteGenerator.shared.generateRoute(destination: destination, destinationRoutesAndStops: destinationRoutesAndStops, userRoutesAndStops: userRoutesAndStops, userLocation: userLocation)
            print("Route Generation Successful ---")
            print(start.name, "-> ", terminator: "")
            for (route, stop) in stops {
                print(stop.name,terminator: "(\(route.name) - \(route.number)) ->")
            }
            print(finish.name, travel, separator: ":")
            if let routeDisplayerDelegate = routeDisplayerDelegate {
                routeDisplayerDelegate.displayRouteOnMap(userLocation: start, route: stops, destination: finish, ETA: travel, walkDistances: distances)
            }
        } else {
            if let routeDisplayerDelegate = routeDisplayerDelegate {
                let (walkTime, walkDistance) = RouteGenerator.shared.findWalkingETA(source: MKMapItem(placemark: MKPlacemark(coordinate: userLocation.location)), destination: MKMapItem(placemark: MKPlacemark(coordinate: destination.location)))
                routeDisplayerDelegate.displayRouteOnMap(userLocation: userLocation, route: [], destination: destination,ETA: walkTime, walkDistances: [walkDistance])
            }
        }
        
    }
}
