//
//  MedicalViewController.swift
//  HealthPro
//
//  Created by User on 8/28/22.
//

import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController {

    // swiftlint:disable force_cast

    // MARK: Outlets
   
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties

    
    let shops = [Shop("Best vegetables!", coordinate: CLLocationCoordinate2D(latitude: 53.893009, longitude: 27.567444)),
                 Shop("Bon tomatto", coordinate: CLLocationCoordinate2D(latitude: 53.853009, longitude: 27.547444)),
                 Shop("Ogurec-Molode", coordinate: CLLocationCoordinate2D(latitude: 53.813009, longitude: 27.587444)),
                 Shop("Pizza Chikago", coordinate: CLLocationCoordinate2D(latitude: 53.883009, longitude: 27.517444)),
                 Shop("Antonio Prepessducci", coordinate: CLLocationCoordinate2D(latitude: 53.873009, longitude: 27.527444)),
                 Shop("Lavka", coordinate: CLLocationCoordinate2D(latitude: 53.893009, longitude: 27.537444)),
                 Shop("Chikanta Atlanta", coordinate: CLLocationCoordinate2D(latitude: 53.823009, longitude: 27.597444))]
    
    lazy var locationManager: CLLocationManager = {
            var manager = CLLocationManager()
            manager.distanceFilter = 10
            manager.desiredAccuracy = kCLLocationAccuracyBest
            return manager
        }()
    
    private var currentLocation: CLLocationCoordinate2D?
    private var currentPlace: CLPlacemark?
    
    // MARK: Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()
      
        mapView.delegate = self
        
        for shop in shops {
            mapView.addAnnotation(shop)
        }
        
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if locationManager.location?.coordinate != nil {
        zoomToLatestLocation(with: locationManager.location!.coordinate)
        } else {
            locationManager.requestLocation()
        }
        }
    
    func attempLocationAccess() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
          locationManager.requestWhenInUseAuthorization()
        } else {
          locationManager.requestLocation()
        }

    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
      manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else { return }

      CLGeocoder().reverseGeocodeLocation(firstLocation) { places, _ in
        guard let firstPlace = places?.first else { return }
    
        self.currentPlace = firstPlace
      }
    }
    
    // idn why this func need(i mean withot body), but without this app can crashs <3
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        
    }
    
    func mapThis(destinationCoord: CLLocationCoordinate2D) {
        let sourceCoordinate = (locationManager.location?.coordinate)!
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoord)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        directions.calculate {(response, error) in
            guard let response = response else {
                if let error = error {
                    print("somthing wrong: \(error.localizedDescription)")
                }
                return
            }
            
            let route = response.routes[0]
            
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
               let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
               mapView.setRegion(region, animated: true)
           }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = #colorLiteral(red: 0.4848885892, green: 0.6132636367, blue: 0.6663626269, alpha: 1).withAlphaComponent(0.6)
        render.lineWidth = 6
        
        return render
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let anot = view.annotation {
            self.mapThis(destinationCoord: anot.coordinate)
    }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.mapView.removeOverlays(mapView.overlays)
    }
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let annotation = annotation as? Shop else { return nil }
//            // 3
//            let identifier = "marker"
//            var view: MKMarkerAnnotationView
//            // 4
//            if let dequeuedView = mapView.dequeueReusableAnnotationView(
//              withIdentifier: identifier) as? MKMarkerAnnotationView {
//              dequeuedView.annotation = annotation
//              view = dequeuedView
//            } else {
//              // 5
//              view = MKMarkerAnnotationView(
//                annotation: annotation,
//                reuseIdentifier: identifier)
//              view.canShowCallout = true
//              view.calloutOffset = CGPoint(x: -5, y: 5)
//              view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            }
//            return view
//          }


}
