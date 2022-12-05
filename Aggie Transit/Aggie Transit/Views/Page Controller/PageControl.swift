//
//  PageControl.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/1/22.
//

import Foundation
import UIKit
protocol PageControlDelegate {
    func handlePageChanged(sender: UIButton)
}
class PageControl: UIControl {
    lazy var currentPage: Int? = 0 {
        didSet{
            if let currentPage = currentPage {
                currentPageButton = currentPages[currentPage]
            }
        }
    }
    var currentPageButton: UIButton?
    var delegate: PageControlDelegate?
    var pages: [String]?
    var currentPages: [UIButton] = []
    var height: Double?
    var width: Double?
    var pageStack: UIStackView?
    var margins: UILayoutGuide?
    var buttonWidth: Double?
    var buttonHeight: Double?
    let textColor = UIColor(named: "textColor")
    init(frame: CGRect, pages: [String]) {
        self.pages = pages
        super.init(frame: frame)
        layoutSubviews()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        height = self.frame.height
        width = self.frame.width
        if let height = height, let width = width{
            // create the page stack
            pageStack = UIStackView()
            if let pageStack = pageStack{
                // configure the pageStack
                pageStack.axis = .horizontal
                pageStack.distribution = .fillEqually
                pageStack.alignment = .center
                pageStack.isUserInteractionEnabled = true
                pageStack.translatesAutoresizingMaskIntoConstraints = false
                // add the stack to the view hierarchy
                self.addSubview(pageStack)
                // constrain the stack
                margins = self.safeAreaLayoutGuide
                if let margins = margins {
                    pageStack.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
                    pageStack.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
                    pageStack.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
                    pageStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
                }
                if let pages = pages {
                        buttonWidth = width / Double(pages.count)
                        buttonHeight = 30 * (height/200)
                        if let buttonWidth = buttonWidth, let buttonHeight = buttonHeight{
                            for i in 0 ..< pages.count {
                                let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
                                button.configuration = UIButton.Configuration.plain()
                                button.automaticallyUpdatesConfiguration = true
                                button.setTitle(pages[i], for: .normal)
                                button.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                                button.setTitleColor(textColor, for: .normal)
                               // configure selected button state
                                let underlineAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.foregroundColor: textColor ?? UIColor()]
                                let underlinedTitle = NSAttributedString(string: pages[i], attributes: underlineAttribute)
                                button.setAttributedTitle(underlinedTitle, for: .selected)
                                button.setTitleColor(textColor, for: .selected)
                                // handle the button presses
                                button.addTarget(self, action: #selector(handlePageIndicatorChange), for: .touchUpInside)
                                button.tag = i
                                pageStack.addArrangedSubview(button)
                                currentPages.append(button)
                                if i == 0 {
                                    currentPageButton = button
                                    button.isSelected = true
                                }
                            }
                        }
                    
                }
                
            }
            
        }
    }
    @objc func handlePageIndicatorChange(sender: UIButton){
        if  !sender.isSelected {
            sender.isSelected = true
        }
        if sender != currentPageButton {
            for button in currentPages {
                if button != sender{
                    button.isSelected = false
                }
            }
        }
        
        delegate?.handlePageChanged(sender: sender)
    }
}

