//
//  OutfitRequest.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 27/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

struct OutfitRequest: Codable {
  var affiliateId: String
  var season: Season
  var weather: WeatherCondition
  var eventType: EventType
  var timeOfDay: TimeOfDay
  var date: Date
}
