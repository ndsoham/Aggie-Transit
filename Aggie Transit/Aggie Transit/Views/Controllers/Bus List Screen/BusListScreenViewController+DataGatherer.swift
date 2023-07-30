//
//  BusListScreenViewController+DataGatherer.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/28/23.
//

import Foundation
import UIKit

extension BusListScreenViewController {
    //MARK: - handle data tasks
    func dataTask() {
        dataGatherer.gatherBusRoutes{
            self.busRoutes = $0
            DispatchQueue.main.async {
                self.listCollectionView?.reloadData()
            }
        }
    }
}
