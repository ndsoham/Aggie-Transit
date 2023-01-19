//
//  TimeTableTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/15/23.
//

import Foundation
import UIKit

class TimeTableTableViewCell: UITableViewCell {
    private var safeMargins: UILayoutGuide?
    private var timeHorizontalStack: UIStackView? = UIStackView()
    var times: [Date?]?
    var cellColor: UIColor?
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
        timeHorizontalStack = UIStackView()
        safeMargins = self.contentView.safeAreaLayoutGuide
        self.contentView.backgroundColor = cellColor
        if let safeMargins, let times, let timeHorizontalStack {
            // configure time stack
            timeHorizontalStack.axis = .horizontal
            timeHorizontalStack.alignment = .center
            timeHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
            timeHorizontalStack.distribution = .equalSpacing
            // add and constrain
            self.contentView.addSubview(timeHorizontalStack)
            timeHorizontalStack.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor).isActive = true
            timeHorizontalStack.bottomAnchor.constraint(equalTo: safeMargins.bottomAnchor).isActive = true
            timeHorizontalStack.centerYAnchor.constraint(equalTo: safeMargins.centerYAnchor).isActive = true
            // add relevant labels
            for time in times {
                let dateFormatter = DateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm a")
                let strikeThroughAttribute: [NSAttributedString.Key:Any] = [
                    .strikethroughColor:UIColor(named: "textColor") ?? .black,
                    .strikethroughStyle:NSUnderlineStyle.single.rawValue,
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor:UIColor(named: "textColor")?.withAlphaComponent(0.5) ?? .black
                ]
                let sizeAttribute: [NSAttributedString.Key:Any] = [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor:UIColor(named: "textColor") ?? .black
                ]
                let label = UILabel()
                label.widthAnchor.constraint(equalToConstant: self.contentView.frame.width/Double(times.count)).isActive = true
                
                if let time {
                    label.attributedText = NSDate.now > time ? NSAttributedString(string: dateFormatter.string(from: time), attributes: strikeThroughAttribute):NSAttributedString(string: dateFormatter.string(from: time), attributes: sizeAttribute)
                    label.adjustsFontSizeToFitWidth = true
                    label.textAlignment = .center
                    timeHorizontalStack.addArrangedSubview(label)
                } else {
                    label.attributedText = NSAttributedString(string: "")
                    timeHorizontalStack.addArrangedSubview(label)
                }
            }
        }
    }
}
