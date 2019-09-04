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

    let image = UIImage(named: "topBar")
    navigationBar.setBackgroundImage(image, for: .default)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
