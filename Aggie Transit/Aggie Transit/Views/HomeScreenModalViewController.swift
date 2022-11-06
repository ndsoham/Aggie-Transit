//
//  HomeScreenModalViewController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/4/22.
//

import Foundation
import UIKit

class HomeScreenModalViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
    }
    func layoutSubviews() {
        let height = self.view.frame.height
        let width = self.view.frame.width
        // Scale height and width appropriately
        let searchBarHeight = height * (52/812)
        let searchBarWidth = width
        let searchBarImage = UIImage(named: "homeScreenSearchBar")
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 100, width: searchBarWidth, height: searchBarHeight))
        searchBar.searchTextField.placeholder = "Memorial Student Center (MSC)"
        searchBar.searchTextField.layer.cornerRadius = CGFloat(floatLiteral: 200)
        searchBar.searchBarStyle = .minimal
        self.view.addSubview(searchBar)
    }
}
