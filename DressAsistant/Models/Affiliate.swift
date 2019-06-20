//
//  Affiliate.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 10/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

enum Sex: Int, Codable {
  case female = 1
  case male
}

struct ItemData {
  var name: String
  var imageURL: URL?
}

enum SkinColor: Int, Codable {
  case Female
  case Male
}

struct Affiliate: Codable {
  var key: String?
  var name: String
  var avatarUrl: URL?
  var birthdate: Date
  var height: Float
  var weight: Float
  var sex: Sex
  var hairColor: String
  var eyeColor: String
  var skinColor: SkinColor
  
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
