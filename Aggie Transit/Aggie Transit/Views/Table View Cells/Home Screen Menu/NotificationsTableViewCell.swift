//
//  NotificationsTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/16/23.
//

import Foundation
import UIKit

class NotificationsTableViewCell: UITableViewCell {
    private let cornerRadius: Double = 36.75
    private let borderWidth = 1.5
    private var width: Double?
    private var height: Double?
    private var view: UIView = UIView()
    private var viewHeight: Double?
    private var viewWidth: Double?
    private var margins: UILayoutGuide?
    private var viewMargins: UILayoutGuide?
    private var icon: UIImageView = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
    private var titleAlertLabel: UILabel = UILabel()
    private var stackView: UIStackView = UIStackView()
    private var textStack: UIStackView = UIStackView()
    private var titleContentLabel: UILabel = UILabel()
    var alertContent: String?
    var alertTitle: String?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.alertContent = nil
        self.alertTitle = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectedBackgroundView = nil
        width = self.contentView.frame.width
        height = self.contentView.frame.height
        // access the views width and height
        self.contentView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        if let width = width, let height = height {
            // add a subview to the view and shape it accordingly
            viewHeight = 129.375 * (height/165)
            viewWidth = (355-16) * (width/375)
            if let viewHeight, let viewWidth {
                // configure the view
                view.layer.cornerRadius = cornerRadius
                view.layer.borderWidth = borderWidth
                view.layer.borderColor = UIColor(named: "borderColor")?.cgColor
                view.backgroundColor = UIColor(named: "menuColor")
                view.translatesAutoresizingMaskIntoConstraints = false
                // add to the view hierarchy
                self.contentView.addSubview(view)
                // add constraints
                margins = self.safeAreaLayoutGuide
                if let margins = margins {
                    view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
                    view.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
                    view.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
                    view.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
                }
                // configure stackView
                stackView.alignment = .center
                stackView.distribution = .fill
                stackView.axis = .horizontal
                stackView.spacing = 8
                stackView.translatesAutoresizingMaskIntoConstraints = false
                // add stackview to view hierarchy
                view.addSubview(stackView)
                // add constraints
                viewMargins = view.safeAreaLayoutGuide
                if let viewMargins = viewMargins {
                    stackView.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor,constant: 30).isActive = true
                    stackView.centerYAnchor.constraint(equalTo: viewMargins.centerYAnchor).isActive = true
                    stackView.trailingAnchor.constraint(equalTo: viewMargins.trailingAnchor, constant: -30).isActive = true
                }
                // create icon label and text label
                let nameAttributes: [NSAttributedString.Key:Any] = [
                    .font:UIFont.boldSystemFont(ofSize: 16),
                    .foregroundColor:UIColor(named: "textColor") ?? .black
                ]
                let addressAttributes: [NSAttributedString.Key:Any] = [
                    .font:UIFont.systemFont(ofSize: 12),
                    .foregroundColor:UIColor(named: "textColor")?.withAlphaComponent(0.75) ?? .black
                ]
                if let alertTitle, let alertContent {
                    // configure text stack
                    textStack.alignment = .leading
                    textStack.distribution = .fill
                    textStack.axis = .vertical
                    textStack.translatesAutoresizingMaskIntoConstraints = false
                    titleAlertLabel.attributedText = NSAttributedString(string: alertTitle, attributes: nameAttributes)
                    titleContentLabel.attributedText = NSAttributedString(string: alertContent, attributes: addressAttributes)
                    titleAlertLabel.clipsToBounds = true
                    titleContentLabel.clipsToBounds = true
                    icon.clipsToBounds = true
                    titleAlertLabel.textColor = UIColor(named: "modalTableCellTextColor")
                    titleAlertLabel.numberOfLines = 0
                    titleContentLabel.numberOfLines = 0
                    titleAlertLabel.textAlignment = .left
                    titleContentLabel.textAlignment = .left
                    icon.tintColor = .systemYellow
                    icon.translatesAutoresizingMaskIntoConstraints = false
                    // add constraints
                    icon.widthAnchor.constraint(equalToConstant: 21).isActive = true
                    icon.widthAnchor.constraint(equalToConstant: 21).isActive = true
                    titleAlertLabel.translatesAutoresizingMaskIntoConstraints = false
                    titleContentLabel.translatesAutoresizingMaskIntoConstraints = false
                    // add to view hierarchy
                    stackView.addArrangedSubview(icon)
                    textStack.addArrangedSubview(titleAlertLabel)
                    textStack.addArrangedSubview(titleContentLabel)
                    stackView.addArrangedSubview(textStack)
                }
            }
        }
    }
}

