//
//  SkinColor.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 06/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import UIKit

struct SkinColor: Codable {
  var documentID: String?
  var name: String
  var colorComponents: [CGFloat]
  
  func rgbColor() -> UIColor {
    let color = UIColor(red: colorComponents[0]/255,
            green: colorComponents[1]/255,
            blue: colorComponents[2]/255,
            alpha: 1.0)
    
    return color
  }
  
}
