//
//  HomeScreenMenuViewController+DataTasks.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/29/23.
//

import Foundation
import UIKit
import CoreData

extension HomeScreenMenuViewController {
    //MARK: - gather recent locations
    func fetchRecentLocations() {
        do {
            let request = RecentLocation.fetchRequest() as NSFetchRequest<RecentLocation>
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            var retrievedLocations = try container.viewContext.fetch(request)
            // delete some if more than ten locations are present
            if retrievedLocations.count > 10 {
                retrievedLocations = Array(retrievedLocations[...9])
                let locationsToBeDeleted = retrievedLocations[10...]
                for location in locationsToBeDeleted {
                    container.viewContext.delete(location)
                }
            }
            recentLocations = retrievedLocations
            try container.viewContext.save()
            DispatchQueue.main.async {
                self.defaultCollectionView?.reloadData()
            }
        } catch {
            let alert = UIAlertController(title: "Alert", message: "\(error.localizedDescription)", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
        
    }
}
