//
//  FavoritesHeaderView+UISetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/18/23.
//

import Foundation
import UIKit

extension FavoritesHeaderView {
    //MARK: - setup label
    func setupLabel() {
        // configure
        if let headerName {
            headerLabel.attributedText = NSAttributedString(string: headerName, attributes: [
                .font : UIFont.boldSystemFont(ofSize: 13),
                .foregroundColor: UIColor.darkGray
            ]
            )
        }
        headerLabel.textAlignment = .left
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        // add to view hierarchy
        self.addSubview(headerLabel)
        // constrain
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor)
        ])
    }
}
