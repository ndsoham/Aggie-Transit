//
//  HomeScreenMenuCollectionFooterView+UISetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/26/23.
//

import Foundation
import UIKit

extension HomeScreenMenuCollectionFooterView {
    //MARK: - setup button
    func setupAddButton() {
        // configure
        if let footerName {
            addButton.setTitle("Add \(footerName)", for: .normal)
        }
        addButton.tintColor = .systemBlue
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(didPressAdd), for: .touchUpInside)
        // add to view hierarchy
        self.addSubview(addButton)
        // constrain
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
