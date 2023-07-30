//
//  BusRoutesCollectionViewCell+UISetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/28/23.
//

import Foundation
import UIKit

extension BusListCollectionViewCell {
    //MARK: - setup name and stops
    func setupNameAndStopsLabel() {
        // configure
        textStack.axis = .vertical
        textStack.translatesAutoresizingMaskIntoConstraints = false
        // add to view hierarchy
        self.contentView.addSubview(textStack)
        // constrain
        NSLayoutConstraint.activate([
            textStack.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            textStack.centerYAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.centerYAnchor),
            textStack.trailingAnchor.constraint(equalTo: self.numberLabel.layoutMarginsGuide.leadingAnchor, constant: -10)
        ])
        // set up name
        if let name {
            //configure
            let boldedName = NSAttributedString(string: name, attributes: [
                .font:UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor.white
            ])
            nameLabel.attributedText = boldedName
            nameLabel.textAlignment = .left
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
        }
        // add to view hierarchy
        self.textStack.addArrangedSubview(nameLabel)
        
        // set up stops
        if let stops {
            let formattedStops = NSAttributedString(string: stops, attributes: [
                .font: UIFont.systemFont(ofSize: 11),
                .foregroundColor: UIColor.white
            ])
            stopsLabel.attributedText = formattedStops
            stopsLabel.textAlignment = .left
            stopsLabel.numberOfLines = 2
            stopsLabel.translatesAutoresizingMaskIntoConstraints = false
        }
        // add to view hierarchy
        self.textStack.addArrangedSubview(stopsLabel)
        
    }
    //MARK: - setup number label
    func setupNumberLabel() {
        // configure
        if let number {
            let boldedNumber = NSAttributedString(string: number, attributes: [
                .font: UIFont.boldSystemFont(ofSize: 20),
                .foregroundColor: UIColor.white
            ])
            numberLabel.attributedText = boldedNumber
            numberLabel.textAlignment = .right
            numberLabel.translatesAutoresizingMaskIntoConstraints = false
        }
        // add to view hierarchy
        self.contentView.addSubview(numberLabel)
        // constrain
        NSLayoutConstraint.activate([
            numberLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.centerYAnchor)
        ])
    }
}
