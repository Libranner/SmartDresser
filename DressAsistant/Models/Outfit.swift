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
  case morning
  case afternoon
  case evening
}

enum Season: String, Codable, CaseIterable {
  case none = ""
  case autumn
  case spring
  case summer
  case winter
}

enum WeatherCondition: String, Codable, CaseIterable {
  case none = ""
  case atmosphere
  case clear
  case cloudy
  case drizzle
  case rain
  case snow
  case thunderstorm
}

enum EventType: String, Codable, CaseIterable {
  case none = ""
  case gala
  case wedding
  case workRelated
  case casual
  case sport
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
