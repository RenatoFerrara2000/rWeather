//
//  Singleton.swift
//  ЯRweather
//
//  Created by Renato Ferrara on 25/03/24.
//

import Foundation
import CoreLocation
import CoreLocationUI
import SwiftUI

class Singleton: ObservableObject {
     
    init() {
        
    }
    static let shared = Singleton()
    
    let locationManager = LocationManager()
    
    let apiManager =  ApiManager()
     
    @Published var authChanged = false
    
     func getLocation(){
         locationManager.requestLocation()
          Task{
             let city =    await locationManager.getLocatonCityAsync()
         }
      }
    
    func getCity() async -> String{
        print("[SING] getting city\n")
     return   await locationManager.getLocatonCityAsync()
        }
    
    func fetchWeatherData() async throws -> Data? {
        print("[SING] getting weather Data \n")

        //Knowing location, get weather data from that location
        let data = await apiManager.fetch(lat: locationManager.location?.latitude ??  41.9028, long: locationManager.location?.longitude ?? 12.4964)
        
        return data
    }
    
}
            
