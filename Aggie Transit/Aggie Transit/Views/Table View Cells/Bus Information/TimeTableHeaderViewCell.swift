//
//  TimeTableHeaderViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/19/23.
//

import Foundation
import UIKit

class TimeTableHeaderViewCell: UITableViewHeaderFooterView {
    private var safeMargins: UILayoutGuide?
    private var labelStack: UIStackView = UIStackView()
    private let topInset: Double = 10
    var timeStops: [String]?
    //MARK: - initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.timeStops = nil
    }
    //MARK: - layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        // configure the content view
        self.contentView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        safeMargins = self.contentView.safeAreaLayoutGuide
        if let safeMargins, let timeStops {
            // configure the label stack
            labelStack.axis = .horizontal
            labelStack.translatesAutoresizingMaskIntoConstraints = false
            labelStack.distribution = .fill
            labelStack.spacing = 0
            // add to view hierarchy
            self.contentView.addSubview(labelStack)
            // add constraints
            labelStack.bottomAnchor.constraint(equalTo: safeMargins.bottomAnchor).isActive = true
            labelStack.topAnchor.constraint(equalTo: safeMargins.topAnchor).isActive = true
            // create attributed text
            let labelAttributes: [NSAttributedString.Key:Any] = [
                .font:UIFont.boldSystemFont(ofSize: 12),
                .foregroundColor:UIColor(named: "textColor") ?? .black
            ]
            // add necessary amount of labels
            for stop in timeStops {
                if stop == " " {
                    let label = UILabel()
                    label.text = "No service scheduled."
                    label.translatesAutoresizingMaskIntoConstraints = false
                    self.contentView.addSubview(label)
                    label.topAnchor.constraint(equalTo: safeMargins.topAnchor, constant: topInset).isActive = true
                    label.centerXAnchor.constraint(equalTo: safeMargins.centerXAnchor).isActive = true
                } else {
                    let label = UILabel()
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.widthAnchor.constraint(equalToConstant: self.contentView.frame.width/Double(timeStops.count)).isActive = true
                    let index = stop.index(stop.startIndex, offsetBy: 36)
                    label.attributedText = NSAttributedString(string: (String(stop[index...])), attributes: labelAttributes)
                    label.textAlignment = .center
                    label.numberOfLines = 0
                    labelStack.addArrangedSubview(label)
                }
            }
            
        }
    }
    
}
