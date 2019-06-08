//
//  RoundedButton.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 08/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    layer.borderWidth = 1/UIScreen.main.nativeScale
    titleLabel?.adjustsFontForContentSizeCategory = true
    contentEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.height/2
    layer.borderColor = isEnabled ? tintColor.cgColor : UIColor.lightGray.cgColor //makes border color same as tint
  }
}
