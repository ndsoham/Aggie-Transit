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
    var onCampusRoutes: [BusRoute]?
    var offCampusRoutes: [BusRoute]?
    var dataGatherer: DataGatherer = DataGatherer()
    var listCollectionView: UICollectionView?
    var singleColumnLayout: SingleColumnLayout = SingleColumnLayout()
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
    }
}


