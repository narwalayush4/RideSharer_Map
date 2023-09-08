//
//  MapViewController.swift
//  RideSharer
//
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        // Request location access from the user
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // if this function is called in viewDidLoad(), the alert dialog does not show, i guess because the map view is shown on top of it
        showLocation()
    }
    
    func showLocation() {
        let status = locationManager.authorizationStatus
        print("has location access")
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            editMap(location: locationManager.location!)
            print("allowed")
        case .denied, .restricted:
            showAlert()
            print("denied")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            print("not determined")
        @unknown default:
            print("fatal error")
            fatalError()
        }
    }
    
    func editMap(location : CLLocation) {
        
        // Center the map view on the user's location
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        // Add an annotation to the map view to mark the user's location
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "Your Location"
        mapView.addAnnotation(annotation)
        
        print("edit map func")
    }
    
    func showAlert(){
        // Create an alert to tell the user that they have not provided permission
        let alert = UIAlertController(title: "Location Access Denied", message: "Please enable location access in your device settings.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        
        // Add the action to the alert
        alert.addAction(action)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
        
        print("show alert")
    }
}




//MARK: - CLLocationManagerDelegate
extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        print(location)
    
        editMap(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // when the user is asked for permission for the first time after installing the app, initially its undetermined and when the user the allows/denies it the app only gets to know when its restarted the next time
        // so this delegate method notifies the app when the authorization was changed and the app can perform accordingly
        showLocation()
    }
}

