//
//  MapViewController.swift
//  HEIN
//
//  Created by Marco on 2024-09-16.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // MARK: - Properties
    var locationManager = CLLocationManager()
    var selectedCoordinates: CLLocationCoordinate2D?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the map view
        //mapView.frame = self.view.frame
        mapView.delegate = self
        mapView.showsUserLocation = true
        //self.view.addSubview(mapView)
        
        // Request location permission and start location updates
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Add a tap gesture recognizer to the map
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        mapView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Zoom into user's current location
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            
            // Drop a pin at the user's initial location
            dropPin(at: location.coordinate)
            
            // Set selected location to the user's initial location
            selectedCoordinates = location.coordinate
            
            // Stop updating the location after the first fetch to save battery
            locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: - Handle Tap Gesture
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let touchLocation = gestureRecognizer.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        // Remove any existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Drop a pin at the selected location
        dropPin(at: locationCoordinate)
        
        // Save the selected coordinates
        selectedCoordinates = locationCoordinate
        
        // Print the latitude and longitude for debugging
        print("Selected Location - Latitude: \(locationCoordinate.latitude), Longitude: \(locationCoordinate.longitude)")
    }

    // MARK: - Drop Pin Method
    func dropPin(at coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmLocation(_ sender: Any) {
        guard let selectedCoordinates = selectedCoordinates else {return}
        print("\(selectedCoordinates.latitude), \(selectedCoordinates.longitude)")
    }
}

