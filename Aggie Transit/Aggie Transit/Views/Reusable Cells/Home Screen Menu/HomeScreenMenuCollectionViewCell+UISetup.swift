//
//  HomeScreenMenuCollectionViewCell+UISetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/14/23.
//

import Foundation
import UIKit

extension HomeScreenMenuCollectionViewCell {
    //MARK: - setup cell and text stack
    func setupStacks() {
        // cell stack
        // configure
        cellStack.axis = .horizontal
        cellStack.spacing = 4
        cellStack.translatesAutoresizingMaskIntoConstraints = false
        // add to view hierarchy
        self.contentView.addSubview(cellStack)
        // constraint
        NSLayoutConstraint.activate([
            cellStack.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            cellStack.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        // text stack
        // configure
        textStack.axis = .vertical
        textStack.translatesAutoresizingMaskIntoConstraints = false
    }
    //MARK: - setup icon
    func setupIcon() {
        // configure
        self.iconImageView.image = UIImage(systemName: "mappin.circle.fill")
        self.iconImageView.tintColor = .darkGray
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        // add to view hierarchy
        self.cellStack.addArrangedSubview(iconImageView)
        // constrain
        NSLayoutConstraint.activate([
            self.iconImageView.heightAnchor.constraint(equalToConstant: self.contentView.frame.height*0.6),
            self.iconImageView.widthAnchor.constraint(equalTo: self.iconImageView.heightAnchor)
        ])
        
    }
    //MARK: - setup name label
    func setupNameandAddress() {
        // set up name label
        // configure
        if let name {
            let boldedName = NSAttributedString(string: name, attributes: [
                .font:UIFont.boldSystemFont(ofSize: 15),
                .foregroundColor: UIColor.darkGray
            ])
            self.nameLabel.attributedText = boldedName
            self.nameLabel.textAlignment = .left
            self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        }
        // add to view hierarchy
        self.textStack.addArrangedSubview(nameLabel)

        // set up address label
        // configure
        if let address {
            let boldedAddress = NSAttributedString(string: address, attributes: [
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.lightGray
            ])
            self.addressLabel.attributedText = boldedAddress
            self.addressLabel.textAlignment = .left
            self.addressLabel.translatesAutoresizingMaskIntoConstraints = false
        }
        // add to view hierarchy
        self.textStack.addArrangedSubview(addressLabel)
        // add the super view to view hierarchy
        self.cellStack.addArrangedSubview(textStack)
    }
    
}
