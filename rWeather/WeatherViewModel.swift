//
//  WeatherViewModel.swift
//  Rweather
//
//  Created by Renato Ferrara on 14/11/23.
//

import Foundation
import Network

 

class WeatherViewModel: ObservableObject {
    var weatherData: WeatherData
    @Published var citta: String
    @Published var datiGiorno: dailyDataValues
    @Published var currentWeather: dataWeather
    @Published var currentTime: String
    
    init() {
        self.weatherData = WeatherData()
        self.datiGiorno = dailyDataValues()
        self.citta = ""
        
        self.currentWeather = dataWeather()
        self.currentTime =  ""
     }
  
    //function to get data from open meteo
    func fetch( lat: Double,  long: Double) async{
        let latitude = lat
        let longitude = long
       
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m&hourly=temperature_2m,precipitation_probability,weather_code&daily=weather_code")
        else {
            print("Errore call api")
            return
        }
            do {

                //await to get the data
                let (data, _) = try await URLSession.shared.data(from: url)
              print("url: \n")
                print(url)
                let weatData = try JSONDecoder().decode(WeatherData.self, from: data)
                self.weatherData = weatData
                       
                self.StructBuilder(weatherData: weatData)
                        
                print("\n current weather data time:")
              //  print(currentWeatherData.time)
 
                }catch {
                // Handle error appropriately
                print("Error decoding weather data:", error)
            }
     //  print("\n\n\n Time")
     //   print(currentWeather.time)
     //   print("\n\n\n Time")

       //  print(weatherData)
 
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
                    print("time & counter:")
                    print(time)
                    print("\n")
                    print(counter)
                    let weatherCode = Double((weatherData.hourly?.weatherCode?[j]) ?? 9)
                    let temperatura = weatherData.hourly?.temperature2m?[j] ?? 9
                    let code = getWeatherCodeDescription(code: weatherCode)
                    let prec = weatherData.hourly?.precipitationProbability?[j] ?? 9
                    let weather = dataWeather(time: time, temperatura: temperatura, weatherCode: code, precipitation: prec)
                    data.datiTempo.append(weather)
                   
                    
                    
                    
                 //   print(time.prefix(13))
                //  print(currentTime.prefix(13))
                    if(time.prefix(13) == currentTime?.prefix(13) ) {
                        DispatchQueue.main.async{
                            self.currentWeather = weather                                }
                         
                       
                    }
                }
    
        DispatchQueue.main.async{
            self.datiGiorno = data                            }
         
       
             //  print(data)
         
       
    }
    
    
    
    
}


