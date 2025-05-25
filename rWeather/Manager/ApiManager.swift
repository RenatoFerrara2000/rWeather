//
//  ApiManager.swift
//  Rweather
//
//  Created by Renato Ferrara on 25/03/24.
//

import Foundation

class ApiManager{
    
    func fetch( lat: Double,  long: Double) async -> Data?  {
        let latitude = lat
        let longitude = long
        print("\n API CALL \n")
        print(latitude)
        print(longitude)
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m&hourly=temperature_2m,precipitation_probability,weather_code&daily=weather_code")
         else {
            print("Error api call")
            return nil
        }
            do {
                //await to get the data
                let (data, _) = try await URLSession.shared.data(from: url)
                return data
                }catch {
                // Handle error appropriately
                print("Error decoding weather data:", error)
                    return Data()
            }
 
    }
    
}
