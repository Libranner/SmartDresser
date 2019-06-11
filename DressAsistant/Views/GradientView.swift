//
//  Gradient.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 10/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
class GradientView: UIView {
  
  lazy fileprivate var gradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    
    let startColor = UIColor(red: 117/255.0, green: 189/255.0, blue: 226/255.0, alpha: 1)
    let endColor = UIColor(red: 0, green: 134/255.0, blue: 203/255.0, alpha: 1)
    
    gradientLayer.colors = [startColor, endColor].map{ $0.cgColor }
    //gradientLayer.locations = [0.0, 1.0]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    return gradientLayer
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  private func setupView() {
    backgroundColor = UIColor.clear
    layer.addSublayer(gradientLayer)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
  }
}
