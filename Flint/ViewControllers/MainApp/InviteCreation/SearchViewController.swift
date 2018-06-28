//
//  SearchViewController.swift
//  Flint
//
//  Created by MILAD on 4/3/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreLocation
import MapKitGoogleStyler
import Alamofire
import CodableAlamofire


class SearchViewController: UIViewController ,MKMapViewDelegate{
    
    var searchCompleter = MKLocalSearchCompleter()
    
    var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    @IBOutlet weak var yourPositionButton: UIButton!
    
    @IBOutlet weak var tikButton: UIButton!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var flintL: UILabel!
    
    var resultCordinate : CLLocationCoordinate2D?
    
    var resultAdderess : String?
    
    var locationManager : CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        yourPositionButton.layer.cornerRadius = yourPositionButton.frame.width/2
        tikButton.layer.cornerRadius = tikButton.frame.width/2
        searchCompleter.delegate = self
        
        map.delegate = self
        
        // Fallback on earlier versions
        locationManager.requestAlwaysAuthorization()
        
        configureTileOverlay()
    
        self.searchResultsTableView.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.tapFunction))
        flintL.isUserInteractionEnabled = true
        flintL.addGestureRecognizer(tap)
    }
    
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: FirstMapViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(self.locationManager.location != nil ){
            let center = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.map.setRegion(region, animated: true)
            
//            let marker = MyAnnotation()
//            marker.coordinate = (self.locationManager.location?.coordinate)!
//            marker.identifier = "myPosition"
//
//            map.addAnnotation(marker)

        }
    }
    
    @IBAction func goProfile(_ sender: Any) {
        let vC : MainProfileViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainProfileViewController"))! as! MainProfileViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    @IBAction func goMessaging(_ sender: Any) {
        let vC : MainProfileViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainProfileViewController"))! as! MainProfileViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
        self.searchResultsTableView.alpha = 0
    }
    @IBAction func goMyPosition(_ sender: Any) {
        if(self.locationManager.location != nil ){
            let center = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.map.setRegion(region, animated: true)
        }
    }
    
    
    @IBAction func confirmLocation(_ sender: Any) {
        
        resultCordinate =  map.centerCoordinate
        
        let address = getAddressFromLatLon(pdblLatitude: (resultCordinate?.latitude.description)!, withLongitude: (resultCordinate?.longitude.description)!)
        
    }
    
    
    private func configureTileOverlay() {
        // We first need to have the path of the overlay configuration JSON
        guard let overlayFileURLString = Bundle.main.path(forResource: "map_style", ofType: "json") else {
            return
        }
        let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
        
        // After that, you can create the tile overlay using MapKitGoogleStyler
        guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
            return
        }
        
        // And finally add it to your MKMapView
        map.add(tileOverlay)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        self.map.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("inja ham select shod")
        resultCordinate =  view.annotation?.coordinate
        
        _ = getAddressFromLatLon(pdblLatitude: (resultCordinate?.latitude.description)!, withLongitude: (resultCordinate?.longitude.description)!)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
            annotationView?.canShowCallout = true
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.setBackgroundImage(UIImage.init(named: "Groupe 1484"), for: .normal)
            rightButton.backgroundColor = UIColor.white
            rightButton.tintColor = UIColor.clear
            rightButton.setImage(UIImage.init(named: "Groupe 1484"), for: .normal)
            rightButton.addTarget(self, action: #selector(self.didClickDetailDisclosure(button:)), for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = rightButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    @objc func didClickDetailDisclosure(button: UIButton) {
        
        print("selected")
        
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let coordinate = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        var span = mapView.region.span
        if span.latitudeDelta < 0.0001 { // MIN LEVEL
            span = MKCoordinateSpanMake(0.0001, 0.0001)
        } else if span.latitudeDelta > 0.6 { // MAX LEVEL
            span = MKCoordinateSpanMake(0.6, 0.6)
        }
        let region = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated:true)
    }
    
    
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String){
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    self.setAddressAndLocation()
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]

                    var addressString : String = ""
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + ", "
//                    }
//
//                    if pm.country != nil {
//                        addressString = addressString + pm.country! + ", "
//                    }
                    
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! 
                    }

                    
                    
                    self.resultAdderess = addressString
                    
                    self.setAddressAndLocation()
                }
        })
        
    }
    
    
    func setAddressAndLocation(){
        
        GlobalFields.inviteLocation = self.resultCordinate
        
        GlobalFields.inviteAddress = self.resultAdderess
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
}



extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchResultsTableView.alpha = 1
        searchCompleter.queryFragment = searchText
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            print(String(describing: coordinate))
            self.searchResultsTableView.alpha = 0
            self.view.endEditing(true)
            //call search In Location
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let l = GlobalFields.showLoading(vc: self)
            request(URLs.searchInlocation, method: .post , parameters: SearchInLocationRequestModel.init(lat: (coordinate?.latitude.description)!, long: (coordinate?.longitude.description)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<[SearchInLocationRes]>>) in
                
                let res = response.result.value
                l.disView()
                if(res?.status == "success" && res?.data != nil && (res?.data?.count)! > 0){
                    for p in (res?.data)!{
                        let marker = MyAnnotation()
                        marker.coordinate = .init(latitude: Double(p.st_y!)!, longitude: Double(p.st_x!)!)
//                        marker.identifier = p.title
                        marker.identifier = "myAnnotation"
                        marker.title = p.title
                        
                        self.map.addAnnotation(marker)
                    }
                }
                
                self.map.setCenter(coordinate!, animated: true)
                
            }
            
        }
    }
}




















