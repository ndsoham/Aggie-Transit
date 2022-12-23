//
//  HomeScreenViewController2.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/25/22.
//

import Foundation
import UIKit
import MapKit

class HomeScreenViewController: UIViewController {
    private var safeAreaHeight:Double?
    private var height: Double?
    private var width: Double?
    private var buttonSpacing = 0.0
    private var fabHeight: Double?
    private var fabWidth: Double?
    private var map: MKMapView?
    private var superViewMargins: UILayoutGuide?
    private var homeScreenNotificationsFAB: HomeScreenFAB?
    private var homeScreenSettingsFAB: HomeScreenFAB?
    private var buttonStack: UIStackView?
    private var mapMargins: UILayoutGuide?
    private var homeScreenMenu: HomeScreenMenuView?
    private var homeScreenMenuHeight: Double?
    private var homeScreenMenuWidth: Double?
    private var animationDuration:TimeInterval = 0.5
    private var navigationBar: UINavigationBar?
    private var currentDisplayedRoute: MKPolyline?
    private var longitudeDelta: Double?
    private var latitudeDelta: Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        // hide the navigation bar
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(true, animated: false)
        }
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        // show the navigation bar
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(false, animated: true)
        }
        super.viewWillDisappear(animated)
    }
    func layoutSubviews() {
        // configure navigation bar
        if let navigationBar = navigationController?.navigationBar, let _ = navigationController {
            navigationBar.barTintColor = UIColor(named: "textColor")
            navigationBar.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
            navigationBar.prefersLargeTitles = true
        }
        // decide the height and width of items based on view size
        safeAreaHeight = self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top
        if let safeAreaHeight = safeAreaHeight{
            height = self.view.frame.height - safeAreaHeight
            width = self.view.frame.width
            if let height = height, let width = width{
                buttonSpacing = 7.15 * (height/812)
                
                // configure super view backbround
                self.view.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                // configure the map
                map = MKMapView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                longitudeDelta = 0.0125
                latitudeDelta = 0.0125
                if let map = map, let longitudeDelta = longitudeDelta, let latitudeDelta = latitudeDelta{
                    // configure the map
                    map.delegate = self
                    map.translatesAutoresizingMaskIntoConstraints = false
                    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.614965, longitude: -96.340584), span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
                    map.setRegion(region, animated: false)
                    // add the map to the view hierarchy
                    self.view.addSubview(map)
                    // constrain the map
                    superViewMargins = self.view.safeAreaLayoutGuide
                    if let superViewMargins = superViewMargins {
                        map.leadingAnchor.constraint(equalTo: superViewMargins.leadingAnchor).isActive = true
                        map.trailingAnchor.constraint(equalTo: superViewMargins.trailingAnchor).isActive = true
                        map.topAnchor.constraint(equalTo: superViewMargins.topAnchor).isActive = true
                        map.bottomAnchor.constraint(equalTo: superViewMargins.bottomAnchor).isActive = true
                    }
                    
                    // configure the buttons
                    buttonStack = UIStackView()
                    if let buttonStack = buttonStack{
                        fabHeight = 54.85 * (height/812)
                        fabWidth = fabHeight
                        if let fabHeight = fabHeight, let fabWidth  = fabWidth{
                            // configure settings button
                            homeScreenSettingsFAB = HomeScreenFAB(frame:  CGRect(x: 0, y: 0, width: fabWidth, height: fabHeight), backgroundImage: .settings, buttonName: .settings)
                            if let homeScreenSettingsFAB = homeScreenSettingsFAB{
                                homeScreenSettingsFAB.translatesAutoresizingMaskIntoConstraints = false
                                // constrain settings button
                                homeScreenSettingsFAB.widthAnchor.constraint(equalToConstant: fabWidth).isActive = true
                                homeScreenSettingsFAB.heightAnchor.constraint(equalToConstant: fabHeight).isActive = true
                            }
                            // configure notifications button
                            homeScreenNotificationsFAB = HomeScreenFAB(frame: CGRect(x: 0, y: 0, width: fabWidth, height: fabHeight), backgroundImage: .notifications, buttonName: .notifications)
                            if let homeScreenNotificationsFAB = homeScreenNotificationsFAB, let homeScreenSettingsFAB = homeScreenSettingsFAB{
                                homeScreenNotificationsFAB.translatesAutoresizingMaskIntoConstraints = false
                                // constrain the notifications button
                                homeScreenNotificationsFAB.widthAnchor.constraint(equalToConstant: fabWidth).isActive = true
                                homeScreenNotificationsFAB.heightAnchor.constraint(equalToConstant: fabHeight).isActive = true
                                // add event handlers to the buttons
                                homeScreenSettingsFAB.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
                                homeScreenNotificationsFAB.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
                                // add the buttons to a stackview
                                buttonStack.addArrangedSubview(homeScreenNotificationsFAB)
                                buttonStack.addArrangedSubview(homeScreenSettingsFAB)
                            }
                        }
                        // configure the stackview
                        buttonStack.axis = .vertical
                        buttonStack.spacing = buttonSpacing
                        buttonStack.alignment = .center
                        buttonStack.translatesAutoresizingMaskIntoConstraints = false
                        // add the button stack to the view hierarchy
                        map.addSubview(buttonStack)
                        // constrain the button stack
                        mapMargins = map.safeAreaLayoutGuide
                        if let mapMargins = mapMargins{
                            buttonStack.trailingAnchor.constraint(equalTo: mapMargins.trailingAnchor, constant: -10).isActive = true
                            buttonStack.topAnchor.constraint(equalTo: mapMargins.topAnchor,constant: 10).isActive = true
                        }
                    }
                    // configure home screen menu view
                    homeScreenMenuHeight = 225 * (height/812)
                    homeScreenMenuWidth = width
                    if let homeScreenMenuWidth = homeScreenMenuWidth, let homeScreenMenuHeight = homeScreenMenuHeight{
                        homeScreenMenu = HomeScreenMenuView(frame: CGRect(x: 0, y: 0, width: homeScreenMenuWidth, height: homeScreenMenuHeight))
                        if let homeScreenMenu = homeScreenMenu {
                            homeScreenMenu.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                            homeScreenMenu.translatesAutoresizingMaskIntoConstraints = false
                            homeScreenMenu.pathDelegate = self
                            // add the home screen menu to the view hierarchy
                            map.addSubview(homeScreenMenu)
                            // constrain the home screen menu
                            if let mapMargins = mapMargins {
                                homeScreenMenu.leadingAnchor.constraint(equalTo: mapMargins.leadingAnchor).isActive = true
                                homeScreenMenu.trailingAnchor.constraint(equalTo: mapMargins.trailingAnchor).isActive = true
                                homeScreenMenu.bottomAnchor.constraint(equalTo: mapMargins.bottomAnchor).isActive = true
                                homeScreenMenu.heightAnchor.constraint(equalToConstant: homeScreenMenuHeight).isActive = true
                            }
                        }
                    }
                    
                }
            }
           
           
        }
        
    }
    @objc func handleButtonPress(sender: HomeScreenFAB) {
        if sender.buttonName.rawValue == "Settings Button"{
            presentSettingsScreen()
        }
        
        else if sender.buttonName.rawValue == "Notifications Button" {
            presentNotificationsScreen()
        }
        else {
            print("An error has occured")
        }
    }
    func presentSettingsScreen() {
        if let navigationController = navigationController{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsScreenViewController") as! SettingsScreenViewController
            navigationController.pushViewController(settingsViewController, animated: true)
        }
    }
    func presentNotificationsScreen() {
        if let navigationController = navigationController{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let notificationsViewController = storyboard.instantiateViewController(withIdentifier: "NotificationsScreenViewController") as! NotificationsScreenViewController
            navigationController.pushViewController(notificationsViewController, animated: true)
        }
    }
}


