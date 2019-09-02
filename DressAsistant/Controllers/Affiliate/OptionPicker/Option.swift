//
//  Option.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 20/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import UIKit

struct Option {
  var itemId: String
  var name: String
  var imageURL: URL?
  var backgroundColor: UIColor = .white
  
  init(itemId: String, name: String, imageURL: URL) {
    self.itemId = itemId
    self.name = name
    self.imageURL = imageURL
  }
  
  init(itemId: String, name: String, backgroundColor: UIColor) {
    self.itemId = itemId
    self.name = name
    self.backgroundColor = backgroundColor
  }
}
