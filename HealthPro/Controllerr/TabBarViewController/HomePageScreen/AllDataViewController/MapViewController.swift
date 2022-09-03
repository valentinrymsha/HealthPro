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

    
    let shops = [Shop("Emirates Stadium", coordinate: CLLocationCoordinate2D(latitude: 53.893009, longitude: 27.567444)),
                 Shop("Emirates sss", coordinate: CLLocationCoordinate2D(latitude: 53.853009, longitude: 27.547444)),
                 Shop("Emirates Stadium", coordinate: CLLocationCoordinate2D(latitude: 53.813009, longitude: 27.587444))]
    
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
        zoomToLatestLocation(with: locationManager.location!.coordinate)
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
        render.lineWidth = 4
        
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

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    }
}
