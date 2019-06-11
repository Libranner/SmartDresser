//
//  RoundImageView.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 08/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

@IBDesignable final class RoundImageView: UIImageView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  private func setup() {
    let width = frame.size.width
    let cornerRadius = width / 2
    layer.cornerRadius = cornerRadius
    layer.masksToBounds = true
    layer.borderWidth = 2.0
    layer.borderColor = UIColor.gray.cgColor
  }
}
