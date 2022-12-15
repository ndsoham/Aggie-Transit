//
//  Navigation View.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/19/22.
//

import Foundation
import UIKit
protocol BackButtonDelegate {
    func handleBackButtonPressed()
}
class NavigationView: UIView {
    var backButton: UIButton?
    var delegate: BackButtonDelegate?
    var screenNameLabel: UILabel?
    var screenNameText: String?
    var stackView: UIStackView?
    var backButtonHeight: Double?
    var backButtonWidth:Double?
    var screenNameHeight: Double?
    var screenNameWidth: Double?
    var textSize: Double?
    var height: Double?
    var width: Double?
    init(frame: CGRect, screenName: String) {
        self.screenNameText = screenName
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        layoutSubviews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        height = self.frame.height
        width = self.frame.width
        self.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        if let height = height, let width = width{
            // configure stackview
            stackView = UIStackView()
            if let stackView = stackView{
                stackView.axis = .horizontal
                stackView.distribution = .fill
                stackView.spacing = 0
                stackView.translatesAutoresizingMaskIntoConstraints = false
                // add stackview to view hierarchy
                self.addSubview(stackView)
                // constrain the stackview
                let margins = self.safeAreaLayoutGuide
                stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
                stackView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
                stackView.isUserInteractionEnabled = true
                // configure backButton
                backButtonHeight = height
                backButtonWidth = 30.0
                if let backButtonHeight = backButtonHeight, let backButtonWidth = backButtonWidth{
                    backButton = UIButton(frame: CGRect(x: 0, y: 0, width: backButtonWidth, height: backButtonHeight))
                    if let backButton = backButton{
                        backButton.translatesAutoresizingMaskIntoConstraints = false
                        backButton.setBackgroundImage(UIImage(systemName: "chevron.left"), for: .normal)
                        backButton.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
//                        backButton.configuration = UIButton.Configuration.plain()
                        backButton.tintColor = UIColor(named: "textColor")
                        backButton.automaticallyUpdatesConfiguration = true
                        // constraint backbutton
                        backButton.widthAnchor.constraint(equalToConstant: CGFloat(backButtonWidth)).isActive = true
                        backButton.heightAnchor.constraint(equalToConstant: CGFloat(backButtonHeight)).isActive = true
                        // add button to view hierarchy
                        stackView.addArrangedSubview(backButton)
                    }
                    // configure label
                    screenNameWidth = width - backButtonWidth
                    screenNameHeight = height
                    textSize = 34 * (height/44)
                    if let screenNameWidth = screenNameWidth, let screenNameHeight = screenNameHeight, let textSize = textSize{
                        screenNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenNameWidth, height: screenNameHeight))
                        if let screenName = screenNameLabel{
                            screenName.text = screenNameText
                            screenName.textAlignment = .left
                            screenName.textColor = UIColor(named: "textColor")
                            screenName.font = UIFont.boldSystemFont(ofSize: textSize)
                            screenName.translatesAutoresizingMaskIntoConstraints = false
                            // constraint label
                            screenName.widthAnchor.constraint(equalToConstant: screenNameWidth).isActive = true
                            screenName.heightAnchor.constraint(equalToConstant: screenNameHeight).isActive = true
                            // add label to view hierarchy
                            stackView.addArrangedSubview(screenName)
            }
                    }
                }
        }
        }
    }
    @objc func handleButtonPress(){
        if let delegate = delegate {
            delegate.handleBackButtonPressed()
        }
    }
}
