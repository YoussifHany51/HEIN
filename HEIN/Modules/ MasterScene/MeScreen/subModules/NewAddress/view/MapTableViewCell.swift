//
//  MapTableViewCell.swift
//  HEIN
//
//  Created by Marco on 2024-09-16.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    var latitude : Double?
    var longitude: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure the cell's UI with data
    func configureMapCell() {
        mapView.removeAnnotations(mapView.annotations)
        
        let latitude : CLLocationDegrees = latitude ?? 30.033333
        let longitude : CLLocationDegrees = longitude ?? 31.233334
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        mapView.setRegion(region, animated: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