extension HomeScreenViewController: PathMakerDelegate, MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = UIColor(named: cellBackgroundColor.bonfirePurple.rawValue)
            renderer.lineWidth = 3
            return renderer
        }
        fatalError("Overlay is of the wrong type")
    }
   
    func didGatherStopPoints(stops: [CLLocationCoordinate2D]) {
        if let map = map, let longitudeDelta = longitudeDelta, let latitudeDelta = latitudeDelta {
            if let currentDisplayedRoute = currentDisplayedRoute {
                DispatchQueue.main.async {
                    map.removeOverlay(currentDisplayedRoute)
                }
                let boundedLine = MKPolyline(coordinates: stops, count: stops.count)
                
                self.currentDisplayedRoute = boundedLine
                DispatchQueue.main.async {
                    map.addOverlay(boundedLine)
                    // change the region of the map based on currently displayed bus route
                    let region = MKCoordinateRegion(center: boundedLine.coordinate, span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
                    map.setRegion(region, animated: true)
                }
            }
            else {
                let boundedLine = MKPolyline(coordinates: stops, count: stops.count)
                currentDisplayedRoute = boundedLine
                DispatchQueue.main.async {
                    map.addOverlay(boundedLine)
                    // change the region of the map based on currently displayed bus route
                    let region = MKCoordinateRegion(center: boundedLine.coordinate, span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
                    map.setRegion(region, animated: true)
                }
            }
        }
    }
    
    
}

