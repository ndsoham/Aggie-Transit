//
//  DataParser.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/18/22.
//

import Foundation
class DataGatherer {
    private let baseUrl = "https://transport.tamu.edu/BusRoutesFeed/api/"
    init(){
        
    }
    func gatherData(endpoint: String) {
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
                        let json = try JSONSerialization.jsonObject(with: data)
                        print("These are the bus routes returned from the api and whether they are off or on campus and their color:")
                        let decoder = JSONDecoder()
                        let jsonDataObject = try JSONSerialization.data(withJSONObject: json)
                        let routes = try decoder.decode([BusRoute].self, from: jsonDataObject)
                        for route in routes{
                            print(route.Name, " - ", route.Group.Name, " - ", route.Color)
                        }
                        
                    } catch {
                        print("An error has occured: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
}
