//
//  DirectionsTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/13/23.
//

import Foundation
import UIKit

class DirectionsTableViewCell: UITableViewCell {
    private var horizontalStack: UIStackView = UIStackView()
    private var icon: UIImageView = UIImageView()
    private var directionsLabel: UILabel = UILabel()
    private var directionsHeaderLabel: UILabel = UILabel()
    private var textStack: UIStackView = UIStackView()
    private var iconStack: UIStackView = UIStackView()
    private var safeMargins: UILayoutGuide?
    private var leftPadding: Double = 5.0
    private var walkingDistanceLabel: UILabel = UILabel()
    private var verticalStackSpacing: Double = 2.5
    var directions: String?
    var directionsHeader: String?
    var iconImage: UIImage?
    var iconTint: UIColor?
    var walkingDistance: Double?
    //MARK: - initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconImage = nil
        self.iconTint = nil
        self.directions = nil
    }
    //MARK: -  layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        safeMargins = self.contentView.layoutMarginsGuide
        // configure the base view
        self.contentView.backgroundColor = UIColor(named: "menuColor")
        self.plainView.backgroundColor  = UIColor(named: "menuColor")
        if let safeMargins = safeMargins {
            // configure the icon and label
            if let iconImage, let directions, let iconTint, let directionsHeader{
                horizontalStack.translatesAutoresizingMaskIntoConstraints = false
                horizontalStack.axis = .horizontal
                horizontalStack.alignment = .top
                horizontalStack.distribution = .fill
                horizontalStack.spacing = leftPadding * 2
                // add to view hierarchy
                self.contentView.addSubview(horizontalStack)
                // add constraints
                horizontalStack.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor, constant: leftPadding).isActive = true
                horizontalStack.centerYAnchor.constraint(equalTo: safeMargins.centerYAnchor).isActive = true
                horizontalStack.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor, constant: -leftPadding).isActive = true
                // configure the text stack
                textStack.translatesAutoresizingMaskIntoConstraints = false
                textStack.axis = .vertical
                textStack.alignment = .leading
                textStack.distribution = .fill
                textStack.spacing = verticalStackSpacing
                // for attributed text
                let headerAttributes: [NSAttributedString.Key:Any] = [
                    .font:UIFont.boldSystemFont(ofSize: 16),
                    .foregroundColor:UIColor(named: "textColor") ?? .black
                ]
                let instructionAttributes: [NSAttributedString.Key:Any] = [
                    .font:UIFont.systemFont(ofSize: 14),
                    .foregroundColor:UIColor(named: "textColor")?.withAlphaComponent(0.75) ?? .black
                ]
                // configure the other things
                icon.image = iconImage
                icon.tintColor = iconTint
                icon.translatesAutoresizingMaskIntoConstraints = false
                directionsHeaderLabel.attributedText = NSAttributedString(string: directionsHeader, attributes: headerAttributes)
                directionsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
                directionsLabel.attributedText = NSAttributedString(string: directions, attributes: instructionAttributes)
                directionsLabel.translatesAutoresizingMaskIntoConstraints = false
                directionsLabel.numberOfLines = 0
                // add to view hierarchy and constrain
                horizontalStack.addArrangedSubview(icon)
                textStack.addArrangedSubview(directionsHeaderLabel)
                textStack.addArrangedSubview(directionsLabel)
                horizontalStack.addArrangedSubview(textStack)
                // constrain icon
                icon.widthAnchor.constraint(equalToConstant: 31.5).isActive = true
                icon.heightAnchor.constraint(equalToConstant: 31.5).isActive = true
                // constrain the label
                // add an optional walking distance label
                if let walkingDistance {
                    let distanceAttributes: [NSAttributedString.Key:Any] = [
                        .font:UIFont.systemFont(ofSize: 12),
                        .foregroundColor:UIColor(named: "textColor")?.withAlphaComponent(0.75) ?? .black
                    ]
                    walkingDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
                    walkingDistanceLabel.attributedText = NSAttributedString(string: "\(walkingDistance) mi", attributes: distanceAttributes)
                    walkingDistanceLabel.adjustsFontSizeToFitWidth = true
                    self.contentView.addSubview(walkingDistanceLabel)
                    // add constraints
                    walkingDistanceLabel.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor, constant: leftPadding).isActive = true
                    walkingDistanceLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: verticalStackSpacing).isActive = true
                    walkingDistanceLabel.widthAnchor.constraint(equalToConstant: 31).isActive = true

                }
            }
        }
    }
}
