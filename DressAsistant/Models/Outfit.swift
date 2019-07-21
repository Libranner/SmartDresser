//
//  Outfit.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 22/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

enum TimeOfDay: String, Codable, CaseIterable {
  case morning
  case afternoon
  case evening
}

enum Season: String, Codable, CaseIterable {
  case fall
  case spring
  case summer
  case winter
}

enum Weather: String, Codable, CaseIterable {
  case windy
  case rainy
  case sunny
  case cloudy
}

enum EventType: String, Codable, CaseIterable {
  case gala
  case wedding
  case workRelated
  case casual
  case sport
}

struct Outfit: Codable {
  var key: String?
  var season: Season
  var weather: Weather
  var eventType: EventType
  var timeOfDay: TimeOfDay
  var items: [Item]
}
