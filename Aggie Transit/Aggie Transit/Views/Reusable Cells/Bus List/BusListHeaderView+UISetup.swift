//
//  BusListHeaderView+UISetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/28/23.
//

import Foundation
import UIKit

extension BusListHeaderView {
    //MARK: - setup section button
    func setupSectionButton() {
        // configure

        if let section {
            var boldedSection = AttributedString(section)
            var container = AttributeContainer()
            container[AttributeScopes.UIKitAttributes.FontAttribute.self] = .boldSystemFont(ofSize: 18)
            boldedSection.mergeAttributes(container, mergePolicy: .keepNew)
            configuration.attributedTitle = boldedSection
        }
        sectionButton.configuration = configuration
        sectionButton.tintColor = UIColor(red: 0.24, green: 0.29, blue: 0.35, alpha: 1)
        sectionButton.translatesAutoresizingMaskIntoConstraints = false
        sectionButton.showsMenuAsPrimaryAction = true
        let onCampusAction = UIAction (title: "On Campus") { action in
            self.filterDelegate?.sectionChanged(newSection: "On Campus")
            self.section = "On Campus"
            DispatchQueue.main.async {
                self.sectionButton.setAttributedTitle(NSAttributedString(string: "On Campus", attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 18),
                    .foregroundColor:UIColor(red: 0.24, green: 0.29, blue: 0.35, alpha: 1)
                ]), for: .normal)
            }
        }
        let offCampusAction = UIAction (title: "Off Campus") { action in
            self.filterDelegate?.sectionChanged(newSection: "Off Campus")
            self.section = "Off Campus"
            DispatchQueue.main.async {
                self.sectionButton.setAttributedTitle(NSAttributedString(string: "Off Campus", attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 18),
                    .foregroundColor:UIColor(red: 0.24, green: 0.29, blue: 0.35, alpha: 1)
                ]), for: .normal)
            }
        }
    
        let filterMenu = UIMenu(children: [onCampusAction, offCampusAction])
        sectionButton.menu = filterMenu
        // add to view hierarchy
        self.addSubview(sectionButton)
        // constrain
        NSLayoutConstraint.activate([
            sectionButton.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            sectionButton.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor)
        ])
        // configure button menu
        
        
    }
    //MARK: - setup close button
    func setupCloseButton() {
        // configure
        closeButton.tintColor = .systemBlue
        closeButton.setTitle("Close", for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(didCloseView), for: .touchUpInside)
        // add to view hierarchy
        self.addSubview(closeButton)
        // constrain
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            closeButton.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor)
        ])
    }
}
