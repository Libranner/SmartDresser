//
//  BaseNavigationViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 14/05/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
      /*let gradientLayer = CAGradientLayer()
      gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
      gradientLayer.locations = [0.0, 1.0]
      
      gradientLayer.frame = navigationBar.frame
      navigationBar.layer.insertSublayer(gradientLayer, at: 0)*/
      
      UINavigationBar.appearance().barTintColor = CustomColor.topBarColor
      UINavigationBar.appearance().titleTextAttributes =
        [NSAttributedString.Key.foregroundColor : CustomColor.topBarTextColor]

    }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
