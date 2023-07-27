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
     
    
}
