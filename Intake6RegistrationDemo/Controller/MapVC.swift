//
//  MapVC.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 7/10/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import MapKit

//MARK:- Data Send protocol
protocol SendAddress: class {
    func sendDetailedAddress(address: String)
}

class MapVC: UIViewController {
    //MARK:- Outlets.
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapLabel: UILabel!
    
    //MARK:- Variables.
    private let locationManager = CLLocationManager()
    weak var addressDelegate: SendAddress?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkWhenServiceEnabled()
        mapView.delegate = self
    }
    //MARK:- Submit button action.
    @IBAction func submitBttnTapped(_ sender: UIButton) {
        let address = mapLabel.text ?? "No Address found!"
        addressDelegate?.sendDetailedAddress(address: address)
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- Public Funation.
extension MapVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let lat = mapView.centerCoordinate.latitude
        let long = mapView.centerCoordinate.longitude
        let location = CLLocation(latitude: lat, longitude: long)
        getAddress(location: location)
    }
}
//MARK:- Private Funcations.
extension MapVC{
    
    private func getCurrentLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)
            getAddress(location: locationManager.location!)
        }
    }
    private func checkWhenServiceEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            chekForAuth()
            
        }else{
            print("Can't get location without Permission.")
        }
    }
    private func chekForAuth(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedAlways, .authorizedWhenInUse:
            getCurrentLocation()
        case .restricted, .denied:
            print("Can't get location without Permission.")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            print("Can't get location without Permission.")
        }
    }
    private func getAddress(location: CLLocation){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placeMark, error) in
            if let error = error {
                print("error is \(error)")
            } else if let firstPlaceMark = placeMark?.first{
                let detailedAddress = firstPlaceMark.compactAddress
                self.mapLabel.text = detailedAddress
            }
        }
    }
}
