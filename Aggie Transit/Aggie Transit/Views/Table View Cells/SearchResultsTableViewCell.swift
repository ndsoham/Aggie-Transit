//
//  SearchResultsTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/12/23.
//

import Foundation
import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    private var locationNameLabel: UILabel?
    public var locationName: String?
    private var verticalTextStack: UIStackView?
    private var locationAddressLabel: UILabel?
    public var locationAddress: String?
    private var locationDistanceLabel: UILabel?
    public var locationDistance: String?
    private var safeLayoutMargins: UILayoutGuide?
    private var horizontalStackPadding: Double?
    private var verticalStackSpacing: Double = 2.5
    private var baseView: UIView?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        self.locationNameLabel?.text = nil
        self.locationDistanceLabel?.text = nil
        self.locationAddressLabel?.text = nil
        super.prepareForReuse()
        self.clearsContextBeforeDrawing = true
       
    }

    override func layoutSubviews() {
        self.contentView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        self.selectedBackgroundView = nil
        super.layoutSubviews()
        horizontalStackPadding = 22.5 * Double(self.contentView.frame.width/375)
        // constrain the stack view
        safeLayoutMargins = self.contentView.safeAreaLayoutGuide
        if let safeLayoutMargins = safeLayoutMargins, let horizontalStackPadding = horizontalStackPadding {
            // configure the base view - this is added so text doesnt get magically bolder
            baseView = UIView()
            if let baseView = baseView {
                baseView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                baseView.translatesAutoresizingMaskIntoConstraints = false
                // add to view hierarchy
                self.contentView.addSubview(baseView)
                // add constraints
                baseView.leadingAnchor.constraint(equalTo: safeLayoutMargins.leadingAnchor).isActive = true
                baseView.trailingAnchor.constraint(equalTo: safeLayoutMargins.trailingAnchor).isActive = true
                baseView.topAnchor.constraint(equalTo: safeLayoutMargins.topAnchor).isActive = true
                baseView.bottomAnchor.constraint(equalTo: safeLayoutMargins.bottomAnchor).isActive = true

            }
            // configure the vertical stack
            verticalTextStack = UIStackView()
            if let verticalTextStack = verticalTextStack {
                // configure the text stack
                verticalTextStack.spacing = verticalStackSpacing
                verticalTextStack.alignment = .leading
                verticalTextStack.distribution = .equalSpacing
                verticalTextStack.axis = .vertical
                verticalTextStack.translatesAutoresizingMaskIntoConstraints = false
                // add to view hierarchy
                self.contentView.addSubview(verticalTextStack)
                // add contraints
                verticalTextStack.leadingAnchor.constraint(equalTo: safeLayoutMargins.leadingAnchor, constant: horizontalStackPadding).isActive = true
                verticalTextStack.centerYAnchor.constraint(equalTo: safeLayoutMargins.centerYAnchor).isActive = true
                verticalTextStack.widthAnchor.constraint(equalToConstant: self.contentView.frame.width * 0.75).isActive = true
                // create the labels with relevant attributes
                locationNameLabel = UILabel()
                locationAddressLabel = UILabel()
                locationDistanceLabel = UILabel()
                if let locationName = locationName, let locationAddress = locationAddress, let locationDistance = locationDistance, let locationNameLabel = locationNameLabel, let locationAddressLabel = locationAddressLabel, let locationDistanceLabel = locationDistanceLabel {
                    let nameAttributes: [NSAttributedString.Key:Any] = [
                        .font:UIFont.boldSystemFont(ofSize: 18),
                        .foregroundColor:UIColor(named: "textColor") ?? .black
                    ]
                    let addressAttributes: [NSAttributedString.Key:Any] = [
                        .font:UIFont.systemFont(ofSize: 14),
                        .foregroundColor:UIColor(named: "textColor")?.withAlphaComponent(0.75) ?? .black
                    ]
                    // configure the label
                    let attributedName = NSAttributedString(string: locationName, attributes: nameAttributes)
                    locationNameLabel.attributedText = attributedName
                    let attributedAddress = NSAttributedString(string: locationAddress, attributes: addressAttributes)
                    locationAddressLabel.attributedText = attributedAddress
                    locationAddressLabel.textAlignment = .left
                    let attributedDistance = NSAttributedString(string: locationDistance, attributes: addressAttributes)
                    locationDistanceLabel.attributedText = attributedDistance
                    locationDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
                    // add to view hierarchy
                    verticalTextStack.addArrangedSubview(locationNameLabel)
                    verticalTextStack.addArrangedSubview(locationAddressLabel)
                    // add to view hierarcy
                    self.contentView.addSubview(locationDistanceLabel)
                    // add constraints
                    locationDistanceLabel.trailingAnchor.constraint(equalTo: safeLayoutMargins.trailingAnchor, constant: -horizontalStackPadding).isActive = true
                    locationDistanceLabel.centerYAnchor.constraint(equalTo: safeLayoutMargins.centerYAnchor).isActive = true
                }
            }
        }
        
        
    }
}
