//
//  HomeScreenViewController2.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/25/22.
//

import Foundation
import UIKit
import MapKit
import FloatingPanel
class HomeScreenViewController: UIViewController {
    var map: MKMapView = MKMapView()
    let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.614965, longitude: -96.340584),
        span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125)
    )
    var buttonStack: UIStackView = UIStackView()
    var notiButton: UIButton = UIButton()
    var busButton: UIButton = UIButton()
    var favButton: UIButton = UIButton()
    var userButton: UIButton = UIButton()
    
    private var mapMargins: UILayoutGuide?
    private var navigationBar: UINavigationBar?
    private var currentlyDisplayedWalkingRoutes: [MKPolyline] = []
    private var currentlyDisplayedEndpoints: [EndpointAnnotation] = []
    private var currentlyDisplayedPartialPattern: [BusRouteOverlay] = []
    private var currentlyDisplayedPartialStops: [MKAnnotation] = []
    private var currentlyDisplayedPattern: BusRouteOverlay?
    private var currentlyDisplayedStops: [MKAnnotation]?
    private var currentlyDisplayedColor: UIColor?
    private var currentlyDisplayedBuses: [BusAnnotation]?
    private var currentlyDisplayedLocations: [MKAnnotation]?
    private var longitudeDelta: Double?
    private var latitudeDelta: Double?
    private var activityIndicator: UIActivityIndicatorView?
    private var menuFpc: FloatingPanelController?
    private var locationsFpc: FloatingPanelController?
    private var directionsFpc: FloatingPanelController?
    private var busInfoFpc: FloatingPanelController?
    deinit {NotificationCenter.default.removeObserver(self)}
    //MARK: - life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
//        setUpActivityIndicator()
//        registerKeyboardNotification()
//        registerCollapseNotification()
//        registerClearNotification()
//        setUpRouteGenerator()
//        configureLocationManager()
    }
    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeScreenMenu = storyboard.instantiateViewController(withIdentifier: "HomeScreenMenuViewController")
        present(homeScreenMenu, animated: false)
    }
    //MARK: - Configure location manager
//    func configureLocationManager() {
//        LocationManager.shared.delegate = self
//        LocationManager.shared.startUpdatingLocation()
//    }
    //MARK: - Register the keyboard notification
//    func registerKeyboardNotification() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardIsDisplayedOnScreen), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(editingDidBegin), name: Notification.Name("didBeginEditing"), object: nil)
//    }
    //MARK: - Register collapse notification
//    func registerCollapseNotification() {
//        NotificationCenter.default.addObserver(self, selector: #selector(dismissMenu), name: Notification.Name(rawValue: "collapseMenu"), object: nil)
//    }
//    //MARK: - this is used to rid the map of the displayed notifications
//    func registerClearNotification() {
//        NotificationCenter.default.addObserver(self, selector: #selector(clearDisplayedLocationFromMap), name: Notification.Name("clearLocationsFromMap"), object: nil)
//    }
//    //MARK: - setup route generator
//    func setUpRouteGenerator(){
//        RouteGenerator.shared.progressDelegate = self
//    }
    //MARK: - layout subviews of main view
    func layoutSubviews() {
   
    setupMap()
    setupButtons()
        // configure the homeScreenMenu view
        
        
        
       
        
        //                                    homeScreenMenu.pathDelegate = self
        //                                    homeScreenMenu.locationIdentifierDelegate = self
        //                                    homeScreenMenu.routeDisplayerDelegate = self
        //                                    homeScreenMenu.map = map
        //                                    RouteGenerator.shared.alertDelegate = homeScreenMenu
        //                                    menuFpc.set(contentViewController: homeScreenMenu)
        //                                    menuFpc.track(scrollView: homeScreenMenu.allRoutesTableView)
        
        //                                self.view.addSubview(menuFpc.view)
        //                                menuFpc.view.frame = self.view.bounds
        //                                menuFpc.view.translatesAutoresizingMaskIntoConstraints = false
        // add constraints
        //                                menuFpc.view.topAnchor.constraint(equalTo: superViewMargins.topAnchor).isActive = true
        //                                menuFpc.view.bottomAnchor.constraint(equalTo: superViewMargins.bottomAnchor).isActive = true
        //                                menuFpc.view.leadingAnchor.constraint(equalTo: superViewMargins.leadingAnchor).isActive = true
        //                                menuFpc.view.trailingAnchor.constraint(equalTo: superViewMargins.trailingAnchor).isActive = true
        //                                // add to controller hierarchy
        //                                self.addChild(menuFpc)
        //                                // show
        //                                menuFpc.show(animated: false) {
        //                                    menuFpc.didMove(toParent: self)
        //                                }
        
        
        
        
        
    }
}

