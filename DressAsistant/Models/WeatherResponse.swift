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
        return .tormenta
      case 3:
        return .llovizna
      case 5:
        return .lluvioso
      case 6:
        return .nevando
      case 7:
        return .ambiente
      default:
        if weatherId == 800 {
          return .claro
        }
        return .nublado
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
