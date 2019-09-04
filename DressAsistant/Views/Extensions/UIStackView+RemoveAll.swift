//
//  UIStacView+Remove.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 27/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

extension UIStackView {
  
  func removeAllArrangedSubviews() {
    
    let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
      self.removeArrangedSubview(subview)
      return allSubviews + [subview]
    }
    
    NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
    removedSubviews.forEach({ $0.removeFromSuperview() })
  }
}