//MARK: - handle the map and creating patterns and points
//extension HomeScreenViewController: PathMakerDelegate, MKMapViewDelegate{
//    // use this to display walking routes on the map
//    func displayWalkingRoutes(route: MKPolyline){
//        if let map = map, let fpc = menuFpc {
//            if !currentlyDisplayedWalkingRoutes.isEmpty {
//                self.currentlyDisplayedWalkingRoutes.append(route)
//                DispatchQueue.main.async {
//                    map.addOverlay(route)
//                }
//                if currentlyDisplayedWalkingRoutes.count == 2 {
//                    let union = currentlyDisplayedWalkingRoutes[0].boundingMapRect.union(currentlyDisplayedWalkingRoutes[1].boundingMapRect)
//                    DispatchQueue.main.async{
//                        map.setVisibleMapRect(union, edgePadding: UIEdgeInsets(top: 25, left: 25, bottom: fpc.surfaceView.frame.height * (1/7), right: 25), animated: true)
//                    }
//                } else if currentlyDisplayedWalkingRoutes.count == 3 {
//                    let union = currentlyDisplayedWalkingRoutes[0].boundingMapRect.union(currentlyDisplayedWalkingRoutes[1].boundingMapRect).union(currentlyDisplayedWalkingRoutes[2].boundingMapRect)
//                    DispatchQueue.main.async {
//                        map.setVisibleMapRect(union, edgePadding: UIEdgeInsets(top: 25, left: 25, bottom: fpc.surfaceView.frame.height * (1/7), right: 25), animated: true)
//                    }
//                }
//            } else {
//                self.currentlyDisplayedWalkingRoutes = [route]
//                DispatchQueue.main.async {
//                    map.addOverlay(route)
//                    map.setVisibleMapRect(route.boundingMapRect,edgePadding: UIEdgeInsets(top: 25, left: 25, bottom: fpc.surfaceView.frame.height * (1/7), right: 25), animated: true)
//                }
//            }
//        }
//    }
//    // use this to display endpoints on the map
//    func displayEndPoints(start: Location, end: Location){
//        if let map = map{
//            let startAnnotation = EndpointAnnotation()
//            startAnnotation.coordinate = start.location
//            startAnnotation.title = "Start"
//            let endAnnotation = EndpointAnnotation()
//            endAnnotation.title = "End"
//            endAnnotation.coordinate = end.location
//            DispatchQueue.main.async {
//                map.addAnnotations([startAnnotation, endAnnotation])
//                self.currentlyDisplayedEndpoints.append(startAnnotation)
//                self.currentlyDisplayedEndpoints.append(endAnnotation)
//            }
//        }
//    }
//    // use this to display partial routes on the map
//    func displayPartialRouteOnMap(color: UIColor, points: [BusPattern], startStop: BusStop, endStop: BusStop) {
//        var wayPoints: [CLLocationCoordinate2D] = []
//        for point in points {
//            wayPoints.append(point.location)
//        }
//        var stopAnnotations: [MKAnnotation] = []
//        let startStopAnnotation = MKPointAnnotation()
//        startStopAnnotation.coordinate = startStop.location
//        startStopAnnotation.title = startStop.name
//        startStopAnnotation.subtitle = startStop.isTimePoint ? "Time Point":"Waypoint"
//        let endStopAnnotation = MKPointAnnotation()
//        endStopAnnotation.coordinate = endStop.location
//        endStopAnnotation.title = endStop.name
//        endStopAnnotation.subtitle = endStop.isTimePoint ? "Time Point":"Waypoint"
//        stopAnnotations.append(startStopAnnotation)
//        stopAnnotations.append(endStopAnnotation)
//        if let map = map, let fpc = menuFpc {
//            if !currentlyDisplayedPartialStops.isEmpty && !currentlyDisplayedPartialPattern.isEmpty, let _ = currentlyDisplayedColor {
//                let openLine = BusRouteOverlay(coordinates: wayPoints, count: wayPoints.count)
//                self.currentlyDisplayedColor = color
//                self.currentlyDisplayedPartialPattern.append(openLine)
//                self.currentlyDisplayedPartialStops.append(contentsOf: stopAnnotations)
//                DispatchQueue.main.async {
//                    map.addOverlay(openLine)
//                    map.addAnnotations(stopAnnotations)
//                    // change the region
//                    let union = self.currentlyDisplayedPartialPattern[0].boundingMapRect.union(self.currentlyDisplayedPartialPattern[1].boundingMapRect)
//                    map.setVisibleMapRect(union, edgePadding: UIEdgeInsets(top: 25, left: 25, bottom: fpc.surfaceView.frame.height * (1/7), right: 25), animated: true)
//                }
//            } else {
//                let openLine = BusRouteOverlay(coordinates: wayPoints, count: wayPoints.count)
//                self.currentlyDisplayedPartialStops = stopAnnotations
//                self.currentlyDisplayedPartialPattern = [openLine]
//                self.currentlyDisplayedColor = color
//                DispatchQueue.main.async {
//                    map.addOverlay(openLine)
//                    map.addAnnotations(stopAnnotations)
//                    // change the region
//                    map.setVisibleMapRect(openLine.boundingMapRect, edgePadding: UIEdgeInsets(top: 25, left: 10, bottom: fpc.surfaceView.frame.height * (1/7), right: 10), animated: true)
//                }
//            }
//        }
//    }
//    // this displays the buttern pattern and stops
//    func displayBusRouteOnMap(color: UIColor, points: [BusPattern], stops: [BusStop], route: BusRoute) {
//        self.showBusInformationPanel(route: route)
//        var wayPoints: [CLLocationCoordinate2D] = []
//        for point in points {
//            wayPoints.append(point.location)
//        }
//        var stopAnnotations: [MKAnnotation] = []
//        for stop in stops {
//            let stopAnnotation = MKPointAnnotation()
//            stopAnnotation.coordinate = stop.location
//            stopAnnotation.title = stop.name
//            stopAnnotation.subtitle = stop.isTimePoint ? "Time Point":"Waypoint"
//            stopAnnotations.append(stopAnnotation)
//        }
//        if let map = map, let fpc = menuFpc {
//            if let currentlyDisplayedPattern = currentlyDisplayedPattern, let currentlyDisplayedStops = currentlyDisplayedStops, let _ = currentlyDisplayedColor {
//                DispatchQueue.main.async {
//                    map.removeAnnotations(currentlyDisplayedStops)
//                    map.removeOverlay(currentlyDisplayedPattern)
//                }
//                let boundedLine = BusRouteOverlay(coordinates: wayPoints, count: wayPoints.count)
//                self.currentlyDisplayedColor = color
//                self.currentlyDisplayedPattern = boundedLine
//                self.currentlyDisplayedStops = stopAnnotations
//                DispatchQueue.main.async {
//                    map.addOverlay(boundedLine)
//                    map.addAnnotations(stopAnnotations)
//                    // change the region of the map based on currently displayed bus route
//                    map.setVisibleMapRect(boundedLine.boundingMapRect, edgePadding: UIEdgeInsets(top: 25, left: 10, bottom: fpc.surfaceView.frame.height * (1/8), right: 10), animated: true)
//                }
//            }
//            else {
//                let boundedLine = BusRouteOverlay(coordinates: wayPoints, count: wayPoints.count)
//                self.currentlyDisplayedPattern = boundedLine
//                self.currentlyDisplayedColor = color
//                self.currentlyDisplayedStops = stopAnnotations
//                DispatchQueue.main.async {
//                    map.addOverlay(boundedLine)
//                    map.addAnnotations(stopAnnotations)
//                    // change the region of the map based on currently displayed bus route
//                    map.setVisibleMapRect(boundedLine.boundingMapRect, edgePadding: UIEdgeInsets(top: 25, left: 10, bottom: fpc.surfaceView.frame.height * (1/8), right: 10), animated: true)
//                }
//            }
//        }
//    }
//
//    // this returns an appropriate renderer for overlay
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if overlay.isKind(of: BusRouteOverlay.self) {
//            if let _ = currentlyDisplayedPattern, let color = currentlyDisplayedColor {
//                let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
//                renderer.lineWidth = 5
//                renderer.strokeColor = color
//                renderer.alpha = 1.0
//                return renderer
//            }
//            else if !currentlyDisplayedPartialPattern.isEmpty, let color = currentlyDisplayedColor {
//                let renderer = MKPolylineRenderer(overlay: overlay)
//                renderer.lineWidth = 8
//                renderer.strokeColor = color
//                renderer.alpha = 1.0
//                return renderer
//            }
//        }
//        else {
//            let renderer = MKPolylineRenderer(overlay: overlay)
//            renderer.lineWidth = 4.5
//            renderer.strokeColor = .systemBlue
//            renderer.lineCap = .round
//            renderer.lineDashPattern = [0.1,9]
//            renderer.alpha = 1.0
//
//            return renderer
//        }
//        return MKOverlayRenderer()
//    }
//    // this provides the annotation view
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation.isKind(of: MKUserLocation.self) {
//            return nil
//        }
//        if annotation.isKind(of: BusAnnotation.self), let annotation = annotation as? BusAnnotation, let direction = annotation.direction {
//            let view = MKAnnotationView()
//            view.image = UIImage(named: "bus")?.rotate(radians: rad(direction-mapView.camera.heading))
//            view.canShowCallout = true
//
//            return view
//        }
//
//        else if annotation.isKind(of: EndpointAnnotation.self), let annotation = annotation as? EndpointAnnotation {
//            let view = MKMarkerAnnotationView()
//            view.markerTintColor = annotation.title == "Start" ? .systemGreen:.systemRed
//            view.displayPriority = .required
//            return view
//        }
//        else if annotation.isKind(of: LocationAnnotation.self) {
//            let view = MKMarkerAnnotationView()
//            view.canShowCallout = true
//            view.clusteringIdentifier = "cluster"
//            return view
//        }
//        else if annotation.isKind(of: MKClusterAnnotation.self) {
//            return MKMarkerAnnotationView()
//        }
//        else if annotation.isKind(of: MKPointAnnotation.self) {
//            if let currentlyDisplayedColor = currentlyDisplayedColor {
//                let view = MKPinAnnotationView()
//                view.canShowCallout = true
//                view.pinTintColor = annotation.subtitle == "Waypoint" ? currentlyDisplayedColor:currentlyDisplayedColor.inverseColor()
//                return view
//            }
//            else {
//                return MKMarkerAnnotationView()
//            }
//        }
//        return MKMarkerAnnotationView()
//    }
//    // this displays the buses on the map
//    func displayBusesOnMap(buses: [Bus]) {
//        if let map = map {
//            if let currentlyDisplayedBuses = currentlyDisplayedBuses, let _ = currentlyDisplayedColor {
//                DispatchQueue.main.async {
//                    map.removeAnnotations(currentlyDisplayedBuses)
//                }
//                var busAnnotations:[BusAnnotation] = []
//                for bus in buses {
//                    let busAnnotation = BusAnnotation()
//                    busAnnotation.coordinate = bus.location
//                    busAnnotation.direction = bus.direction
//                    busAnnotation.title = "Route - \(bus.name)"
//                    busAnnotation.subtitle = "next stop - \(bus.nextStop)"
//                    busAnnotations.append(busAnnotation)
//                }
//                self.currentlyDisplayedBuses = busAnnotations
//                DispatchQueue.main.async {
//                    map.addAnnotations(busAnnotations)
//                }
//            } else {
//                var busAnnotations:[BusAnnotation] = []
//                for bus in buses {
//                    let busAnnotation = BusAnnotation()
//                    busAnnotation.coordinate = bus.location
//                    busAnnotation.direction = bus.direction
//                    busAnnotation.title = "Route - \(bus.name)"
//                    busAnnotation.subtitle = "next stop - \(bus.nextStop)"
//                    busAnnotations.append(busAnnotation)
//                }
//                self.currentlyDisplayedBuses = busAnnotations
//                DispatchQueue.main.async {
//                    map.addAnnotations(busAnnotations)
//                }
//            }
//        }
//    }
//
//}
////MARK: - Create methods to dismiss and present the menu
//
//extension HomeScreenViewController {
//    @objc func dismissMenu(){
//        if let fpc = menuFpc {
//            DispatchQueue.main.async {
//                fpc.move(to: .tip, animated: true)
//            }
//        }
//    }
//    @objc func presentMenu(){
//        if let fpc = menuFpc{
//            DispatchQueue.main.async {
//                fpc.move(to: .half, animated: true)
//                self.clearMap()
//                if let region = self.region, let map = self.map {
//                    map.setRegion(region, animated: false)
//                }
//            }
//
//        }
//    }
//}
////MARK: - Allow a way to deselect bus route
//extension HomeScreenViewController {
//    // this function calls all the other ones to clear stuff from the map
//    func clearMap(){
//        clearBusRoutePatternFromMap()
//        clearBusRouteStopsFromMap()
//        clearBusesFromMap()
//        clearDisplayedLocationFromMap()
//        clearPartialBusRoutePatternFromMap()
//        clearPartialBusStopsFromMap()
//        clearWalkingRoutesFromMap()
//        clearEndpointsFromMap()
//    }
//    // this function cleans the map and sets it to the default region
//    func clearBusRoutePatternFromMap(){
//        if let map = map, let _ = currentlyDisplayedColor, let currentlyDisplayedPattern = currentlyDisplayedPattern , let region = region{
//            DispatchQueue.main.async {
//                map.removeOverlay(currentlyDisplayedPattern)
//                map.setRegion(region, animated: true)
//                self.currentlyDisplayedColor = nil
//                self.currentlyDisplayedPattern = nil
//            }
//        }
//    }
//    // this function cleans the bus stops from the map
//    func clearBusRouteStopsFromMap() {
//        if let map = map, let currentlyDisplayedStops = currentlyDisplayedStops, let region = region {
//            DispatchQueue.main.async {
//                map.removeAnnotations(currentlyDisplayedStops)
//                map.setRegion(region, animated: true)
//                self.currentlyDisplayedStops = nil
//                self.currentlyDisplayedColor = nil
//            }
//        }
//    }
//    // this function cleans the buses from the map
//    func clearBusesFromMap(){
//        if let map = map, let currentlyDisplayedBuses = currentlyDisplayedBuses, let region = region {
//            DispatchQueue.main.async {
//                NotificationCenter.default.post(Notification(name: Notification.Name("invalidateTimer")))
//                map.removeAnnotations(currentlyDisplayedBuses)
//                map.setRegion(region, animated: true)
//                self.currentlyDisplayedBuses = nil
//                self.currentlyDisplayedColor = nil
//            }
//        }
//    }
//    // this function removes the currently displayed location from the map
//    @objc func clearDisplayedLocationFromMap(){
//        if let map = map, let currentlyDisplayedLocation = currentlyDisplayedLocations, let region = region {
//            DispatchQueue.main.async {
//                map.removeAnnotations(currentlyDisplayedLocation)
//                map.setRegion(region, animated: true)
//                self.currentlyDisplayedLocations = nil
//            }
//        }
//    }
//    // this function removes the currently displayed partial pattern information
//    func clearPartialBusRoutePatternFromMap() {
//        if let map = map, !currentlyDisplayedPartialPattern.isEmpty, let region = region {
//            DispatchQueue.main.async {
//                map.removeOverlays(self.currentlyDisplayedPartialPattern)
//                map.setRegion(region, animated: true)
//                self.currentlyDisplayedPartialPattern.removeAll()
//                self.currentlyDisplayedColor = nil
//            }
//        }
//    }
//    // this function removes the currently displayed partial stops
//    func clearPartialBusStopsFromMap(){
//        if let map = map, !currentlyDisplayedPartialStops.isEmpty, let region = region {
//            DispatchQueue.main.async {
//                map.removeAnnotations(self.currentlyDisplayedPartialStops)
//                map.setRegion(region, animated: true)
//                self.currentlyDisplayedPartialStops.removeAll()
//            }
//        }
//    }
//    // this function removes the currently displayed walking routes
//    func clearWalkingRoutesFromMap(){
//        if let map = map, !currentlyDisplayedWalkingRoutes.isEmpty, let region = region {
//            DispatchQueue.main.async {
//                map.removeOverlays(self.currentlyDisplayedWalkingRoutes)
//                map.setRegion(region, animated: true)
//                self.currentlyDisplayedWalkingRoutes.removeAll()
//            }
//        }
//    }
//    // this function removes the currently displayed endpoints
//    func clearEndpointsFromMap(){
//        if let map = map, !currentlyDisplayedEndpoints.isEmpty, let region = region {
//            DispatchQueue.main.async {
//                map.removeAnnotations(map.annotations)
//                map.setRegion(region, animated: true)
//                self.currentlyDisplayedEndpoints.removeAll()
//            }
//        }
//    }
//}
////MARK: - Handle Keyboard popping up on screen
//
//extension HomeScreenViewController {
//    @objc func keyboardIsDisplayedOnScreen(){
//        DispatchQueue.main.async {
//            if let fpc = self.menuFpc {
//                fpc.move(to: .full, animated: true)
//                fpc.panGestureRecognizer.isEnabled = false
//                if let directionsFpc = self.directionsFpc {
//                    directionsFpc.move(to: .full, animated: true)
//                }
//            }
//        }
//    }
//}
//
////MARK: - Handle Keyboard disappearing from screen
//extension HomeScreenViewController {
//    @objc func keyboardDidDisappear() {
//        DispatchQueue.main.async {
//            if let fpc = self.menuFpc {
//                fpc.move(to: .half, animated: true)
//                fpc.panGestureRecognizer.isEnabled = true
//            }
//        }
//    }
//}
////MARK: - Handle editing did begin
//extension HomeScreenViewController {
//    @objc func editingDidBegin() {
//        self.presentMenu()
//    }
//}
////MARK: - Handle showing search location
//extension HomeScreenViewController: SearchResultsDelegate {
//
//    func displaySearchResults(results: [Location]) {
//        self.showLocationsPanel(results: results)
//        if let map = map {
//            if let currentlyDisplayedLocations = currentlyDisplayedLocations {
//                DispatchQueue.main.async {
//                    map.removeAnnotations(currentlyDisplayedLocations)
//                }
//                var locationAnnotations:[LocationAnnotation] = []
//                for result in results {
//                    let locationAnnotation = LocationAnnotation()
//                    locationAnnotation.coordinate = result.location
//                    locationAnnotation.title = result.name
//                    locationAnnotation.subtitle = result.address
//                    locationAnnotations.append(locationAnnotation)
//                }
//                self.currentlyDisplayedLocations = locationAnnotations
//                DispatchQueue.main.async {
//                    map.addAnnotations(locationAnnotations)
//                    map.showAnnotations(locationAnnotations, animated: true)
//                }
//            } else {
//                var locationAnnotations:[LocationAnnotation] = []
//                for result in results {
//                    let locationAnnotation = LocationAnnotation()
//                    locationAnnotation.coordinate = result.location
//                    locationAnnotation.title = result.name
//                    locationAnnotation.subtitle = result.address
//                    locationAnnotations.append(locationAnnotation)
//                }
//                self.currentlyDisplayedLocations = locationAnnotations
//                DispatchQueue.main.async {
//                    map.addAnnotations(locationAnnotations)
//                    map.showAnnotations(locationAnnotations, animated: true)
//                }
//            }
//        }
//    }
//
//
//}
////MARK: - Set up activity indicator while route is generating
//extension HomeScreenViewController: RouteGenerationProgressDelegate {
//    // use this to set up the activity indicator
//    func setUpActivityIndicator() {
//        if let map = map {
//            activityIndicator = UIActivityIndicatorView(style: .large)
//            if let activityIndicator = activityIndicator {
//                // configure
//                activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//                activityIndicator.hidesWhenStopped = true
//                map.addSubview(activityIndicator)
//                // add constraints
//                mapMargins = map.safeAreaLayoutGuide
//                if let mapMargins = mapMargins {
//                    activityIndicator.centerXAnchor.constraint(equalTo: mapMargins.centerXAnchor).isActive = true
//                    activityIndicator.centerYAnchor.constraint(equalTo: mapMargins.centerYAnchor).isActive = true
//                }
//            }
//        }
//    }
//    // use this to start animating and stop animating
//    func routeGenerationDidStart() {
//        if let activityIndicator = activityIndicator {
//            activityIndicator.startAnimating()
//        }
//    }
//
//    func routeGenerationDidEnd() {
//        if let activityIndicator = activityIndicator {
//            activityIndicator.stopAnimating()
//        }
//    }
//}
////MARK: - Use this to display the route
//extension HomeScreenViewController: RouteDisplayerDelegate {
//    func displayRouteOnMap(userLocation: Location, route: [(BusRoute, BusStop)], destination: Location, routeTimes: [Date], walkDistances: [Double]) {
//        self.clearMap()
//        self.showDirectionsPanel(start: userLocation, end: destination, route: route, routeTimes: routeTimes, walkDistances: walkDistances)
//        if route.count == 0 {
//            RouteGenerator.shared.findWalkingRoute(origin: userLocation.location, destination: destination.location) { walkingPath, progressDelegate  in
//                self.displayEndPoints(start: userLocation, end: destination)
//                self.displayWalkingRoutes(route: walkingPath)
//                progressDelegate?.routeGenerationDidEnd()
//            }
//        } else if route.count == 2 {
//            // first display the start and end points
//            self.displayEndPoints(start: userLocation, end: destination)
//            let originBusStop = route[0].1
//            let destinationBusStop = route[1].1
//            let busRoute = route[0].0
//            RouteGenerator.shared.findWalkingRoute(origin: userLocation.location, destination: originBusStop.location) { walkingPath, progressDelegate in
//                // then display the walking path from user location to first bus stop
//                self.displayWalkingRoutes(route: walkingPath)
//                // then display the route from the origin bus stop to the destination bus stop
//                busRoute.delegate = self
//                busRoute.displayPartialRoute(startStop: originBusStop, endStop: destinationBusStop)
//                // finally display the route from the desination bus stop to the destination
//                RouteGenerator.shared.findWalkingRoute(origin: destinationBusStop.location, destination: destination.location) { walkingPath, progressDelegate in
//                    self.displayWalkingRoutes(route: walkingPath)
//                    progressDelegate?.routeGenerationDidEnd()
//                }
//            }
//        } else if route.count == 4 {
//            // first display the start and end points
//            self.displayEndPoints(start: userLocation, end: destination)
//            let originBusStop = route[0].1
//            let firstBusRoute = route[0].0
//            let firstViaBusStop = route[1].1
//            let secondBusRoute = route[2].0
//            let secondViaBusStop = route[2].1
//            let destinationBusStop = route[3].1
//            // find the walking route from the users location to the origin bus stop
//            RouteGenerator.shared.findWalkingRoute(origin: userLocation.location, destination: originBusStop.location) { walkingPath, progressDelegate in
//                self.displayWalkingRoutes(route: walkingPath)
//                // display the first partial route
//                firstBusRoute.delegate = self
//                firstBusRoute.displayPartialRoute(startStop: originBusStop, endStop: firstViaBusStop)
//                // display the walking path between the two bus stops
//                RouteGenerator.shared.findWalkingRoute(origin: firstViaBusStop.location, destination: secondViaBusStop.location) { walkingPath, progressDelegate in
//                    self.displayWalkingRoutes(route: walkingPath)
//                    // next display the second partial route
//                    secondBusRoute.delegate = self
//                    secondBusRoute.displayPartialRoute(startStop: secondViaBusStop, endStop: destinationBusStop)
//                    // finally display the final walking route
//                    RouteGenerator.shared.findWalkingRoute(origin: destinationBusStop.location, destination: destination.location) { walkingPath, progressDelegate in
//                        self.displayWalkingRoutes(route: walkingPath)
//                        progressDelegate?.routeGenerationDidEnd()
//                    }
//                }
//            }
//        }
//    }
//}
//
////MARK: - Conform to floating panel's delegate
//extension HomeScreenViewController: FloatingPanelControllerDelegate, FloatingPanelBehavior {
//    func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
//        if fpc == self.menuFpc {
//            if fpc.state == .tip && (targetState.pointee == .half || targetState.pointee == .full) {
//                self.clearMap()
//                if let region = self.region, let map = self.map {
//                    map.setRegion(region, animated: true)
//                }
//            }
//        }
//    }
//    func allowsRubberBanding(for edge: UIRectEdge) -> Bool {
//        true
//    }
//
//}
////MARK: - use this to show directions panel
//extension HomeScreenViewController: DirectionsPanelClosedDelegate {
//    func closeDirectionsPanel() {
//        if let directionsFpc = directionsFpc, let menuFpc = menuFpc{
//            menuFpc.surfaceView.isUserInteractionEnabled = true
//            menuFpc.surfaceView.clearsContextBeforeDrawing = true
//            menuFpc.panGestureRecognizer.isEnabled = true
//            menuFpc.show(animated: true)
//            directionsFpc.willMove(toParent: nil)
//            directionsFpc.hide(animated: true) {
//                directionsFpc.view.removeFromSuperview()
//                directionsFpc.removeFromParent()
//            }
//            self.clearMap()
//        }
//    }
//
//    func showDirectionsPanel(start: Location, end: Location, route: [(BusRoute, BusStop)], routeTimes: [Date], walkDistances: [Double]) {
//        directionsFpc = FloatingPanelController()
//        let directionsViewController = DirectionsViewController()
//        directionsViewController.endpoints = [start, end]
//        directionsViewController.delegate = self
//        directionsViewController.routeDisplayerDelegate = self
//        directionsViewController.route = route
//        directionsViewController.routeTimes = routeTimes
//        directionsViewController.walkDistances = walkDistances
//        if let directionsFpc, let menuFpc, let superViewMargins {
//            directionsFpc.set(contentViewController: directionsViewController)
//            directionsFpc.track(scrollView: directionsViewController.directionsTableView)
//            self.view.addSubview(directionsFpc.view)
//            directionsFpc.view.frame = self.view.bounds
//            directionsFpc.view.translatesAutoresizingMaskIntoConstraints = false
//            // add constraints
//            directionsFpc.view.topAnchor.constraint(equalTo: superViewMargins.topAnchor).isActive = true
//            directionsFpc.view.bottomAnchor.constraint(equalTo: superViewMargins.bottomAnchor).isActive = true
//            directionsFpc.view.leadingAnchor.constraint(equalTo: superViewMargins.leadingAnchor).isActive = true
//            directionsFpc.view.trailingAnchor.constraint(equalTo: superViewMargins.trailingAnchor).isActive = true
//            // add as child
//            self.addChild(directionsFpc)
//            // show
//            directionsFpc.show(animated: true) {
//                directionsFpc.didMove(toParent: self)
//            }
//            directionsFpc.move(to: .tip, animated: true)
//            let appearance = SurfaceAppearance()
//            appearance.cornerRadius = 15
//            appearance.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//            directionsFpc.surfaceView.appearance = appearance
//            menuFpc.hide(animated: true)
//            menuFpc.panGestureRecognizer.isEnabled = false
//            menuFpc.surfaceView.isUserInteractionEnabled = false
//        }
//    }
//}
////MARK: - use this to show the locations pane
//
//extension HomeScreenViewController: SearchResultsPanelClosedDelegate {
//    func closeSearchResultsPanel() {
//        if let menuFpc = menuFpc{
//            hideLocationsPanel()
//            menuFpc.surfaceView.isUserInteractionEnabled = true
//            menuFpc.panGestureRecognizer.isEnabled = true
//            menuFpc.show(animated: true)
//        }
//    }
//
//    func showLocationsPanel(results: [Location]) {
//        locationsFpc = FloatingPanelController()
//        let searchResultsViewController = SearchResultsViewController()
//        searchResultsViewController.searchResults = results
//        searchResultsViewController.routeDisplayerDelegate = self
//        searchResultsViewController.closeDelegate = self
//        if let locationsFpc, let menuFpc, let superViewMargins, let homeScreenMenu {
//            searchResultsViewController.refreshDelegate = homeScreenMenu
//            locationsFpc.set(contentViewController: searchResultsViewController)
//            locationsFpc.track(scrollView: searchResultsViewController.tableView)
//            self.view.addSubview(locationsFpc.view)
//            locationsFpc.view.frame = self.view.bounds
//            locationsFpc.view.translatesAutoresizingMaskIntoConstraints = false
//            // add constraints
//            locationsFpc.view.topAnchor.constraint(equalTo: superViewMargins.topAnchor).isActive = true
//            locationsFpc.view.bottomAnchor.constraint(equalTo: superViewMargins.bottomAnchor).isActive = true
//            locationsFpc.view.leadingAnchor.constraint(equalTo: superViewMargins.leadingAnchor).isActive = true
//            locationsFpc.view.trailingAnchor.constraint(equalTo: superViewMargins.trailingAnchor).isActive = true
//            // add as child
//            self.addChild(locationsFpc)
//            // show
//            locationsFpc.show(animated: true) {
//                locationsFpc.didMove(toParent: self)
//            }
//            let appearance = SurfaceAppearance()
//            appearance.cornerRadius = 15
//            appearance.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//            locationsFpc.surfaceView.appearance = appearance
//            menuFpc.hide(animated: true)
//            menuFpc.panGestureRecognizer.isEnabled = false
//            menuFpc.surfaceView.isUserInteractionEnabled = false
//        }
//    }
//    func hideLocationsPanel(){
//        if let locationsFpc {
//            locationsFpc.willMove(toParent: nil)
//            locationsFpc.hide(animated: true) {
//                locationsFpc.view.removeFromSuperview()
//                locationsFpc.removeFromParent()
//            }
//        }
//    }
//}
////MARK: - Use to show bus info panel
//extension HomeScreenViewController: BusInformationPanelClosedDelegate {
//    func closeBusInformationPanel() {
//        if let busInfoFpc, let menuFpc {
//            menuFpc.surfaceView.isUserInteractionEnabled = true
//            menuFpc.panGestureRecognizer.isEnabled = true
//            menuFpc.show(animated: true)
//            busInfoFpc.willMove(toParent: nil)
//            busInfoFpc.hide(animated: true) {
//                busInfoFpc.view.removeFromSuperview()
//                busInfoFpc.removeFromParent()
//            }
//            self.clearMap()
//        }
//    }
//
//    func showBusInformationPanel(route: BusRoute) {
//        busInfoFpc = FloatingPanelController()
//        let busInformationViewController = BusInformationViewController()
//        busInformationViewController.busNumber = route.number
//        busInformationViewController.busName = route.name
//        busInformationViewController.busColor = route.color
//        busInformationViewController.timeTable = route.timeTable
//        busInformationViewController.closeDelegate = self
//        busInformationViewController.favorited = route.isFavorited
//        if let busInfoFpc, let menuFpc, let superViewMargins, let homeScreenMenu {
//            busInformationViewController.refreshDelegate = homeScreenMenu
//            busInfoFpc.set(contentViewController: busInformationViewController)
//            self.view.addSubview(busInfoFpc.view)
//            busInfoFpc.view.frame = self.view.bounds
//            busInfoFpc.view.translatesAutoresizingMaskIntoConstraints = false
//            // add constraints
//            busInfoFpc.view.topAnchor.constraint(equalTo: superViewMargins.topAnchor).isActive = true
//            busInfoFpc.view.bottomAnchor.constraint(equalTo: superViewMargins.bottomAnchor).isActive = true
//            busInfoFpc.view.leadingAnchor.constraint(equalTo: superViewMargins.leadingAnchor).isActive = true
//            busInfoFpc.view.trailingAnchor.constraint(equalTo: superViewMargins.trailingAnchor).isActive = true
//            // add as child
//            self.addChild(busInfoFpc)
//            //  show
//            busInfoFpc.show(animated: true) {
//                busInfoFpc.didMove(toParent: self)
//            }
//            busInfoFpc.move(to: .tip, animated: true)
//            let appearance = SurfaceAppearance()
//            appearance.cornerRadius = 15
//            appearance.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//            busInfoFpc.surfaceView.appearance = appearance
//            menuFpc.hide(animated: true)
//            menuFpc.panGestureRecognizer.isEnabled = false
//            menuFpc.surfaceView.isUserInteractionEnabled = false
//        }
//    }
//}
////MARK: - deal with location data
//extension HomeScreenViewController: CLLocationManagerDelegate {
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        let authorizationStatus: CLAuthorizationStatus
//        if #available(iOS 14, *) {
//            authorizationStatus = manager.authorizationStatus
//        } else {
//            authorizationStatus = CLLocationManager.authorizationStatus()
//        }
//        switch authorizationStatus {
//        case .authorizedAlways:
//            manager.startUpdatingLocation()
//            break
//        case .restricted, .denied:
//            manager.requestWhenInUseAuthorization()
//            break
//        case .notDetermined:
//            manager.requestWhenInUseAuthorization()
//            break
//        default:
//            break
//        }
//
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            LocationManager.shared.currentLocation = location
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//
//    }
//}
