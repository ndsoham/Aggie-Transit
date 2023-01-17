//
//  SearchResultsHeaderTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/12/23.
//

import Foundation
import UIKit

class SearchResultsHeaderTableViewCell: UITableViewCell {
    private var closeButton: UIButton = UIButton(type: .close)
    private var resultsLabel: UILabel = UILabel()
    private var resultsName: String = "Results"
    private var resultsNumberLabel: UILabel = UILabel()
    var resultsNumber: String?
    var closeDelegate: CloseDelegate?
    private var resultsStack: UIStackView = UIStackView()
    private var leftInset: Double?
    private var safeMargins: UILayoutGuide?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resultsNumber = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // create the results label etc
        self.contentView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        leftInset = 22.5 *  Double(self.contentView.frame.width/375)
        safeMargins = self.contentView.safeAreaLayoutGuide
        resultsStack = UIStackView()
        if let safeMargins = safeMargins, let leftInset = leftInset {
            // configure results stack
            resultsStack.axis = .vertical
            resultsStack.translatesAutoresizingMaskIntoConstraints = false
            resultsStack.spacing = 2.5
            resultsStack.alignment = .leading
            // add to view hierarchy
            self.contentView.addSubview(resultsStack)
            // add constraints
            resultsStack.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor, constant: leftInset).isActive = true
            resultsStack.centerYAnchor.constraint(equalTo: safeMargins.centerYAnchor).isActive = true
            // set up 
            if let resultsNumber = resultsNumber {
                let resultsAttributes: [NSAttributedString.Key:Any] = [
                    .font:UIFont.boldSystemFont(ofSize: 18),
                    .foregroundColor:UIColor(named: "textColor") ?? .black
                ]
                let numberAttributes: [NSAttributedString.Key:Any] = [
                    .font:UIFont.systemFont(ofSize: 14),
                    .foregroundColor:UIColor(named: "textColor")?.withAlphaComponent(0.75) ?? .black
                ]
                closeButton.translatesAutoresizingMaskIntoConstraints = false
                // configure label
                let attributedResults = NSAttributedString(string: resultsName, attributes: resultsAttributes)
                let attributedNumber = NSAttributedString(string: "\(resultsNumber) found", attributes: numberAttributes)
                resultsLabel.attributedText = attributedResults
                resultsNumberLabel.attributedText = attributedNumber
                // add to view hierarchy
                resultsStack.addArrangedSubview(resultsLabel)
                resultsStack.addArrangedSubview(resultsNumberLabel)
                // add to view hierarchy
                self.contentView.addSubview(closeButton)
                // add to view hierarchy
                closeButton.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor, constant: -leftInset).isActive = true
                closeButton.centerYAnchor.constraint(equalTo: safeMargins.centerYAnchor).isActive = true
                // add target
                closeButton.addTarget(self, action: #selector(handleCloseButtonPressed), for: .touchUpInside)
                
            }
            
            
        }
    }
}

extension SearchResultsHeaderTableViewCell {
    @objc func handleCloseButtonPressed(sender: UIButton) {
        if let closeDelegate = closeDelegate {
            closeDelegate.handleCloseButtonPressed(sender: sender)
        }
    }
}
