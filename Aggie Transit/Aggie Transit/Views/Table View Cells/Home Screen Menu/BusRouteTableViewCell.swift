//
//  Unnamed.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/16/22.
//

import UIKit

class BusRouteTableViewCell: UITableViewCell {
    private var cornerRadius: Double? = 36.75
    private let borderWidth = 1.5
    private var width: Double?
    private var height: Double?
    private var view: UIView = UIView()
    private var viewHeight: Double?
    private var viewWidth: Double?
    private var margins: UILayoutGuide?
    private var viewMargins: UILayoutGuide?
    private var iconLabel: UILabel = UILabel()
    private var customTextLabel: UILabel = UILabel()
    private var stackView: UIStackView = UIStackView()
    private var colorViewWidth: Double? = 75 * 0.75
    var icon: NSAttributedString?
    var busName: NSAttributedString?
    var cellColor: UIColor?
    private var colorView: UIView = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutIfNeeded()
    }
    required init?(coder: NSCoder){
        fatalError()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.icon = nil
        self.busName = nil
        self.cellColor = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectedBackgroundView = nil
        // access the views width and height
        width = self.contentView.frame.width
        height = self.contentView.frame.height
        self.contentView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        if let width = width, let height = height, let colorViewWidth {
            // add a subview to the view and shape it accordingly
            viewHeight = 86.25 * (height/110)
            viewWidth = (355-16) * (width/375)
            if let viewHeight = viewHeight, let viewWidth = viewWidth {
                if let cornerRadius = cornerRadius{
                    if let cellColor = cellColor {
                        // configure the view
                        view.layer.cornerRadius = cornerRadius
                        view.layer.borderWidth = borderWidth
                        view.layer.borderColor = UIColor(named: "borderColor")?.cgColor
                        view.backgroundColor = UIColor(named: "menuColor")//cellColor
                        view.translatesAutoresizingMaskIntoConstraints = false
                        // configure base view
                        // add to the view hierarchy
                        //self.contentView.addSubview(baseView)
                        self.contentView.addSubview(view)
                        // add constraints
                        margins = self.safeAreaLayoutGuide
                        if let margins = margins {
                            view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
                            view.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
                            view.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
                            view.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
                        }
                        // create stack view
                            // configure stackView
                            stackView.alignment = .center
                            stackView.distribution = .equalCentering
                            stackView.axis = .horizontal
                            stackView.spacing = 10
                            stackView.translatesAutoresizingMaskIntoConstraints = false
                            // add stackview to view hierarchy
                            view.addSubview(stackView)
                            // add constraints
                            viewMargins = view.safeAreaLayoutGuide
                            if let viewMargins = viewMargins {
                                stackView.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor,constant: 20).isActive = true
                                stackView.centerYAnchor.constraint(equalTo: viewMargins.centerYAnchor).isActive = true
                            }
                            if let icon, let busName {
                                iconLabel.translatesAutoresizingMaskIntoConstraints = false
                                customTextLabel.translatesAutoresizingMaskIntoConstraints = false
                                colorView.translatesAutoresizingMaskIntoConstraints = false
                                colorView.backgroundColor = cellColor
                                colorView.layer.cornerRadius = colorViewWidth * 0.30
                                iconLabel.clipsToBounds = true
                                customTextLabel.clipsToBounds = true
                                colorView.clipsToBounds = true
                                iconLabel.attributedText = icon
                                iconLabel.textAlignment = .right
                                iconLabel.textColor = UIColor(named: "textColor")
                                customTextLabel.attributedText = busName
                                customTextLabel.textColor = UIColor(named: "textColor")
                                // contrain the color
                                colorView.widthAnchor.constraint(equalToConstant: colorViewWidth).isActive = true
                                colorView.heightAnchor.constraint(equalToConstant: colorViewWidth - 20).isActive = true
                                // add to view hierarchy
                                colorView.addSubview(iconLabel)
                                iconLabel.centerXAnchor.constraint(equalTo: colorView.centerXAnchor).isActive = true
                                iconLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor).isActive = true
                                stackView.addArrangedSubview(colorView)
                                stackView.addArrangedSubview(customTextLabel)
                            }
                    }
                }
            }
            
        }
        
    }
    
}
