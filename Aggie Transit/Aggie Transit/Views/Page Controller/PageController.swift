//
//  PageController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/16/22.
//

import Foundation
import UIKit
class PageController: UIControl {
    let numPages: Int
    let pageNames: [String]
    var currentPage: Int = 0
    init(frame: CGRect, numPages: Int, pageNames: [String]) {
        self.numPages = numPages
        self.pageNames = pageNames
        super.init(frame: frame)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        self.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        self.isUserInteractionEnabled = true
        let height = self.frame.height
        let width = self.frame.width
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        stackView.isUserInteractionEnabled = true
        // configure stackview
        self.addSubview(stackView)
        let margins = self.safeAreaLayoutGuide
        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 14 * (375/width)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = true
        // add buttons to stacview based on the number of pages
        for i in 0..<numPages {
            let buttonWidth = 125 * (375/width)
            let buttonHeight = 30
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: Int(buttonWidth), height: buttonHeight))
            button.setTitle(pageNames[i], for: .normal)
            button.setTitleColor(UIColor(named: "textColor"), for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(handlePageIndicatorChange), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            
        }
    }
    @objc func handlePageIndicatorChange(sender: UIButton){
        if let senderTitle = sender.currentTitle {
            print(senderTitle)
        }
    }
}
