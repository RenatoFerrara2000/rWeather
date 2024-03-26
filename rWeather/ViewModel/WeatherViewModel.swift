//
//  WeatherViewModel.swift
//  Rweather
//
//  Created by Renato Ferrara on 14/11/23.
//

import Foundation
import Network

  @MainActor
  class WeatherViewModel: ObservableObject {
    var weatherData: WeatherData
      var tempCity: String
    @Published var citta: String
    @Published var datiGiorno: dailyDataValues
    @Published var currentWeather: dataWeather
    @Published var currentTime: String
    @Published var  tempNow: String
    @Published var  dataFetched = false

    
    init() {
        self.weatherData = WeatherData()
        self.datiGiorno = dailyDataValues()
        self.citta = ""
        self.tempNow = ""
        self.currentWeather = dataWeather()
        self.currentTime =  ""
        self.tempCity = "test"
        Singleton.shared.getLocation()
        Task{
            await fetchData()
        }
    }
    
   
    
    func fetchData() async{
         await fetchLocation()
            print("[WVM] Fetched loc \n")
        await fetchWeather()
            print("[WVM] Fetched weather \n")
        self.dataFetched = true
    }
    
    //func to get city
     func fetchLocation() async{
         
          self.citta =  await Singleton.shared.getCity()
        print("[WVM] city is:" , self.citta.description , "\n\n")
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
        
        /* var currentTime: String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd'T'HH"
         return dateFormatter.string(from: Date.now)
         }*/
        
        let  currentTime = self.weatherData.currentWeather?.time
        ////
        var counter: Int = 0
        for i in 0...24 {
            let time = weatherData.hourly?.time?[i] ?? "t"
            if(time.prefix(13) == currentTime?.prefix(13)){
                
                counter = i
                
                break
            }
        }
        
        
        for j in (0+counter)...(24+counter){
            //   print(0+counter)
            //    print(24+counter)
            let time = weatherData.hourly?.time?[j] ?? "t"
            let weatherCode = Double((weatherData.hourly?.weatherCode?[j]) ?? 9)
            let temperatura = weatherData.hourly?.temperature2m?[j] ?? 9
            let code = getWeatherCodeDescription(code: weatherCode)
            let prec = weatherData.hourly?.precipitationProbability?[j] ?? 9
            let weather = dataWeather(time: time, temperatura: temperatura, weatherCode: code, precipitation: prec)
            data.datiTempo.append(weather)
            
          //  print( "DataWeather code is", code)
            
            
            
            
            //   print(time.prefix(13))
            //  print(currentTime.prefix(13))
            if(time.prefix(13) == currentTime?.prefix(13) ) {
                self.currentWeather = weather
                // print("current weather: ")
                //   print(self.currentWeather.weatherCode.accessibleDesc)}
            }
                
        }
        
             self.datiGiorno = data
        
        
        let measurement = Measurement(value: currentWeather.temperatura, unit: UnitTemperature.celsius)
        
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
