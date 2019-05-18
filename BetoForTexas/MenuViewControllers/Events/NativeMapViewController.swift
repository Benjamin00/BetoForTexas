//
//  NativeMapViewController.swift
//  BetoForTexas
//
//  Created by Benjamin on 6/23/18.
//  Copyright © 2018 BenjaminHill. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import CoreData

class NativeMapViewController: UIViewController {
    //let dateFormatter = DateFormatter()
    var locations: [Locations] = []
    let regionRadius: CLLocationDistance = 1000000
    var nameArray = [String]()
    @IBOutlet weak var mapView: MKMapView!
    
    //Struct holds all the event data
    struct EventList : Decodable {
        let events: [LocationsDec]
        static func endpointForTodos() -> String {
            //HIDE API CALL HERE
        }
        enum BackendError: Error {
            case urlError(reason: String)
            case objectSerialization(reason: String)
        }
        //Function to get all the events from the json response
        static func allEvents(completionHandler: @escaping (EventList?, Error?) -> Void) {
            let endpoint = EventList.endpointForTodos()
            guard let url = URL(string: endpoint) else {
                print("Error: cannot create URL")
                let error = BackendError.urlError(reason: "Could not construct URL")
                completionHandler(nil, error)
                return
            }
            let urlRequest = URLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest) {
                (data, response, error) in
                guard let responseData = data else {
                    print("Error: did not receive data")
                    completionHandler(nil, error)
                    return
                }
                guard error == nil else {
                    completionHandler(nil, error)
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let events = try decoder.decode(EventList.self, from: responseData)
                    //let event: [EventList] = [events]
                    completionHandler(events, nil)
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                    completionHandler(nil, error)
                }
            }
            task.resume()
        }
        
    }

    override func viewDidLoad() {
        mapView.delegate = self
        //bBut.layer.cornerRadius = 10
        super.viewDidLoad()
        let locationManager = CLLocationManager()
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 2400, 2400)
            mapView.setRegion(viewRegion, animated: false)
        }
        
        self.locationManager = locationManager
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        let radius: CLLocationDistance = 8046.72
       // print("Events in a 5 mile radius" , radiusSearchPoints(coordinate: (locationManager.location?.coordinate)!, radius: radius))
        gotAllEvents(completion: addDataToMap)
        
    }

    func gotAllEvents(completion: (Bool)->Void) {
        //calls the structure's static function to get the events.
        EventList.allEvents { (events, error) in
            if let error = error {
                // got an error in getting the data
                print(error)
                return
            }
            guard let events = events else {
                print("error getting all events: result is nil")
                return
            }
            // success :)
            //add the data to the map
            DispatchQueue.main.async {
                 self.mapView.addAnnotations(events.events)
            }
           
        }
        completion(true)
    }
    
    func addDataToMap(value: Bool) {
        if value {
            print("Response completed, got all data")
            //mapView.addAnnotations(locations)
        }
    }
    internal func radiusSearchPoints(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) -> Int
    {
        var points: [CLLocationCoordinate2D] = []
        let earthRadius = 6378100.0
        let π = Double.pi
        
        let lat = coordinate.latitude * π / 180.0
        let lng = coordinate.longitude * π / 180.0
        
        for t in stride(from: 0, to: 2 * π, by: 0.3)
        {
            let pointLat = lat + (radius / earthRadius)  * sin(t)
            let pointLng = lng + (radius / earthRadius) * cos(t)
            
            let point = CLLocationCoordinate2D(latitude: pointLat * 180 / π, longitude: pointLng * 180 / π)
            points.append(point)
        }
        
        return points.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    //Get Location
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

}

extension NativeMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // check if location object
        //print("Inside mapview for annotation")
        if (annotation is MKUserLocation) {
            return nil
        }
        else{
        let annotation = annotation as! LocationsDec
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
            return view
        }
        
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! LocationsDec
        let url2 = location.url
        print("callout Accessory Control Tapped")
        UIApplication.shared.open(url2, options: [:])
    }
}

