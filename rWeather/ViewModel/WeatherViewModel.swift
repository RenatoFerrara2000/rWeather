//
//  WeatherViewModel.swift
//  Rweather
//
//  Created by Renato Ferrara on 14/11/23.
//

import Foundation
import Network
import SwiftUI
  @MainActor
  class WeatherViewModel: ObservableObject {
    var weatherData: WeatherData
      var tempCity: String
    @Published var city: String
    @Published var dailyData: dailyDataValues
    @Published var currentWeather: dataWeather
    @Published var currentTime: String
    @Published var  tempNow: String
 
    
    init() {
        self.weatherData = WeatherData()
        self.dailyData = dailyDataValues()
        self.city = ""
        self.tempNow = ""
        self.currentWeather = dataWeather()
        self.currentTime =  ""
        self.tempCity = "test"
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: UIApplication.willEnterForegroundNotification, object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .locationUpdatedNotification, object: nil)
 
    }
      //not sure of the need 
      deinit {
             NotificationCenter.default.removeObserver(self)
         }
      
      @objc func handleNotification() {
           Task{
              await fetchData()
           }
         }
    
   
    
      func fetchData() async {
          print("=== Starting fetchData ===")
          await fetchLocation()
          print("City: \(city)")
          print("Location coords: \(Singleton.shared.locationManager.location?.latitude ?? 0), \(Singleton.shared.locationManager.location?.longitude ?? 0)")
          
          await fetchWeather()
       }
    
    //func to get city
     func fetchLocation() async{
         
          self.city =  await Singleton.shared.getCity()
        print("[WVM] city is:" , self.city.description , "\n\n")
    }
    
    //function to get data from open meteo
    func fetchWeather( ) async{
        do {
            let dataW = try await Singleton.shared.fetchWeatherData() ?? Data()
            
            let weatData = try JSONDecoder().decode(WeatherData.self, from: dataW)
            
            self.weatherData = weatData
            
            self.StructBuilder(weatherData: weatData)
            
            
        
            
        }catch {
            // Handle error appropriately
            print("[WVM] Error decoding weather data:", error)
        }
    }
    //function to build up data so that it gets only the weather from now to 24hours in the future
    func StructBuilder(weatherData: WeatherData){
        
        var data: dailyDataValues = dailyDataValues()
        _ = weatherData.hourly?.time?[0] ?? "t"
        
        //Get device current data in right format
        var currentTime: String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd'T'HH"
         return dateFormatter.string(from: Date.now)
         }
        
         
        var counter: Int = 0
        for i in 0...24 {
            let time = weatherData.hourly?.time?[i] ?? "t"
            if(time.prefix(13) == currentTime.prefix(13)){
                
                counter = i
                
                break
            }
        }
        
        //Get the 24h window between the current time and 24h after
        for j in (0+counter)...(24+counter){
            //   print(0+counter)
            //    print(24+counter)
            let time = weatherData.hourly?.time?[j] ?? "t"
            let weatherCode = Double((weatherData.hourly?.weatherCode?[j]) ?? 9)
            let temperature = weatherData.hourly?.temperature2m?[j] ?? 9
            let code = getWeatherCodeDescription(code: weatherCode)
            let prec = weatherData.hourly?.precipitationProbability?[j] ?? 9
            let weather = dataWeather(time: time, temperatura: temperature, weatherCode: code, precipitation: prec)
            data.datiTempo.append(weather)
            if(time.prefix(13) == currentTime.prefix(13) ) {
                self.currentWeather = weather
                // print("current weather: ")
                //   print(self.currentWeather.weatherCode.accessibleDesc)}
            }
                
        }
        
             self.dailyData = data
        
        
        let measurement = Measurement(value: currentWeather.temperature, unit: UnitTemperature.celsius)
        
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .temperatureWithoutUnit
        self.tempNow = measurementFormatter.string(from: measurement)
        //  print(data)
        
        
    }
    
    
    func formatTemp( temp: Double) -> String
    {
        let measurement = Measurement(value: temp, unit: UnitTemperature.celsius)
        
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .temperatureWithoutUnit
        
        return measurementFormatter.string(from: measurement)
        
    }
    
    
}
