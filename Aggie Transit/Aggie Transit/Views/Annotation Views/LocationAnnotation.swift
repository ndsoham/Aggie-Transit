//
//  LocationAnnotation.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/3/23.
//

import Foundation
import MapKit
protocol RouteGenerationProgressDelegate {
    func routeGenerationDidStart()
    func routeGenerationDidEnd()
}
protocol RouteDisplayerDelegate {
    func displayRouteOnMap(userLocation: CLLocationCoordinate2D, firstStop: BusStop, secondStop: BusStop, destinationStop: BusStop, initialStop: BusStop)
}

// used to differentiate between annotations
class LocationAnnotation: MKPointAnnotation {
    
}

class LocationAnnotationView: MKAnnotationView {
    private var directionsButton: UIButton?
    private var directionsButtonHeight: Double?
    private var favoritesButton: UIButton?
    private var favoritesButtonHeight: Double?
    private var nameLabel: UILabel?
    private var addressLabel: UILabel?
    private var stackView: UIStackView?
    private var buttonStack: UIStackView?
    private var width: Double?
    private var height: Double?
    private var safeMargins: UILayoutGuide?
    public var routeGenerationDelegate: RouteGenerationProgressDelegate?
    public var routeDisplayerDelegate: RouteDisplayerDelegate?
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 175, height: 84)
        clusteringIdentifier = "location"
    }
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        self.nameLabel?.isHidden = true
        self.addressLabel?.isHidden = true
        self.favoritesButton?.isHidden = true
        self.directionsButton?.isHidden = true
        super.prepareForReuse()
    }
    override func prepareForDisplay() {
        super.prepareForDisplay()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        height = self.frame.height
        width = self.frame.height
        self.backgroundColor = UIColor(named:"launchScreenBackgroundColor")
        self.layer.cornerRadius = 15
        if let height = height, let width = width {
            directionsButtonHeight = 20 * (height/84)
            favoritesButtonHeight = directionsButtonHeight
            stackView = UIStackView()
            buttonStack = UIStackView()
            nameLabel = UILabel()
            addressLabel = UILabel()
            safeMargins = self.safeAreaLayoutGuide
            if let nameLabel = nameLabel, let addressLabel = addressLabel, let directionsButtonHeight = directionsButtonHeight, let favoritesButtonHeight = favoritesButtonHeight, let stackView = stackView, let buttonStack = buttonStack, let safeMargins = safeMargins {
                // confiure vertical stack view
                stackView.axis = .vertical
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.spacing = 0//5 * (height/84)
                stackView.alignment = .center
                stackView.clipsToBounds = true
                // add to view hierarchy
                self.addSubview(stackView)
                // add constraints
                stackView.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor,constant: 2 * (width/175)).isActive = true
                stackView.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor,constant: -2 * (width/175)).isActive = true
                stackView.centerYAnchor.constraint(equalTo: safeMargins.centerYAnchor).isActive = true
                
                
                // configure the text label
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                nameLabel.textAlignment = .center
                addressLabel.translatesAutoresizingMaskIntoConstraints = false
                addressLabel.textAlignment = .center
                nameLabel.clipsToBounds = true
                addressLabel .clipsToBounds = true
                addressLabel.lineBreakMode = .byTruncatingTail
                nameLabel.lineBreakMode = .byTruncatingTail
                nameLabel.numberOfLines = 0
                addressLabel.numberOfLines = 0
                guard let name = annotation?.title, let address = annotation?.subtitle else {return}
                let nameAttributes: [NSAttributedString.Key:Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 12 * (height/84)),
                    .foregroundColor : UIColor(named: "textColor") ?? .black
                ]
                let addressAttributes: [NSAttributedString.Key:Any] = [
                    .font : UIFont.systemFont(ofSize: 10 * (height/84)),
                    .foregroundColor: UIColor(named: "textColor") ?? .black
                ]
                nameLabel.attributedText = NSAttributedString(string: name!, attributes: nameAttributes)
                addressLabel.attributedText = NSAttributedString(string: address!, attributes: addressAttributes)
                // add the label to the view hierarchy
                stackView.addArrangedSubview(nameLabel)
                stackView.addArrangedSubview(addressLabel)
                // configure the horizontal stack view
                buttonStack.axis = .horizontal
                buttonStack.translatesAutoresizingMaskIntoConstraints = false
                buttonStack.spacing = 2 * (width/175)
                buttonStack.alignment = .leading
                // add to view hierarcy
                stackView.addArrangedSubview(buttonStack)
                // configure the buttons
                favoritesButton = UIButton(type: .system)
                directionsButton = UIButton(type: .system)
                if let favoritesButton = favoritesButton, let directionsButton = directionsButton {
                    favoritesButton.backgroundColor = UIColor(named: "favoriteLocationGold")
                    favoritesButton.setTitle("⭐️", for: .normal)
                    directionsButton.backgroundColor = .systemBlue
                    directionsButton.setTitle("Directions", for: .normal)
                    favoritesButton.translatesAutoresizingMaskIntoConstraints = false
                    directionsButton.translatesAutoresizingMaskIntoConstraints = false
                    favoritesButton.layer.cornerRadius = 5
                    directionsButton.layer.cornerRadius = 5
                    favoritesButton.addTarget(self, action: #selector(handleFavoritesPressed), for: .touchUpInside)
                    directionsButton.addTarget(self, action: #selector(handleDirectionsPressed), for: .touchUpInside)
                    // add to view hierarchy
                    buttonStack.addArrangedSubview(favoritesButton)
                    buttonStack.addArrangedSubview(directionsButton)
                    // add constraints
                    favoritesButton.heightAnchor.constraint(equalToConstant: favoritesButtonHeight).isActive = true
                    directionsButton.heightAnchor.constraint(equalToConstant: directionsButtonHeight).isActive = true
                    
                }
            }
            
        }
        
    }
}
//MARK: - Handle the buttons being pressed
extension LocationAnnotationView {
    @objc func handleDirectionsPressed(sender: UIButton){
        if let annotation = annotation, let title = annotation.title, let name = title, let subtitle = annotation.subtitle, let address = subtitle {
            let destination = Location(name: name, location: annotation.coordinate, address: address)
            let userLocation = Location(name: "User Location", location: CLLocationCoordinate2D(latitude: 30.62822498626818, longitude: -96.33642686215725), address: "Northpoint Crossing") // Northpoint:CLLocationCoordinate2D(latitude: 30.62822498626818, longitude: -96.33642686215725), Rise: CLLocationCoordinate2D(latitude: 30.621679228296554, longitude: -96.34257448521092), park west: CLLocationCoordinate2D(latitude: 30.599508211117378, longitude: -96.3417951323297), MSC: CLLocationCoordinate2D(latitude: 30.612474654010782, longitude: -96.3415856495476), 
            guard let destinationRoutesAndStops = RouteGenerator.shared.findRelevantBusRoutesAndClosestStops(location: destination) else {
                print("No Routes are available.")
                return
            }
            guard let userRoutesAndStops = RouteGenerator.shared.findRelevantBusRoutesAndClosestStops(location: userLocation) else {
                print("No Routes are available.")
                return
            }
            RouteGenerator.shared.findClosestBusStops(destination: destination, destinationRoutesAndStops: destinationRoutesAndStops, userRoutesAndStops: userRoutesAndStops, userLocation: userLocation) {
                print("Route Generation Successful ---")
                let (start, stops, finish, travel) = $0
                print(start.name, "-> ", terminator: "")
                for (route, stop) in stops {
                    print(stop.name,terminator: "(\(route.name) - \(route.number)) ->")
                }
                print(finish.name, travel, separator: ":")
            }
           
            if let routeGenerationDelegate = routeGenerationDelegate {
                routeGenerationDelegate.routeGenerationDidStart()
            }
        }
    }
    @objc func handleFavoritesPressed(sender: UIButton){
        print("implement this method")
        print(self.annotation?.title, self.annotation?.subtitle)
    }
}

