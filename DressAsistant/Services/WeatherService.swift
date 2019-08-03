//
//  WeatherService.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 03/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

struct WeatherService {
  private let apiKey = "2c397c1f5977c2924f49b887754bd206"
  private let url = "https://api.openweathermap.org/data/2.5/weather"
  private let cityId = 3104323
  private let iconBaseUrl = "https://openweathermap.org/img/wn/"
  func getIconUrlFromPath(_ path: String) -> URL {
    return URL(string: "\(iconBaseUrl)\(path)@2x.png")!
  }
  
  var currentSeason: Season {
    let date = Date()
    let components = Calendar.current.dateComponents([Calendar.Component.month], from: date)
    let month = components.month!
    
    if month >= 3 && month <= 6 {
      return .spring
    }
    else if month >= 6 && month <= 8 {
      return .summer
    }
    else if month >= 9 && month <= 11 {
      return .autumn
    }
    
    return .winter
  }
  
  var currentTimeOfDay: TimeOfDay {
    let date = Date()
    let components = Calendar.current.dateComponents([Calendar.Component.hour], from: date)
    let hour = components.hour!
    
    if hour < 12 {
      return .morning
    }
    else if hour < 19 {
      return .afternoon
    }
    
    return .evening
  }
  
  func getCurrentWeather(completion:@escaping (_ response: WeatherResponse?) -> Void) {
    let weatherUrl = "\(url)?id=\(cityId)&lang=sp&units=metric&appid=\(apiKey)"
    let request = URLRequest(url: URL(string: weatherUrl)!,  cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 0.0)
    let session = URLSession.shared
    
    // Construimos la tarea usando el URLRequest creado anteriormente
    let task = session.dataTask(with:request) {
      data, response, error in

      guard let unWrappedData = data, error == nil else {
        completion(nil)
        return
      }

      let response = try! JSONDecoder().decode(WeatherResponse.self, from: unWrappedData)
      completion(response)
    }
    
    /// Ejecutamos la tarea
    task.resume()
  }
}
