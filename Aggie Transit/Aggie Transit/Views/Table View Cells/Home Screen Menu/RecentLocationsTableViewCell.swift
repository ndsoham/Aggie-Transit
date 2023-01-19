//
//  Unnamed.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/16/22.
//
import Foundation
import UIKit

class RecentLocationsTableViewCell: UITableViewCell {
    private let cornerRadius: Double = 36.75
    private let borderWidth = 1.5
    private var width: Double?
    private var height: Double?
    private var view: UIView = UIView()
    private var viewHeight: Double?
    private var viewWidth: Double?
    private var margins: UILayoutGuide?
    private var viewMargins: UILayoutGuide?
    private var icon: UIImageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
    private var customTextLabel: UILabel = UILabel()
    private var stackView: UIStackView = UIStackView()
    private var textStack: UIStackView = UIStackView()
    private var addressLabel: UILabel = UILabel()
    var address: String?
    var name: String?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder){
        fatalError()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.address = nil
        self.name = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectedBackgroundView = nil
        // access the views width and height
        width = self.contentView.frame.width
        height = self.contentView.frame.height
        self.contentView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        if let width = width, let height = height {
            // add a subview to the view and shape it accordingly
            viewHeight = 86.25 * (height/110)
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
                    .font:UIFont.boldSystemFont(ofSize: 18),
                    .foregroundColor:UIColor(named: "textColor") ?? .black
                ]
                let addressAttributes: [NSAttributedString.Key:Any] = [
                    .font:UIFont.systemFont(ofSize: 14),
                    .foregroundColor:UIColor(named: "textColor")?.withAlphaComponent(0.75) ?? .black
                ]
                if let name, let address {
                    // configure text stack
                    textStack.alignment = .leading
                    textStack.distribution = .fill
                    textStack.axis = .vertical
                    textStack.translatesAutoresizingMaskIntoConstraints = false
                    customTextLabel.attributedText = NSAttributedString(string: name, attributes: nameAttributes)
                    addressLabel.attributedText = NSAttributedString(string: address, attributes: addressAttributes)
                    customTextLabel.clipsToBounds = true
                    addressLabel.clipsToBounds = true
                    icon.clipsToBounds = true
                    customTextLabel.textColor = UIColor(named: "textColor")
                    icon.tintColor = UIColor(named: "recentLocationRed")
                    icon.translatesAutoresizingMaskIntoConstraints = false
                    // add constraints
                    icon.widthAnchor.constraint(equalToConstant: 21).isActive = true
                    icon.widthAnchor.constraint(equalToConstant: 21).isActive = true
                    customTextLabel.translatesAutoresizingMaskIntoConstraints = false
                    addressLabel.translatesAutoresizingMaskIntoConstraints = false
                    // add to view hierarchy
                    stackView.addArrangedSubview(icon)
                    textStack.addArrangedSubview(customTextLabel)
                    textStack.addArrangedSubview(addressLabel)
                    stackView.addArrangedSubview(textStack)
                }
            }
        }
    }
}
