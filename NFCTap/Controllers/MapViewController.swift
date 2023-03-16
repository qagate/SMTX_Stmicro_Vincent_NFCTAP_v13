//
//  MapViewController.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 23/04/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: ST25UIViewController , CLLocationManagerDelegate,MKMapViewDelegate, UIGestureRecognizerDelegate {

    private  var mOwnLocation : CLLocationCoordinate2D!
    var mSelectedLocation : CLLocationCoordinate2D!

    var mEditLocation : CLLocationCoordinate2D!

    var mPointsOfInterest = [MKPointAnnotation]()
    
    
    var mPinAnnotation = MKPointAnnotation()
    var mUserAnnotation = MKPointAnnotation()
    
    
    var delegate : LocationSelectionReady?
    
    @IBOutlet weak var mMapView: MKMapView!
    @IBOutlet weak var mCurrentLocationLabel: UILabel!
    @IBOutlet weak var mSelectedLocationLabel: UILabel!
    
    @IBAction func validateSelectedLocation(_ sender: UIButton) {
        delegate?.onLocationSelectionReady(location: mSelectedLocation)
        self.dismiss(animated: false, completion: nil)

    }
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPointsOfInterest.removeAll()
        
        locationManager.requestAlwaysAuthorization()
        checkLocationServices()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        
        mMapView.delegate = self
        mMapView.mapType = MKMapType(rawValue: 0)!
        
        let myCoordinates = locationManager.location
        setupMyOwnAnnotations(location: myCoordinates)
        
        setupSelectionAnnotations()
        
        self.locationManager.startUpdatingLocation()

        fitMapViewToAnnotaionList(annotations: mPointsOfInterest)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.triggerTouchAction(gestureReconizer:)))
        gestureRecognizer.delegate = self
        mMapView.addGestureRecognizer(gestureRecognizer)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
            warningAlert(message: "Location not enable, needed to see your position on the MAP")
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mMapView.showsUserLocation = true
        case .denied: // Show alert telling users how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mMapView.showsUserLocation = true
        case .restricted: // Show an alert letting them know what’s up
            break
        case .authorizedAlways:
            break
        @unknown default:
            //<#fatalError()#>
            print("Unknown status")
        }
    }
    
    private func setupMyOwnAnnotations(location: CLLocation?) {
        if  location != nil {
            let myloc = CLLocationCoordinate2D(latitude: (location!.coordinate.latitude), longitude: (location!.coordinate.longitude))
            mUserAnnotation = addAnnotation(coordinate: myloc, title: "You", subTitle: "", isAddedToMap: false)
            mOwnLocation = myloc
            
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        } else {
            mOwnLocation = mEditLocation
        }
        UpdateMyCoordinatesInTextField()
        
    }

    private func setupSelectionAnnotations() {
        if mEditLocation != nil {
          mSelectedLocation = mEditLocation
        }
        UpdateSelectedCoordinatesInTextFields()
        
        mPinAnnotation = addAnnotation(coordinate: mSelectedLocation, title: "Selected", subTitle: "Coordinates", isAddedToMap: true)

        mMapView.centerCoordinate = mPinAnnotation.coordinate;
        mMapView.setCenter(mPinAnnotation.coordinate, animated: true)
    }
    
    private func addAnnotation(coordinate : CLLocationCoordinate2D, title:String, subTitle:String, isAddedToMap : Bool) -> MKPointAnnotation {
        let myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = coordinate
        myAnnotation.title = title
        myAnnotation.subtitle = subTitle
        if isAddedToMap {
            mMapView.addAnnotation(myAnnotation)

        }
        mPointsOfInterest.append(myAnnotation)
        return myAnnotation
    }
    
    private func UpdateSelectedCoordinatesInTextFields() {
        mSelectedLocationLabel.adjustsFontSizeToFitWidth = true
        mSelectedLocationLabel.minimumScaleFactor = 0.2
        mSelectedLocationLabel.text = String("\(self.mSelectedLocation.latitude), \(self.mSelectedLocation.longitude)")
    }
    private func UpdateMyCoordinatesInTextField() {
        mCurrentLocationLabel.adjustsFontSizeToFitWidth = true
        mCurrentLocationLabel.minimumScaleFactor = 0.2
        mCurrentLocationLabel.text = String("\(self.mOwnLocation.latitude), \(self.mOwnLocation.longitude)")
    }
    
    func fitMapViewToAnnotaionList(annotations: [MKPointAnnotation]) -> Void {
        let mapEdgePadding = UIEdgeInsets(top: 50, left: 20, bottom: 20, right: 20)
        var zoomRect:MKMapRect = MKMapRect.null

        for index in 0..<annotations.count {
            let annotation = annotations[index]
            let aPoint:MKMapPoint = MKMapPoint(annotation.coordinate)
            let rect:MKMapRect = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)

            if zoomRect.isNull {
                zoomRect = rect
            } else {
                zoomRect = zoomRect.union(rect)
            }
        }

        mMapView.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
    }

    
    private func warningAlert(message : String) {
        UIHelper.warningAlert(viewController: self, title : "MAP view" , message: message)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        print("present location : \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
        mOwnLocation = CLLocationCoordinate2D(latitude: (newLocation.coordinate.latitude), longitude: (newLocation.coordinate.longitude))
        UpdateMyCoordinatesInTextField()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("present location : \(locations)")

    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pav:MKPinAnnotationView?
        if (pav == nil)
        {
            pav = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pav?.isDraggable = true
            pav?.canShowCallout = true;
        }
        else
        {
            pav?.annotation = annotation;
        }
        return pav;
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let lat = view.annotation?.coordinate.latitude
        let long = view.annotation?.coordinate.longitude

        //print("Clic pin lat \(lat) long \(long)")
        self.mSelectedLocation = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        UpdateSelectedCoordinatesInTextFields()
    }
    
    @objc func triggerTouchAction(gestureReconizer: UITapGestureRecognizer) {
          //Add alert to show it works
        let touchPoint = gestureReconizer.location(in: mMapView)
        let location = mMapView.convert(touchPoint, toCoordinateFrom: mMapView)
        //print ("\(location.latitude), \(location.longitude)")

        mMapView.removeAnnotation(mPinAnnotation)

        mSelectedLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)

        mPointsOfInterest.removeLast()
        mPinAnnotation = addAnnotation(coordinate: mSelectedLocation, title: "Selected", subTitle: "Coordinates", isAddedToMap: true)

        UpdateSelectedCoordinatesInTextFields()
}
    

}
