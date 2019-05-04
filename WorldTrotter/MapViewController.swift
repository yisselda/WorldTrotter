//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Yisselda Rhoc on 5/3/19.
//  Copyright © 2019 YR. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var userLocButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MKMapView()
        view = mapView
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
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
        
//        Button to track user's location
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("stuff")
    }
    
    @IBAction func showUserLocation(_ sender: UIButton) {
        print("Shit's happeneing")
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
}
