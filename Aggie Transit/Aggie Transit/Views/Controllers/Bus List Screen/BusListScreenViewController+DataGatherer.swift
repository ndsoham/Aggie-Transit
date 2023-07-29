//
//  BusListScreenViewController+DataGatherer.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/28/23.
//

import Foundation
import UIKit

extension BusListScreenViewController: DataGathererDelegate {
    //MARK: - handle data tasks
    func dataTask() {
        // TODO:
        dataGatherer.delegate = self
        dataGatherer.gatherData(endpoint: "routes")
    }
    //MARK: - handle refreshing collection view after data has been gathered
    func didGatherBusRoutes(routes: [BusRoute]) {
        self.busRoutes = routes
        DispatchQueue.main.async {
            self.listCollectionView?.reloadData()
        }
    }
}
