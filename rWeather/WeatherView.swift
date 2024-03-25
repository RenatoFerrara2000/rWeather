//
//  ContentView.swift
//  ЯRweather
//
//  Created by Renato Ferrara on 14/11/23.
//
import SwiftUI
import CoreLocation
import CoreLocationUI
struct WeatherView: View {
    @AppStorage("FirstStart") var alertShouldBeShown = true
    @State var city: String = ""
    @State var currentWeather: dataWeather = dataWeather()
    @State var tempNow: String = ""
    @State var dataFetched: Bool = false
    
    @State var location = CLLocationCoordinate2D()
         
    
    @StateObject var locationManager = LocationManager()
    
    
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack{
            Color.blue.ignoresSafeArea()
                .opacity(0.6)
            
            
            VStack {
                if(dataFetched){
                    VStack{
                        
                        Text(city)
                        Text(String(tempNow)).font(.largeTitle)
                        Image(systemName: currentWeather.weatherCode.codeNum).font(.largeTitle).accessibilityLabel(currentWeather.weatherCode.accessibleDesc)
                        HStack{
                            Text("Precipitation:")
                            Text(String(currentWeather.precipitationProb) + "%").font(.subheadline)
                            
                            
                        }
                        
                    } .foregroundColor(.white)
                        .accessibilityElement(children: .combine)
                    
                    
                    
                    
                    ZStack{
                        Color.blue.clipShape( RoundedRectangle(cornerRadius: 16))
                            .frame(width:  360, height: 110)
                        ScrollView(.horizontal) {
                            LazyHStack{
                                ForEach(viewModel.datiGiorno.datiTempo, id: \.id) { day in
                                    VStack {
                                        
                                        Text((day.time.prefix(13)).components(separatedBy: "T")[1])
                                        Image(systemName: day.weatherCode.codeNum).accessibilityLabel(day.weatherCode.accessibleDesc)
                                        Text(formatTemp(temp: day.temperatura))
                                    } .foregroundColor(.white)
                                        .padding()
                                        .accessibilityElement(children: .combine)
                                    
                                }
                            }
                            .padding()
                            
                        }  .frame(width:  360, height: 110)
                        
                    }
                }
            }
            .task(){
                
                locationManager.manager.requestAlwaysAuthorization()
                locationManager.manager.startUpdatingLocation()
                        //start a thread to get the data, off the main thread
                        await fetchWeatherData()
            }

        }
    }
    //api manager singleton
    
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
  
    
    struct WeatherView_Previews: PreviewProvider {
        static var previews: some View {
            WeatherView()
            
        }
    }
    
