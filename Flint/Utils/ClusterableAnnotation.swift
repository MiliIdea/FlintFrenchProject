//
//  ClusterableAnnotation.swift
//  Flint
//
//  Created by MILAD on 4/22/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation
import MapKit
import ClusterKit

class ClustrableAnnotation : NSObject, CKAnnotation{
    
    init(coordinate : CLLocationCoordinate2D , identifier : String) {
        self.coordinate = coordinate
        self.identifier = identifier
    }
    
    var cluster: CKCluster?
    
    var coordinate: CLLocationCoordinate2D
    
    var identifier : String
    
    var title: String? {
        return ""
    }
    
    var subtitle: String? {
        return ""
    }
}
