//
//  WeatherModel.swift
//  ЯRweather
//
//  Created by Renato Ferrara on 14/11/23.
//

import Foundation

//Json complete struct
struct WeatherData: Decodable {

  var latitude             : Double?      = nil
  var longitude            : Double?      = nil
  var generationtimeMs     : Double?      = nil
  var utcOffsetSeconds     : Int?         = nil
  var timezone             : String?      = nil
  var timezoneAbbreviation : String?      = nil
  var elevation            : Int?         = nil
  var hourlyUnits          : HourlyUnits? = HourlyUnits()
  var hourly               : Hourly?      = Hourly()
  var dailyUnits           : DailyUnits?  = DailyUnits()
  var daily                : Daily?       = Daily()
  var currentWeather          : CurrentWeather? = CurrentWeather()

  enum CodingKeys: String, CodingKey {

    case latitude             = "latitude"
    case longitude            = "longitude"
    case generationtimeMs     = "generationtime_ms"
    case utcOffsetSeconds     = "utc_offset_seconds"
    case timezone             = "timezone"
    case timezoneAbbreviation = "timezone_abbreviation"
    case elevation            = "elevation"
    case hourlyUnits          = "hourly_units"
    case hourly               = "hourly"
    case dailyUnits           = "daily_units"
    case daily                = "daily"
    case currentWeather          = "current"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    latitude             = try values.decodeIfPresent(Double.self      , forKey: .latitude             )
    longitude            = try values.decodeIfPresent(Double.self      , forKey: .longitude            )
    generationtimeMs     = try values.decodeIfPresent(Double.self      , forKey: .generationtimeMs     )
    utcOffsetSeconds     = try values.decodeIfPresent(Int.self         , forKey: .utcOffsetSeconds     )
    timezone             = try values.decodeIfPresent(String.self      , forKey: .timezone             )
    timezoneAbbreviation = try values.decodeIfPresent(String.self      , forKey: .timezoneAbbreviation )
    elevation            = try values.decodeIfPresent(Int.self         , forKey: .elevation            )
    hourlyUnits          = try values.decodeIfPresent(HourlyUnits.self , forKey: .hourlyUnits          )
    hourly               = try values.decodeIfPresent(Hourly.self      , forKey: .hourly               )
    dailyUnits           = try values.decodeIfPresent(DailyUnits.self  , forKey: .dailyUnits           )
    daily                = try values.decodeIfPresent(Daily.self       , forKey: .daily                )
    currentWeather       = try values.decodeIfPresent(CurrentWeather.self, forKey: .currentWeather  )
                                    }

  init() {
    }

}

//informationn on single hours
struct HourlyUnits: Codable {

  var time                     : String? = nil
  var temperature2m            : String? = nil
  var precipitationProbability : String? = nil
  var weatherCode              : String? = nil

  enum CodingKeys: String, CodingKey {

    case time                     = "time"
    case temperature2m            = "temperature_2m"
    case precipitationProbability = "precipitation_probability"
    case weatherCode              = "weather_code"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    time                     = try values.decodeIfPresent(String.self , forKey: .time                     )
    temperature2m            = try values.decodeIfPresent(String.self , forKey: .temperature2m            )
    precipitationProbability = try values.decodeIfPresent(String.self , forKey: .precipitationProbability )
    weatherCode              = try values.decodeIfPresent(String.self , forKey: .weatherCode              )
 
  }

  init() {

  }

}



struct Hourly: Codable {

  var time                     : [String]? = []
  var temperature2m            : [Double]? = []
  var precipitationProbability : [Int]?    = []
  var weatherCode              : [Int]?    = []

  enum CodingKeys: String, CodingKey {

    case time                     = "time"
    case temperature2m            = "temperature_2m"
    case precipitationProbability = "precipitation_probability"
    case weatherCode              = "weather_code"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    time                     = try values.decodeIfPresent([String].self , forKey: .time                     )
    temperature2m            = try values.decodeIfPresent([Double].self , forKey: .temperature2m            )
    precipitationProbability = try values.decodeIfPresent([Int].self    , forKey: .precipitationProbability )
    weatherCode              = try values.decodeIfPresent([Int].self    , forKey: .weatherCode              )
 
  }

  init() {

  }

}



struct DailyUnits: Codable {

  var time        : String? = nil
  var weatherCode : String? = nil

