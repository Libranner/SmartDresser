//
//  Affiliate.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 10/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

enum Sex: String, Codable, CaseIterable {
  case none = ""
  case female = "Female"
  case male = "Male"
  
  init?(id : Int) {
    switch id {
    case 1: self = .none
    case 2: self = .female
    case 3: self = .male
    default: return nil
    }
  }
}

struct Affiliate: Codable {
  var key: String?
  var name: String
  var avatarUrl: URL?
  var birthdate: Date
  var height: Float
  var weight: Float
  var sex: Sex
  var hairColor: HairColor?
  var eyeColor: EyeColor?
  var skinColor: SkinColor?
  
  private enum CodingKeys: String, CodingKey {
    case name
    case avatarUrl
    case birthdate
    case height
    case weight
    case sex
    case hairColor
    case eyeColor
    case skinColor
  }
}
