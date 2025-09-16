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
    
   @State  var viewModel = WeatherViewModel()
     var body: some View {
        ZStack{
            Color.blue.ignoresSafeArea()
                .opacity(0.6)
            VStack {
                VStack{
                    Text(viewModel.city)
                    
                    Text(String(viewModel.tempNow)).font(.largeTitle).accessibilityLabel("Temperature" + viewModel.tempNow)
                    
                    Image(systemName: viewModel.currentWeather.weatherCode.codeNum).font(.largeTitle).accessibilityLabel(viewModel.currentWeather.weatherCode.accessibleDesc)
                    
                    HStack{
                        Text("Precipitation:")
                        Text(String(viewModel.currentWeather.precipitationProb) + "%").font(.subheadline)
                    }
                    
                } .foregroundColor(.white)
                    .accessibilityElement(children: .combine)
                
                ZStack{
                    Color.blue.clipShape( RoundedRectangle(cornerRadius: 16))
                        .frame(width:  360, height: 110)
                    ScrollView(.horizontal) {
                        LazyHStack{
                            ForEach(viewModel.dailyData, id: \.id) { day in
                                VStack {
                                    
                                    Text((day.time.prefix(13)).components(separatedBy: "T")[1])
                                        .accessibilityLabel("\(day.time.components(separatedBy: "T")[1]) o'clock")

                                    Image(systemName: day.weatherCode.codeNum).accessibilityLabel(day.weatherCode.accessibleDesc)
                                    Text(viewModel.formatTemp(temp: day.temperature))
                                } .foregroundColor(.white)
                                    .padding()
                                    .accessibilityElement(children: .combine)
                                
                            }
                        }
                        .padding()
                        
                    }  .frame(width:  360, height: 110)
                    
                }
            }   

        }   .task {
            // This will trigger the initial data fetch when the view appears
            await viewModel.fetchData()
        }
    }
}
  
    
    struct WeatherView_Previews: PreviewProvider {
        static var previews: some View {
            WeatherView()
            
        }
    }
    
