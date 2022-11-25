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
    var safeAreaHeight = 0.0
    var safeAreaWidth = 0.0
    var height = 0.0
    var width = 0.0
    var buttonSpacing = 0.0
    var fabHeight = 0.0
    var fabWidth = 0.0
    let map = MKMapView()
    var superViewMargins = UILayoutGuide()
    let homeScreenNotificationsFAB = HomeScreenFAB(frame: CGRect(), backgroundImage: .notifications, buttonName: .notifications)
    let homeScreenSettingsFAB = HomeScreenFAB(frame: CGRect(), backgroundImage: .settings, buttonName: .settings)
    let buttonStack = UIStackView()
    var mapMargins = UILayoutGuide()
    let homeScreenMenu = UIView()
    var homeScreenMenuHeight = 0.0
    var homeScreenMenuWidth = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
    }
    func layoutSubviews() {
        // decide the height and width of items based on view size
        safeAreaHeight = self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top
        safeAreaWidth = self.view.safeAreaInsets.left + self.view.safeAreaInsets.right
        height = self.view.frame.height - safeAreaHeight
        width = self.view.frame.width - safeAreaWidth
        buttonSpacing = 7.15 * (812/height)
        // configure super view backbround
        self.view.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        // configure the map
        map.frame = CGRect(x: 0, y: 0, width: width, height: height)
        map.translatesAutoresizingMaskIntoConstraints = false
        // add the map to the view hierarchy
        self.view.addSubview(map)
        // constrain the map
        superViewMargins = self.view.safeAreaLayoutGuide
        map.leadingAnchor.constraint(equalTo: superViewMargins.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: superViewMargins.trailingAnchor).isActive = true
        map.topAnchor.constraint(equalTo: superViewMargins.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: superViewMargins.bottomAnchor).isActive = true
        // configure the buttons
        fabHeight = 54.85 * (812/height)
        fabWidth = fabHeight
            // configure settings button
        homeScreenSettingsFAB.frame = CGRect(x: 0, y: 0, width: fabWidth, height: fabHeight)
        homeScreenSettingsFAB.translatesAutoresizingMaskIntoConstraints = false
            // constrain settings button
        homeScreenSettingsFAB.widthAnchor.constraint(equalToConstant: fabWidth).isActive = true
        homeScreenSettingsFAB.heightAnchor.constraint(equalToConstant: fabHeight).isActive = true
            // configure notifications button
        homeScreenNotificationsFAB.frame = CGRect(x: 0, y: 0, width: fabWidth, height: fabHeight)
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
        // configure the stackview
        buttonStack.axis = .vertical
        buttonStack.spacing = buttonSpacing
        buttonStack.alignment = .center
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        // add the button stack to the view hierarchy
        map.addSubview(buttonStack)
        // constrain the button stack
        mapMargins = map.safeAreaLayoutGuide
        buttonStack.trailingAnchor.constraint(equalTo: mapMargins.trailingAnchor, constant: -10).isActive = true
        buttonStack.topAnchor.constraint(equalTo: mapMargins.topAnchor,constant: 10).isActive = true
        // configure home screen menu view
        homeScreenMenuHeight = 200 * (812/height)
        homeScreenMenuWidth = width
        homeScreenMenu.frame = CGRect(x: 0, y: height-homeScreenMenuHeight, width: homeScreenMenuWidth, height: homeScreenMenuHeight)
        homeScreenMenu.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        homeScreenMenu.translatesAutoresizingMaskIntoConstraints = false
        // add the home screen menu to the view hierarchy
        map.addSubview(homeScreenMenu)
        // constrain the home screen menu
        homeScreenMenu.trailingAnchor.constraint(equalTo: mapMargins.trailingAnchor).isActive = true
        homeScreenMenu.leadingAnchor.constraint(equalTo: mapMargins.leadingAnchor).isActive = true
        homeScreenMenu.bottomAnchor.constraint(equalTo: mapMargins.bottomAnchor).isActive = true
        homeScreenMenu.widthAnchor.constraint(equalToConstant: homeScreenMenuWidth).isActive = true
        homeScreenMenu.heightAnchor.constraint(equalToConstant: homeScreenMenuHeight).isActive = true
        
        
        
        
        
        
        
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
        print("implement this method")
    }
    func presentNotificationsScreen() {
        print("implement this method")
    }
}
