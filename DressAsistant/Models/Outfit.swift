//
//  Outfit.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 22/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

enum TimeOfDay: String, Codable, CaseIterable {
  case none = ""
  case mañana
  case tarde
  case noche
}

enum Season: String, Codable, CaseIterable {
  case none = ""
  case invierno
  case otoño
  case primavera
  case verano
}

enum WeatherCondition: String, Codable, CaseIterable {
  case none = ""
  case ambiente
  case claro
  case llovizna
  case lluvioso
  case nevando
  case nublado
  case tormenta
}

enum EventType: String, Codable, CaseIterable {
  case none = ""
  case boda
  case casual
  case gala
  case sport
  case trabajo  
}

struct Outfit: Codable {
  var key: String?
  var season: Season
  var weather: WeatherCondition
  var eventType: EventType
  var timeOfDay: TimeOfDay
  var items: [Item]
  var affiliateId: String?
  var userId: String?
}
