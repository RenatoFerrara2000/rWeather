//
//  Singleton.swift
//  ЯRweather
//
//  Created by Renato Ferrara on 25/03/24.
//
/*
import Foundation

class Singleton {
    static let shared = Singleton()
    
    let locationManager = LocationManager()
    
    let apiManager =  ApiManager()
    
    func fetchWeatherData() async {
        self.location = locationManager.location
        await viewModel.fetch(lat: location.latitude, long: location.longitude)
    
        
        locationManager.getLocationCity(lat: locationManager.location.latitude, long: locationManager.location.longitude) { cityName in
                self.city = cityName
            }
            
               
                 self.currentWeather = viewModel.currentWeather
           


                let measurement = Measurement(value: currentWeather.temperatura, unit: UnitTemperature.celsius)
                
                let measurementFormatter = MeasurementFormatter()
                measurementFormatter.unitStyle = .short
                measurementFormatter.numberFormatter.maximumFractionDigits = 0
                measurementFormatter.unitOptions = .temperatureWithoutUnit
                
                self.tempNow = measurementFormatter.string(from: measurement)
                dataFetched = true

        
            
        }
    
}
*/
