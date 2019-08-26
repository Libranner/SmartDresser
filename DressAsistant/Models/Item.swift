//
//  Item.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 14/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

enum Material: String, Codable, CaseIterable {
  case none = ""
  case algodón
  case batista
  case brocada
  case crepe
  case denim
  case encaje
  case fieltro
  case lona
  case seda
}

enum PatternType: String, Codable, CaseIterable {
  case none = ""
  case regular
  case slim
}

enum PrintType: String, Codable, CaseIterable {
  case none = ""
  case subliminado
  case serigrafiado
  case vinilo
}

enum ItemColor: String, Codable, CaseIterable {
  case none = ""
  case amarillo
  case ambar
  case azul
  case beis
  case blanco
  case burdeos
  case caoba
  case caqui
  case carmesí
  case cartujo
  case castaño
  case celeste
  case cereza
  case champán
  case cian
  case cobre
  case coral
  case crema
  case dorado
  case fucsia
  case granate
  case gris
  case hueso
  case indigo
  case lavanda
  case lila
  case magenta
  case marrón
  case morado
  case naranja
  case negro
  case ocre
  case pardo
  case plata
  case púrpura
  case rojo
  case rosa
  case salmón
  case turquesa
  case verde
  case verdeagua
  case vino
  case violeta
}

enum itemSize: String, Codable, CaseIterable {
  case none = ""
  case s
  case m
  case l
  case xl
  case xxl
  case xxxl
}

enum ItemType: String, Codable, CaseIterable {
  case none = ""
  case clothes
  case shoes
  case accessory
}

struct Item: Codable {
  var key: String?
  var nfcCode: String
  var imageURL: URL
  var detail : String
  var material: Material
  var patternType: PatternType
  var printType: PrintType
  var color: ItemColor
  var type: ItemType
  var affiliateId: String?
  var userId: String?
}
