
import CoreLocation
import CoreLocationUI
import SwiftUI

 
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    var location: CLLocationCoordinate2D?
    
    var city: String?

    var tempCity: String
    @Published var authChanged = false
 
    //location initialized to rome in case user doesn't share location

    override init() {
        self.tempCity = "Nowhere"
        self.city = "Nowhere"
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
 
    }

    func requestLocation() {
           manager.requestLocation()
    }
 
    
    //update current to location to the last location found
    @MainActor func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){

        let locationCll =  CLLocation(latitude: self.location?.latitude ?? 41.902 , longitude: self.location?.longitude ?? 12.496)
        location = locations.last!.coordinate
        let distance = locations.last!.distance(from: locationCll)
        if(distance > 10000) // trigger a fetch if the distance is more than 10km
        {
            print("You changed location")
            Singleton.shared.authChanged = true
        
        }
            
       }
 
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("AUTH CHANGED \n")
         switch manager.authorizationStatus{
        case .notDetermined:
            manager.requestAlwaysAuthorization()
         case .restricted:
            // show message
            print("Location restricted")
            location = CLLocationCoordinate2D(latitude:41.902, longitude: 12.496)
            self.tempCity = "Rome"

        case .denied:
            print("Location DENIED")
            location = CLLocationCoordinate2D(latitude:41.902, longitude: 12.496)
            self.tempCity = "Rome"

            //if no location given, set Rome as location
        case .authorizedWhenInUse, .authorizedAlways:
            /// app is authorized
             manager.startUpdatingLocation()
             manager.requestLocation()
 
              default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error determining location:", error, "Trying again")
     }
    
    
    
    func getLocatonCityAsync() async -> String {
        // Wait for location if not available
        if location == nil {
            manager.requestLocation()
            // Wait a bit for location to be updated
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        }
        
        manager.stopUpdatingLocation()
        let geoCoder = CLGeocoder()
        let locationRev = CLLocation(
            latitude: self.location?.latitude ?? 41.902,
            longitude: self.location?.longitude ?? 12.496
        )
        
        do {
            let placemark = try await geoCoder.reverseGeocodeLocation(locationRev)
            let city = placemark.first?.subAdministrativeArea ?? "Rome"
            self.city = city
            manager.startUpdatingLocation()
            return city
        } catch {
            print("error geocoder: \(error)")
            manager.startUpdatingLocation()
            return "Rome"
        }
    }
 
    
    
}
