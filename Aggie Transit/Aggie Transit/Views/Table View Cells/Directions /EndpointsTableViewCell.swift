//
//  DirectionsTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/13/23.
//

import Foundation
import UIKit

class EndpointsTableViewCell: UITableViewCell {
    private var moveIcon: UIImageView =  UIImageView(image: UIImage(systemName: "line.3.horizontal"))
    private var horizontalStack: UIStackView = UIStackView()
    private var safeMargins: UILayoutGuide?
    private let inset: Double? = 5
    private var baseView: UIView = UIView()
    var iconTintColor: UIColor?
    var textField: UITextField = UITextField()
    var text: String?
    var icon: UIImageView =  UIImageView(image: UIImage(systemName:"mappin.circle.fill"))
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
    }
    //MARK: - layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectedBackgroundView = nil
        safeMargins = self.contentView.layoutMarginsGuide
        if let safeMargins = safeMargins, let inset = inset {
            self.contentView.backgroundColor = UIColor(named: "menuColor")
            // configure the base view
            baseView.translatesAutoresizingMaskIntoConstraints = false
            baseView.backgroundColor =  UIColor(named: "menuColor")
            // add to view hierarchy and constrain
            self.contentView.addSubview(baseView)
            // add constraints
            baseView.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor).isActive = true
            baseView.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor).isActive = true
            baseView.topAnchor.constraint(equalTo: safeMargins.topAnchor).isActive = true
            baseView.bottomAnchor.constraint(equalTo: safeMargins.bottomAnchor).isActive = true
            // configure the stack view
            horizontalStack.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack.axis = .horizontal
            horizontalStack.alignment = .leading
            horizontalStack.distribution = .fill
            horizontalStack.spacing = inset
            // add to view hierarchy
            self.contentView.addSubview(horizontalStack)
            // constrain
            horizontalStack.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor,constant: inset).isActive = true
            horizontalStack.centerYAnchor.constraint(equalTo: safeMargins.centerYAnchor).isActive = true
            // set up the icons and text field
            if let text = text {
                icon.tintColor = iconTintColor
                icon.translatesAutoresizingMaskIntoConstraints = false
                // constrain the icon
                icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
                textField.translatesAutoresizingMaskIntoConstraints = false
                textField.text = text
                textField.isEnabled = false
                moveIcon.translatesAutoresizingMaskIntoConstraints = false
                textField.placeholder = "Memorial Student Center"
                // add to view hierarchy
                horizontalStack.addArrangedSubview(icon)
                horizontalStack.addArrangedSubview(textField)
                // add to view hierarchy and constrain
                self.contentView.addSubview(moveIcon)
                moveIcon.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor,constant: -inset).isActive = true
                moveIcon.centerYAnchor.constraint(equalTo: safeMargins.centerYAnchor).isActive = true
                moveIcon.widthAnchor.constraint(equalToConstant: 21).isActive = true
                horizontalStack.trailingAnchor.constraint(equalTo: moveIcon.leadingAnchor,constant: -inset).isActive = true
            }
        }
    }
}
