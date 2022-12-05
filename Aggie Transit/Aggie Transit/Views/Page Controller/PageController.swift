//
//  PageController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/5/22.
//

import Foundation
import UIKit
protocol PageControllerDelegate {
    func handlePageChanged(sender: UIButton)
}
class PageController:UIControl {
    var currentPageButton:UIButton?
    var delegate: PageControllerDelegate?
    var height: Double?
    var width: Double?
    var pageStack: UIStackView?
    var margins: UILayoutGuide?
    var buttonWidth: Double?
    var buttonHeight: Double?
    var recentsButton: UIButton?
    var favoritesButton: UIButton?
    var allRoutesButton: UIButton?
    let textColor = UIColor(named: "textColor")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        height = self.frame.height
        width = self.frame.width
        if let height = height, let width = width {
            // create the page stack
            pageStack = UIStackView()
            if let pageStack = pageStack {
                // configure the page stack
                pageStack.axis = .horizontal
                pageStack.distribution = .fillEqually
                pageStack.alignment = .center
                pageStack.isUserInteractionEnabled = true
                pageStack.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(pageStack)
                // constrain the stack
                margins = self.safeAreaLayoutGuide
                if let margins = margins {
                    pageStack.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
                    pageStack.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
                    pageStack.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
                    pageStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
                }
                buttonWidth = width / 3
                buttonHeight = 30 * (height/200)
                if let buttonWidth = buttonWidth, let buttonHeight = buttonHeight {
                    
                    recentsButton  = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
                    favoritesButton  = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
                    allRoutesButton  = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
                    if let recentsButton = recentsButton, let favoritesButton = favoritesButton, let allRoutesButton = allRoutesButton {
                        recentsButton.tag = 0; favoritesButton.tag = 1; allRoutesButton.tag = 2
                        // configure recents button normal state
                        recentsButton.configuration = UIButton.Configuration.plain()
                        recentsButton.configuration?.baseBackgroundColor = .clear
                        recentsButton.automaticallyUpdatesConfiguration = true
                        recentsButton.setTitle("Recents", for: .normal)
                        recentsButton.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                        recentsButton.setTitleColor(textColor, for: .normal)
                        // configure recents button selected state
                        let underlineAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.foregroundColor: textColor ?? UIColor()]
                        let recentsTitle = NSAttributedString(string: "Recents", attributes: underlineAttribute)
                        recentsButton.setAttributedTitle(recentsTitle, for: .selected)
                        recentsButton.setTitleColor(textColor, for: .selected)
                        // set recents button as selected by default
                        recentsButton.isSelected = true
                        // configure favorites button
                        favoritesButton.configuration = UIButton.Configuration.plain()
                        favoritesButton.configuration?.baseBackgroundColor = .clear
                        favoritesButton.automaticallyUpdatesConfiguration = true
                        favoritesButton.setTitle("Favorites", for: .normal)
                        favoritesButton.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                        favoritesButton.setTitleColor(textColor, for: .normal)
                        // configure favorite button selected state
                        let favoritesTitle = NSAttributedString(string: "Favorites", attributes: underlineAttribute)
                        favoritesButton.setAttributedTitle(favoritesTitle, for: .selected)
                        favoritesButton.setTitleColor(textColor, for: .selected)
                        // configure all routes button
                        allRoutesButton.configuration = UIButton.Configuration.plain()
                        allRoutesButton.configuration?.baseBackgroundColor = .clear
                        allRoutesButton.automaticallyUpdatesConfiguration = true
                        allRoutesButton.setTitle("All Routes", for: .normal)
                        allRoutesButton.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                        allRoutesButton.setTitleColor(textColor, for: .normal)
                        // configure recents button selected state
                        let allRoutesTitle = NSAttributedString(string: "All Routes", attributes: underlineAttribute)
                        allRoutesButton.setAttributedTitle(allRoutesTitle, for: .selected)
                        allRoutesButton.setTitleColor(textColor, for: .selected)
                        // handle button presses
                        recentsButton.addTarget(self, action: #selector(handlePageButtonPressed), for: .touchUpInside)
                        favoritesButton.addTarget(self, action: #selector(handlePageButtonPressed), for: .touchUpInside)
                        allRoutesButton.addTarget(self, action: #selector(handlePageButtonPressed), for: .touchUpInside)
                        // add buttons to a stack view
                        pageStack.addArrangedSubview(recentsButton)
                        pageStack.addArrangedSubview(favoritesButton)
                        pageStack.addArrangedSubview(allRoutesButton)
                        
                    }
                    
                    
                    
                }
                
                
            }
        }
        
    }
    @objc func handlePageButtonPressed(sender: UIButton){
        if let delegate = delegate{
            delegate.handlePageChanged(sender: sender)
            sender.isSelected = true
            if sender == recentsButton {
                if let favoritesButton = favoritesButton, let allRoutesButton = allRoutesButton {
                    favoritesButton.isSelected = false
                    allRoutesButton.isSelected = false
                }
            }
            else if sender == favoritesButton {
                if let recentsButton = recentsButton, let allRoutesButton = allRoutesButton {
                    recentsButton.isSelected = false
                    allRoutesButton.isSelected = false
                }
            }
            else if sender == allRoutesButton {
                if let favoritesButton = favoritesButton, let recentsButton = recentsButton {
                    favoritesButton.isSelected = false
                    recentsButton.isSelected = false
                }
            }
        }
    }
}

extension PageController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let allRoutesButton = allRoutesButton,  let recentsButton = recentsButton,  let favoritesButton = favoritesButton{
            if scrollView.currentPage == 0 {
                allRoutesButton.isSelected = false
                recentsButton.isSelected = true
                favoritesButton.isSelected = false
            }
            else if scrollView.currentPage == 1 {
                allRoutesButton.isSelected = false
                favoritesButton.isSelected = true
                recentsButton.isSelected = false
            }
            else if scrollView.currentPage == 2 {
                recentsButton.isSelected = false
                favoritesButton.isSelected = false
                allRoutesButton.isSelected = true
            }
        }
    }
}
