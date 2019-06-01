//
//  Utilities.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 27/05/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

extension CGRect {
  func dividedIntegral(fraction: CGFloat, from
    fromEdge: CGRectEdge) -> (first: CGRect, second: CGRect) {
    let dimension: CGFloat
    
    switch fromEdge {
    case .minXEdge, .maxXEdge:
      dimension = self.size.width
    case .minYEdge, .maxYEdge:
      dimension = self.size.height
    }
    
    let distance = (dimension * fraction).rounded(.up)
    var slices = self.divided(atDistance: distance, from: fromEdge)
    
    switch fromEdge {
    case .minXEdge, .maxXEdge:
      slices.remainder.origin.x += 1
      slices.remainder.size.width -= 1
    case .minYEdge, .maxYEdge:
      slices.remainder.origin.y += 1
      slices.remainder.size.height -= 1
    }
    
    return (first: slices.slice, second: slices.remainder)
  }
}
