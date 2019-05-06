//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Yisselda Rhoc on 5/3/19.
//  Copyright © 2019 YR. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    var userLocButton: UIButton!
    var userLocation: CLLocation!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MKMapView()
        view = mapView
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        let topLayout = view.safeAreaLayoutGuide.topAnchor
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayout, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
//        Button to zoom in on user's location
//        Space it at the bottom right in relation to the bottomLayerGuide
        userLocButton = UIButton()
        view.addSubview(userLocButton)
        userLocButton.addTarget(self, action: #selector(showUserLocation(_:)), for: .touchUpInside)
        userLocButton.translatesAutoresizingMaskIntoConstraints = false
        userLocButton.setImage(UIImage(named: "marker"), for: .normal)
        userLocButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        userLocButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userLocButton.backgroundColor = .white
        userLocButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -8).isActive = true
        userLocButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 8).isActive = true
        userLocButton.layer.cornerRadius = 25
        userLocButton.layer.shadowColor = UIColor.gray.cgColor
        userLocButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        userLocButton.layer.shadowOpacity = 1.0
        
        locationManager.delegate = self
        
        // request permission to get user location when the app is in use (ie. active)
        // this will show an alert box to the user
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func showUserLocation(_ sender: UIButton) {
        // zoom in the map at user's location
        
        retriveCurrentLocation()
    }
    
    func retriveCurrentLocation(){
        let status = CLLocationManager.authorizationStatus()
        
        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
            // show alert to user telling them they need to allow location data to use some feature of your app
            return
        }
        
        // if haven't show location permission dialog before, show it to user
        if(status == .notDetermined){
            locationManager.requestWhenInUseAuthorization()
            
            // if you want the app to retrieve location data even in background, use requestAlwaysAuthorization
            // locationManager.requestAlwaysAuthorization()
            return
        }
        
        // at this point the authorization status is authorized
        // request location data once
        // if previously user has allowed the location permission, then request location
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
            locationManager.requestLocation()
        }
        
        // start monitoring location data and get notified whenever there is change in location data / every few seconds, until stopUpdatingLocation() is called
        // locationManager.startUpdatingLocation()
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        debugPrint("startLocating")
    }
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        debugPrint("stopLocating")
    }
    
    @objc
    func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .standard
        }
    }
    
    // called when the authorization status is changed for the core location permission
    // After user tap on 'Allow' or 'Disallow' on the dialog
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // .requestLocation will only pass one location to the locations array
        // hence we can access it by taking the first element of the array
        if let location = locations.first {
            userLocation = location
            let span = MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
            let currentRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            mapView.setRegion(currentRegion, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        // might be that user didn't enable location service on the device
        // or there might be no GPS signal inside a building
        
        // might be a good idea to show an alert to user to ask them to walk to a place with GPS signal
    }
}
