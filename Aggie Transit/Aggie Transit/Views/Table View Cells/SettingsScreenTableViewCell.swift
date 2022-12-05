//
//  SettingsScreenTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/19/22.
//

import UIKit

class SettingsScreenTableViewCell: UITableViewCell {
    let icon = UIImageView()
    let settingLabel = UILabel()
    let stackView = UIStackView()
    let settingName: String
    let settingIcon: String

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, settingName: String, settingIcon: String) {
        self.settingName = settingName
        self.settingIcon = settingIcon
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        // scale the height appropriately
//        let screenHeight = SettingsScreenViewController().view.frame.height
        let cellHeight = self.contentView.frame.height
        let cellWidth = self.contentView.frame.width
        // configure the stackview
        let spacing = 10 * (cellWidth/375)
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        stackView.spacing = spacing
        // add the stackview to the view hierarchy
        self.contentView.addSubview(stackView)
        // constrain the stackview
        let margins = self.contentView.safeAreaLayoutGuide
        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        // configure image view
        let iconHeight = 45 * (cellHeight/57.5)
        let iconWidth = iconHeight
        icon.frame = CGRect(x: 0, y: 0, width: iconHeight, height: iconWidth)
        icon.layer.cornerRadius = iconHeight/2
        icon.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        // constrain the image view
        icon.widthAnchor.constraint(equalToConstant: iconWidth).isActive = true
        icon.heightAnchor.constraint(equalToConstant: iconHeight).isActive = true
        // add the icon to the view hierarchy
        stackView.addArrangedSubview(icon)
        // configure the label
        let labelHeight = iconHeight
        let labelWidth = cellWidth - iconWidth - spacing
        settingLabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
        settingLabel.text = settingName
        settingLabel.textColor = UIColor(named: "textColor")
        // constrain the label
        settingLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        settingLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
    }
}
