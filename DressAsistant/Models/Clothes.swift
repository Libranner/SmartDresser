//
//  Clothes.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 14/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

enum Material: String, Codable, CaseIterable {
  case none = ""
  case denim = "denim"
  case cottom = "cottom"
}

enum PatternType: String, Codable, CaseIterable {
  case none = ""
  case overSize
  case slim
}

enum PrintType: String, Codable, CaseIterable {
  case none = ""
  case uno
}

enum ClothesColor: String, Codable, CaseIterable {
  case none = ""
  case blanco
}

enum ClothesSize: String, Codable, CaseIterable {
  case none = ""
  case s
  case m
  case l
  case xl
  case xxl
  case xxxl
}

struct Clothes: Codable {
  var key: String?
  var nfcCode: String
  var imageURL: URL
  var detail : String
  var material: Material
  var patternType: PatternType
  var printType: PrintType
  var color: ClothesColor
  var size: ClothesSize
}
