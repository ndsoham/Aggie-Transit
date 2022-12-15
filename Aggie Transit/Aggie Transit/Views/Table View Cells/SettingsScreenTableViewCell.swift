//
//  SettingsScreenTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/19/22.
//

import UIKit

class SettingsScreenTableViewCell: UITableViewCell {
    private var icon: UIImageView?
    private var settingLabel: UILabel?
    private var stackView: UIStackView?
    private let settingName: String
    private let settingIcon: String
    private var cellHeight: Double?
    private var cellWidth: Double?
    private var stackViewSpacing: Double?
    private var margins: UILayoutGuide?
    private var iconHeight: Double?
    private var iconWidth: Double?
    private var labelHeight: Double?
    private var labelWidth: Double?

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, settingName: String, settingIcon: String, width: Double) {
        self.settingName = settingName
        self.settingIcon = settingIcon
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.frame = CGRect(x: 0, y: 0, width: width, height: 57.5)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        // scale the height appropriately
        cellHeight = self.contentView.frame.height
        cellWidth = self.contentView.frame.width
        self.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        if let cellHeight = cellHeight, let cellWidth = cellWidth {
            // configure the stackview
            stackViewSpacing = 10 * (375/cellWidth)
            stackView = UIStackView()
            if let stackView = stackView, let stackViewSpacing = stackViewSpacing {
                stackView.alignment = .center
                stackView.distribution = .fill
                stackView.axis = .horizontal
                stackView.spacing = stackViewSpacing
                stackView.translatesAutoresizingMaskIntoConstraints = false
                // add the stackview to the view hierarchy
                self.contentView.addSubview(stackView)
                // constrain the stackview
                margins = self.contentView.safeAreaLayoutGuide
                if let margins = margins {
                    stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: stackViewSpacing).isActive = true
                    stackView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
                    stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
                }
                // configure image view
                iconHeight = 45 * (cellHeight/57.5)
                iconWidth = iconHeight
                if let iconWidth = iconWidth, let iconHeight = iconHeight{
                    icon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconHeight, height: iconWidth))
                    if let icon = icon {
                        icon.layer.cornerRadius = iconHeight/2
                        icon.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                        icon.translatesAutoresizingMaskIntoConstraints = false
                        icon.layer.borderColor = UIColor(named: "borderColor")?.cgColor
                        icon.layer.borderWidth = 1
                        // constrain the image view
                        icon.widthAnchor.constraint(equalToConstant: iconWidth).isActive = true
                        icon.heightAnchor.constraint(equalToConstant: iconHeight).isActive = true
                        // add the icon to the view hierarchy
                        stackView.addArrangedSubview(icon)
                        // configure the label
                        labelHeight = iconHeight
                        labelWidth = cellWidth - iconWidth - stackViewSpacing
                        if let labelWidth = labelWidth, let labelHeight = labelHeight {
                            settingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight))
                            if let settingLabel = settingLabel{
                                settingLabel.text = settingName
                                settingLabel.textColor = UIColor(named: "textColor")
                                settingLabel.translatesAutoresizingMaskIntoConstraints = false
                                // constrain the label
                                settingLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
                                // add to view hierarchy
                                stackView.addArrangedSubview(settingLabel)
                            }
                        }
                    }
                }
            }
        }
        
    }
}