  enum CodingKeys: String, CodingKey {

    case time        = "time"
    case weatherCode = "weather_code"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    time        = try values.decodeIfPresent(String.self , forKey: .time        )
    weatherCode = try values.decodeIfPresent(String.self , forKey: .weatherCode )
 
  }

  init() {

  }

}

struct Daily: Codable {

  var time        : [String]? = []
  var weatherCode : [Int]?    = []

  enum CodingKeys: String, CodingKey {

    case time        = "time"
    case weatherCode = "weather_code"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    time        = try values.decodeIfPresent([String].self , forKey: .time        )
    weatherCode = try values.decodeIfPresent([Int].self    , forKey: .weatherCode )
 
  }

  init() {

  }

}

struct dailyDataValues:Identifiable {
    var id = UUID()
    var datiTempo: [dataWeather]

    init() {
        self.datiTempo = []
    }
    

}
struct dataWeather: Identifiable{
       let id = UUID()
       var time: String
       var temperatura: Double
       var weatherCode: WeatherCode
    var precipitationProb: Int
    
    init(){
        self.time = ""
        self.temperatura = 0
        self.weatherCode = WeatherCode(codeNum: "-1", accessibleDesc: "")
        self.precipitationProb = 0
    }
    
    init(time: String, temperatura: Double, weatherCode: WeatherCode, precipitation: Int) {
            self.time = time
            self.temperatura = temperatura
        self.weatherCode = weatherCode
        self.precipitationProb = precipitation
        }
        
    
}

struct WeatherCode{
    var codeNum: String
    var accessibleDesc: String
    
    init(codeNum: String, accessibleDesc: String) {
        self.codeNum = codeNum
        self.accessibleDesc = accessibleDesc
    }
}

//function to get  Sf symbol and accessible description from weather code
func getWeatherCodeDescription(code: Double) -> WeatherCode {
    switch code {
    case 0:
        return WeatherCode.init(codeNum: "sun.max", accessibleDesc: "Clear sky")
    case 1, 2, 3:
        return WeatherCode.init(codeNum: "cloud.sun", accessibleDesc: "Mainly clear, partly cloudy")
    case 45, 48:
        return WeatherCode.init(codeNum: "cloud.drizzle", accessibleDesc: "Fog")
    case 51, 53, 55:
        return WeatherCode.init(codeNum: "cloud.fog", accessibleDesc: "drizzle")
    case 56, 57:
        return WeatherCode.init(codeNum: "cloud.sleet", accessibleDesc: "Freezing Drizzle")
    case 61, 63, 65:
        return WeatherCode.init(codeNum: "cloud.rain", accessibleDesc: "Rain")
     case 66, 67:
        return WeatherCode.init(codeNum: "cloud.hail", accessibleDesc: "Freezing Rain")
     case 71, 73, 75:
        return WeatherCode.init(codeNum: "cloud.snow", accessibleDesc: "Snow fall")
    case 77:
        return WeatherCode.init(codeNum: "cloud.snow", accessibleDesc: "Snow grains")
    case 80, 81, 82:
        return WeatherCode.init(codeNum: "cloud.heavyrain", accessibleDesc: "Rain showers")
    case 85, 86:
        return WeatherCode.init(codeNum: "cloud.snow", accessibleDesc: "Snow showers")
    case 95:
        return WeatherCode.init(codeNum: "cloud.bolt.rain", accessibleDesc: "Thunderstorm")
     case 96, 99:
        return WeatherCode.init(codeNum: "cloud.bolt.rain", accessibleDesc: "Thunderstorm with hail")
    default:
        return WeatherCode.init(codeNum: "questionmark", accessibleDesc: "Unknown")
    }
}

//weather right now
struct CurrentWeather: Decodable {
    let time: String?
    let interval: Double?
     let   temperature2M: Double?

    enum CodingKeys: String, CodingKey {
        case time        = "time"
        case temperature2M = "temperature_2m"
        case interval = "interval"
    }
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
        time  = try values.decodeIfPresent(String.self  , forKey: .time  )
        temperature2M = try values.decodeIfPresent(Double.self  , forKey: .temperature2M  )
        interval = try values.decodeIfPresent(Double.self  , forKey: .interval  )

 
    }
    
    init(){
        time = ""
        temperature2M = 0
        interval = 0
    }
}
