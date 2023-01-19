//
//  SearchResultsTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/12/23.
//

import Foundation
import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    private var locationNameLabel: UILabel = UILabel()
    public var locationName: String?
    private var verticalTextStack: UIStackView = UIStackView()
    private var locationAddressLabel: UILabel = UILabel()
    public var locationAddress: String?
    private var locationDistanceLabel: UILabel = UILabel()
    public var locationDistance: String?
    private var safeLayoutMargins: UILayoutGuide?
    private var horizontalStackPadding: Double?
    private var verticalStackSpacing: Double = 2.5
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.locationName = nil
        self.locationDistance = nil
        self.locationAddress = nil
    }

    override func layoutSubviews() {
        self.contentView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        self.selectedBackgroundView = nil
        super.layoutSubviews()
        horizontalStackPadding = 22.5 * Double(self.contentView.frame.width/375)
        // constrain the stack view
        safeLayoutMargins = self.contentView.safeAreaLayoutGuide
        if let safeLayoutMargins, let horizontalStackPadding {
                // configure the text stack
                verticalTextStack.spacing = verticalStackSpacing
                verticalTextStack.alignment = .leading
                verticalTextStack.distribution = .fill
                verticalTextStack.axis = .vertical
                verticalTextStack.translatesAutoresizingMaskIntoConstraints = false
                // add to view hierarchy
                self.contentView.addSubview(verticalTextStack)
                // add contraints
                verticalTextStack.leadingAnchor.constraint(equalTo: safeLayoutMargins.leadingAnchor, constant: horizontalStackPadding).isActive = true
                verticalTextStack.centerYAnchor.constraint(equalTo: safeLayoutMargins.centerYAnchor).isActive = true

                if let locationName = locationName, let locationAddress = locationAddress, let locationDistance = locationDistance {
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
                    locationAddressLabel.lineBreakMode = .byTruncatingTail
                    let attributedDistance = NSAttributedString(string: locationDistance, attributes: addressAttributes)
                    locationDistanceLabel.attributedText = attributedDistance
                    locationDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
                    locationDistanceLabel.lineBreakMode = .byTruncatingTail
                    // add to view hierarchy
                    verticalTextStack.addArrangedSubview(locationNameLabel)
                    verticalTextStack.addArrangedSubview(locationAddressLabel)
                    // add to view hierarcy
                    self.contentView.addSubview(locationDistanceLabel)
                    // add constraints
                    locationDistanceLabel.trailingAnchor.constraint(equalTo: safeLayoutMargins.trailingAnchor, constant: -horizontalStackPadding).isActive = true
                    locationDistanceLabel.centerYAnchor.constraint(equalTo: safeLayoutMargins.centerYAnchor).isActive = true
                    verticalTextStack.trailingAnchor.constraint(equalTo: locationDistanceLabel.leadingAnchor, constant: -horizontalStackPadding).isActive = true
                }
            
        }
        
        
    }
}
