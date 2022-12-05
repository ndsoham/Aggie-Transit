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
    var safeAreaHeight:Double?
    var height: Double?
    var width: Double?
    var buttonSpacing = 0.0
    var fabHeight: Double?
    var fabWidth: Double?
    var map: MKMapView?
    var superViewMargins: UILayoutGuide?
    var homeScreenNotificationsFAB: HomeScreenFAB?
    var homeScreenSettingsFAB: HomeScreenFAB?
    let buttonStack = UIStackView()
    var mapMargins: UILayoutGuide?
    var homeScreenMenu: HomeScreenMenuView?
    var homeScreenMenuHeight: Double?
    var homeScreenMenuWidth: Double?
    private var animationDuration:TimeInterval = 0.5
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
    }
    func layoutSubviews() {
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
                if let map = map{
                    map.translatesAutoresizingMaskIntoConstraints = false
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
                }
                // configure the buttons
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
                map?.addSubview(buttonStack)
                // constrain the button stack
                mapMargins = map?.safeAreaLayoutGuide
                if let mapMargins = mapMargins{
                    buttonStack.trailingAnchor.constraint(equalTo: mapMargins.trailingAnchor, constant: -10).isActive = true
                    buttonStack.topAnchor.constraint(equalTo: mapMargins.topAnchor,constant: 10).isActive = true
                }
                // configure home screen menu view
                homeScreenMenuHeight = 200 * (height/812)
                homeScreenMenuWidth = width
                if let homeScreenMenuWidth = homeScreenMenuWidth, let homeScreenMenuHeight = homeScreenMenuHeight{
                    homeScreenMenu = HomeScreenMenuView(frame: CGRect(x: 0, y: 0, width: homeScreenMenuWidth, height: homeScreenMenuHeight))
                    if let homeScreenMenu = homeScreenMenu {
                        homeScreenMenu.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                        homeScreenMenu.translatesAutoresizingMaskIntoConstraints = false
                        // add the home screen menu to the view hierarchy
                        map?.addSubview(homeScreenMenu)
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsScreenViewController")
        settingsViewController.modalPresentationStyle = .custom
        settingsViewController.transitioningDelegate = self
        self.present(settingsViewController, animated: false)
    }
    func presentNotificationsScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let notificationsViewController = storyboard.instantiateViewController(withIdentifier: "NotificationsScreenViewController")
        notificationsViewController.modalPresentationStyle = .custom
        notificationsViewController.transitioningDelegate = self
        self.present(notificationsViewController, animated: false)
    }
}

extension HomeScreenViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        let bounds = containerView.bounds
        toView.frame = bounds.offsetBy(dx: bounds.width, dy: 0)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animationDuration, delay: 0, options: .curveEaseIn) {
            toView.frame = bounds
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

