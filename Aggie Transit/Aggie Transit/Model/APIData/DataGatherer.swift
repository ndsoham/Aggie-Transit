//
//  DataParser.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/18/22.
//

import Foundation
import UIKit
protocol DataGathererDelegate {
    func didGatherBusRoutes(data: [BusRoute])
}
class DataGatherer {
    private let baseUrl = "https://transport.tamu.edu/BusRoutesFeed/api/"
    public var delegate: DataGathererDelegate?
    init(){}
    func gatherData(endpoint: String){
        let url = URL(string: baseUrl+endpoint)
        if let url = url{
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("An error has occured")
                    print(error.localizedDescription)
                }
                else {
                    guard let data = data else {
                        fatalError("An error has occured")
                    }
                    do {
                        let decoder = JSONDecoder()
                        if endpoint == "Routes" {
                            let routes = try decoder.decode([RouteData].self, from: data)
                            let busRoutes = self.busRoutes(data: routes)
                            self.delegate?.didGatherBusRoutes(data: busRoutes)
                        }
                    } catch {
                        print("An error has occured: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    func busRoutes(data: [RouteData]) -> [BusRoute] {
        var routes: [BusRoute] = []
        for route in data {
            let busRoute = BusRoute(Name: route.Name, Number: route.ShortName, Color: route.Color, Campus: route.Group.Name)
            routes.append(busRoute)
        }
        return routes
    }
}




