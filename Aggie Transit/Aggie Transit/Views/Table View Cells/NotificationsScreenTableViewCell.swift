//
//  NotificationsScreenTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/19/22.
//

import UIKit

class NotificationsScreenTableViewCell: UITableViewCell {
    private var notificationsIcon: UIImageView?
    private var notificationsIconHeight: Double?
    private var notificationsIconWidth: Double?
    private var notificationsHeader: UILabel?
    public var notificationsHeaderText: String?
    private var notificationsText: UILabel?
    private var headerTextSize: Double?
    public var notificationsTextContent: String?
    private var textContentTextSize: Double?
    private var textStack: UIStackView?
    private var textStackSpacing: Double?
    private var horizontalStack: UIStackView?
    private var horizontalStackSpacing: Double?
    private var cellHeight: Double?
    private var cellWidth: Double?
    private var margins: UILayoutGuide?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        
    }
    override func layoutSubviews() {
        cellHeight = self.contentView.frame.height
        cellWidth = self.contentView.frame.width
        self.contentView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        if let cellHeight = cellHeight, let cellWidth = cellWidth {
            horizontalStackSpacing = 10 * (375/cellWidth)
            horizontalStack = UIStackView()
            if let horizontalStack = horizontalStack, let horizontalStackSpacing = horizontalStackSpacing {
                // configure the horizontal stack view
                horizontalStack.alignment = .center
                horizontalStack.distribution = .fill
                horizontalStack.axis = .horizontal
                horizontalStack.spacing = horizontalStackSpacing
                horizontalStack.translatesAutoresizingMaskIntoConstraints = false
                // add to view hierarchy
                self.contentView.addSubview(horizontalStack)
                // add constraints
                margins = self.contentView.safeAreaLayoutGuide
                if let margins = margins {
                    horizontalStack.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: horizontalStackSpacing).isActive = true
                    horizontalStack.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
                    horizontalStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
                }
                // configure the notifications image
                notificationsIconHeight = 68.56 * (cellHeight/112.31)
                notificationsIconWidth = notificationsIconHeight
                if let notificationsIconWidth = notificationsIconWidth, let notificationsIconHeight = notificationsIconHeight {
                    notificationsIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: notificationsIconWidth, height: notificationsIconHeight))
                    if let notificationsIcon = notificationsIcon {
                        notificationsIcon.layer.cornerRadius = notificationsIconHeight/2
                        notificationsIcon.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                        notificationsIcon.translatesAutoresizingMaskIntoConstraints = false
                        notificationsIcon.layer.borderColor = UIColor(named: "borderColor")?.cgColor
                        notificationsIcon.layer.borderWidth = 1
                        notificationsIcon.image = UIImage(named: "homeScreenNotificationsFAB")
                        // add constraints
                        notificationsIcon.widthAnchor.constraint(equalToConstant: notificationsIconWidth).isActive = true
                        notificationsIcon.heightAnchor.constraint(equalToConstant: notificationsIconHeight).isActive = true
                        // add to view hierarchy
                        horizontalStack.addArrangedSubview(notificationsIcon)
                    }
                }
                // create a second stack
                textStack = UIStackView()
                textStackSpacing = 5 * (112.31/cellHeight)
                if let textStack = textStack, let textStackSpacing = textStackSpacing {
                    // configure
                    textStack.alignment = .top
                    textStack.distribution = .fill
                    textStack.axis = .vertical
                    textStack.spacing = textStackSpacing
                    textStack.translatesAutoresizingMaskIntoConstraints = false
                    // add to view hierarchy
                    horizontalStack.addArrangedSubview(textStack)
                    notificationsHeader = UILabel()
                    notificationsText = UILabel()
                    headerTextSize = 24 * (cellHeight/112.31)
                    textContentTextSize = (headerTextSize ?? 0)/1.5
                    if let notificationsText = notificationsText, let notificationsHeader = notificationsHeader, let notificationsHeaderText = notificationsHeaderText, let notificationsTextContent = notificationsTextContent, let headerTextSize = headerTextSize, let textContentTextSize = textContentTextSize {
                        let headerAttributes: [NSAttributedString.Key:Any] = [
                            .foregroundColor : UIColor(named: "textColor") ?? .red,
                            .font: UIFont.boldSystemFont(ofSize: headerTextSize)
                            
                        ]
                        let contentTextAttributes: [NSAttributedString.Key:Any] = [
                            .foregroundColor : UIColor(named: "textColor") ?? .red,
                            .font: UIFont.systemFont(ofSize: textContentTextSize)
                        ]
                        let attributedNotificationsHeaderText = NSAttributedString(string: notificationsHeaderText, attributes: headerAttributes)
                        let attributedTextContentText = NSAttributedString(string: notificationsTextContent, attributes: contentTextAttributes)
                        notificationsHeader.attributedText = attributedNotificationsHeaderText
                        notificationsText.attributedText = attributedTextContentText
                        notificationsHeader.translatesAutoresizingMaskIntoConstraints = false
                        notificationsText.translatesAutoresizingMaskIntoConstraints = false
                        // add to view hierarchy
                        textStack.addArrangedSubview(notificationsHeader)
                        textStack.addArrangedSubview(notificationsText)
                    }
                }
                
                
            }
            
        }
        
    }
}
