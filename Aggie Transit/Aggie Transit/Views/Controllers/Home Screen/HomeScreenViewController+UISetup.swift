//
//  HomeScreenViewController+UISetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/26/23.
//

import Foundation
import UIKit
import MapKit

extension HomeScreenViewController {
    //MARK: - setup map
    func setupMap() {
        // configure the map
//        map.delegate = self
        map.translatesAutoresizingMaskIntoConstraints = false
        map.setRegion(region, animated: false)
        map.showsCompass = false
        map.showsUserLocation = true
        // add the map to the view hierarchy
        self.view.addSubview(map)
        // constrain the map
        NSLayoutConstraint.activate([
            map.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            map.topAnchor.constraint(equalTo: self.view.topAnchor),
            map.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    //MARK: - setup buttons
    func setupButtons() {
        // configure stack view
        buttonStack.axis = .vertical
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.spacing = 6
        // add to view hierarchy
        self.view.addSubview(buttonStack)
        // constrain
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            buttonStack.rightAnchor.constraint(equalTo: self.view.layoutMarginsGuide.rightAnchor)
        ])
        // initialize the user location button
        userButton = MKUserTrackingButton(mapView: map)
        guard let userButton else {return}
        // configure buttons and add to view
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = UIColor(red: 0.24, green: 0.29, blue: 0.35, alpha: 1)
        let buttonArray = [notiButton, busButton, favButton, userButton]
        
        for button in buttonArray {
            switch button {
            case notiButton:
                configuration.image = UIImage(systemName: "exclamationmark.square.fill")
                notiButton.addTarget(self, action: #selector(notiButtonPressed), for: .touchUpInside)
                notiButton.configuration = configuration

            case busButton:
                configuration.image = UIImage(systemName: "bus.fill")
                busButton.addTarget(self, action: #selector(busButtonPressed), for: .touchUpInside)
                busButton.configuration = configuration

            case favButton:
                configuration.image = UIImage(systemName: "star.fill")
                favButton.addTarget(self, action: #selector(favButtonPressed), for: .touchUpInside)
                favButton.configuration = configuration
            case userButton:
                userButton.backgroundColor = .white
                userButton.tintColor = UIColor(red: 0.24, green: 0.29, blue: 0.35, alpha: 1)
                userButton.layer.cornerRadius = 5
            default:
                configuration.image = UIImage()
                
            }
            
            
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 36),
                button.widthAnchor.constraint(equalToConstant: 36)
            ])
            button.translatesAutoresizingMaskIntoConstraints = true
            buttonStack.addArrangedSubview(button)
        }
        
    }
     
    
}
