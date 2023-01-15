//
//  CustomAnnotations.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/13/23.
//

import Foundation
import MapKit
// used to differentiate between annotations
class BusAnnotation: MKPointAnnotation {var direction: CLLocationDirection?}
class LocationAnnotation: MKPointAnnotation {}
class EndpointAnnotation: MKPointAnnotation {}
// used to differentiate overlays
class BusRouteOverlay: MKPolyline {}
