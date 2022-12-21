//
//  Unnamed.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/16/22.
//

import UIKit

class HomeScreenModalTableViewCell: UITableViewCell {
    private let cornerRadius = 36.75
    private let borderWidth = 2.0
    private var width: Double?
    private var height: Double?
    private var view: UIView?
    private var viewHeight: Double?
    private var viewWidth: Double?
    private var margins: UILayoutGuide?
    private var viewMargins: UILayoutGuide?
    private var iconLabel: UILabel?
    private var customTextLabel: UILabel?
    private var stackView: UIStackView?
    var icon: String?
    var text: String?
    var cellColor: UIColor?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutSubviews()
    }
    required init?(coder: NSCoder){
        fatalError()
    }
    override func prepareForReuse() {
        self.clearsContextBeforeDrawing = true
    }
    override func layoutSubviews() {
        // access the views width and height
        width = self.contentView.frame.width
        height = self.contentView.frame.height
        self.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        if let width = width, let height = height {
            // add a subview to the view and shape it accordingly
            viewHeight = 86.25 * (122/height)
            viewWidth = 355 * (375/width)
            if let viewHeight = viewHeight, let viewWidth = viewWidth {
                view = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
                if let view = view, let cellColor = cellColor {
                    // configure the view
                    view.layer.cornerRadius = cornerRadius
                    view.layer.borderWidth = borderWidth
                    view.layer.borderColor = UIColor(named: "borderColor")?.cgColor
                    view.backgroundColor = cellColor
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
                    // create stack view
                    stackView = UIStackView()
                    if let stackView = stackView{
                    // configure stackView
                        stackView.alignment = .leading
                        stackView.distribution = .equalCentering
                        stackView.axis = .horizontal
                        stackView.spacing = 8
                        stackView.translatesAutoresizingMaskIntoConstraints = false
                        // add stackview to view hierarchy
                        view.addSubview(stackView)
                        // add constraints
                        viewMargins = view.safeAreaLayoutGuide
                        if let viewMargins = viewMargins {
                            stackView.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor,constant: 10).isActive = true
                            stackView.centerYAnchor.constraint(equalTo: viewMargins.centerYAnchor).isActive = true
                        }
                        // create icon label and text label
                        iconLabel = UILabel()
                        customTextLabel = UILabel()
                        if let iconLabel = iconLabel, let customTextLabel = customTextLabel, let icon = icon, let text = text {
                            iconLabel.text = icon
                            iconLabel.textColor = UIColor(named: "modalTableCellTextColor")
                            customTextLabel.text = text
                            customTextLabel.textColor = UIColor(named: "modalTableCellTextColor")
                            // add to view hierarchy
                            stackView.addArrangedSubview(iconLabel)
                            stackView.addArrangedSubview(customTextLabel)
                            
                        }
                    }
                    
                }
            }
            
        }
        
    }

}
enum cellBackgroundColor: String {
    case all = "all"
    case reveilleRed = "reveilleRed"
    case oldArmyGreen = "oldArmyGreen"
    case excelPink = "excelPink"
    case rudderGreen = "rudderGreen"
    case ringDanceBlue = "ringDanceBlue"
    case ewalkPurple = "ewalkPurple"
    case fishCampOrange = "fishCampOrange"
    case hullaballoBrown = "hullaballoBrown"
    case matthewGainesBrown = "matthewGainesBrown"
    case centuryTreeRed = "centuryTreeRed"
    case rellisBlue = "rellisBlue"
    case nightsAndWeekendsRed = "nightsAndWeekendsRed"
    case rellisCirculatorBlue = "rellisCirculatorBlue"
    case thursdayAndFridayGreen = "thursdayAndFridayGreen"
    case bonfirePurple = "bonfirePurple"
    case nightsAndWeekendsPurple = "nightsAndWeekendsPurple"
    case yellPracticeBlack = "yellPracticeBlack"
    case nightsAndWeekendsBrown = "nightsAndWeekendsBrown"
    case gigEmRed = "gigEmRed"
    case bushSchoolBlue = "bushSchoolBlue"
    case twelfthManGreen = "twelfthManGreen"
    case airportTeal = "airportTeal"
    case howdyPurple = "howdyPurple"
    case ringDayRed = "ringDayRed"
    case excelModifiedPink = "excelModifiedPink"
    case rudderModifiedGreen = "rudderModifiedGreen"
    case ewalkModifiedPurple = "ewalkModifiedPurple"
    case hullabalooModifiedBrown = "hullabalooModifiedBrown"
    case agronomyRdOrange = "agronomyRdOrange"
    case bonfireRed = "bonfireRed"
    case bushLibrarySalmon = "bushLibrarySalmon"
    case downtownBryanBlue = "downtownBryanBlue"
    case paraShuttleRed = "paraShuttleRed"
    case reedOlsenPink = "reedOlsonPink"
    case stotzerBlue = "stotzerBlue"
    case whrTeal = "whrTeal"
    case favoriteLocationGold = "favoriteLocationGold"
    case recentLocationRed = "recentLocationRed"
}
