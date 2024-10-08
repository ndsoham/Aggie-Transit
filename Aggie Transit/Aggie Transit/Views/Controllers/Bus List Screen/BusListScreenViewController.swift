//
//  BusListScreenViewController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/28/23.
//

import Foundation
import UIKit

class BusListScreenViewController: UIViewController {
    //MARK: - attributes
    var busRoutes: [BusRoute]?
    var filteredBusRoutes: [BusRoute] = []
    var dataGatherer: DataGatherer = DataGatherer()
    var listCollectionView: UICollectionView?
    var singleColumnLayout: SingleColumnLayout = SingleColumnLayout()
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var filter: String = "On Campus"
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataTask()
        layoutSubviews()
    }
    //MARK: - setup ui
    func layoutSubviews() {
        setupSelf()
        setupCollectionView()
        setupActivityIndicator()
    }
}


