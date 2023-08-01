//
//  SearchResultsViewController+UISetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/31/23.
//

import Foundation
import UIKit

extension SearchResultsViewController {
    //MARK: - setup self
    func setupSelf()  {
        self.view.isUserInteractionEnabled = true
        self.view.layer.cornerRadius = 15
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.backgroundColor = .white
        // configure sheet presentation
        if let sheet = self.sheetPresentationController {
            sheet.detents = [
                .custom(identifier: UISheetPresentationController.Detent.Identifier("small"), resolver: { context in
                    180
                }),
                .medium(),
                .large()
            ]
            
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
            isModalInPresentation = true
        }
        
    }
    //MARK: - setup left header label
    func setupHeaderLabel() {
        // configure stack view
        headerStack.axis = .vertical
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        // add to view hierarchy
        self.view.addSubview(headerStack)
        // constrain
        NSLayoutConstraint.activate([
            headerStack.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            headerStack.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor)
        ])
        
        // setup header label
        if let locationName {
            let attributedHeader = NSAttributedString(string: locationName, attributes: [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ])
            // configure
            headerLabel.attributedText = attributedHeader
            headerLabel.textAlignment = .left
            headerLabel.translatesAutoresizingMaskIntoConstraints = false
            // add to view hierarchy
            headerStack.addArrangedSubview(headerLabel)
        }
        // setup sup header label
        if let numResults {
            let attributedSubHeader = NSAttributedString(string: "\(numResults) found nearby", attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.systemGray
            ])
            subHeaderLabel.attributedText = attributedSubHeader
            subHeaderLabel.textAlignment = .left
            subHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
            // add to view hierarchy
            headerStack.addArrangedSubview(subHeaderLabel)
        }
    }
    //MARK: - setup back button
    func setupBackButton() {
        // configure
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Back", for: .normal)
        backButton.tintColor = .systemBlue
        // add to view hierarchy
        self.view.addSubview(backButton)
        // constrain
        NSLayoutConstraint.activate([
            backButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor)
        ])
        
    }
    //MARK: - setup results collection view
    func setupResultsCollectionView() {
        // init
        resultsCollectionView = UICollectionView(frame: CGRect(x: 0, y: Int(self.headerStack.frame.maxY) + Int((self.view.layoutMargins.bottom)) , width: Int(self.view.frame.width - (self.view.layoutMargins.left * 2)), height: Int(self.view.frame.height - (self.view.layoutMargins.top + self.headerStack.frame.height))), collectionViewLayout: singleColumnLayout)
        // configure
        if let resultsCollectionView {
            resultsCollectionView.allowsSelection = true
            resultsCollectionView.allowsMultipleSelection = false
            // register cell
            resultsCollectionView.register(HomeScreenMenuCollectionViewCell.self, forCellWithReuseIdentifier: HomeScreenMenuCollectionViewCell.id)
            // configure layout
            resultsCollectionView.dataSource = self
            resultsCollectionView.delegate = self
            resultsCollectionView.backgroundColor = .clear
            resultsCollectionView.translatesAutoresizingMaskIntoConstraints = false
            // add to view hierarchy
            self.view.addSubview(resultsCollectionView)
            // constrain
            NSLayoutConstraint.activate([
                resultsCollectionView.topAnchor.constraint(equalTo: self.headerStack.layoutMarginsGuide.bottomAnchor, constant: 20),
                resultsCollectionView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
                resultsCollectionView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
                resultsCollectionView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor)
            ])
            
        }
    }
}
