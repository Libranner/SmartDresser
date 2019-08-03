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
}

struct Temperature: Decodable {
  var value: Float
  
  enum CodingKeys: String, CodingKey {
    case value = "temp"
  }
}

struct WeatherResponse: Decodable {
  var conditions: [WeatherData]
  var temperature: Temperature
  
  var currentWeather: WeatherData? {
    guard !conditions.isEmpty else {
      return nil
    }
    
    return conditions[0]
  }
  
  enum CodingKeys: String, CodingKey {
    case conditions = "weather"
    case temperature = "main"
  }
}
