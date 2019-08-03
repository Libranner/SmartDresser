//
//  WeatherResponse.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 03/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
  var weatherId: Int
  var summaryDescription: String
  var iconPath: String
  var largeDescription: String
  
  enum CodingKeys: String, CodingKey {
    case weatherId = "id"
    case summaryDescription = "main"
    case largeDescription = "description"
    case iconPath = "icon"
  }
  
  var condition: WeatherCondition {
    let conditionId: Int = weatherId / 100
    
    switch conditionId {
    case 2:
      return .thunderstorm
    case 3:
      return .drizzle
    case 5:
      return .rain
    case 6:
      return .snow
    case 7:
      return .atmosphere
    default:
      if weatherId == 800 {
        return .clear
      }
      return .cloudy
    }
  }
}

struct Temperature: Decodable {
  var value: Float
  
  enum CodingKeys: String, CodingKey {
    case value = "temp"
  }
}

struct WeatherResponse: Decodable {
  private var weatherData: [WeatherData]
  var temperature: Temperature
  
  var currentWeather: WeatherData? {
    guard !weatherData.isEmpty else {
      return nil
    }
    
    return weatherData[0]
  }
  
  enum CodingKeys: String, CodingKey {
    case weatherData = "weather"
    case temperature = "main"
  }
}
