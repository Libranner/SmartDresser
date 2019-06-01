//
//  BaseViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 25/05/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UINavigationBar.appearance().barTintColor = CustomColor.topBarColor
        UINavigationBar.appearance().titleTextAttributes =
          [NSAttributedString.Key.foregroundColor : CustomColor.topBarTextColor]
        view.backgroundColor = CustomColor.defaultBackgroundColor
      
        navigationController?.navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : CustomColor.topBarTextColor], for: .normal)
      
        navigationController?.navigationItem.backBarButtonItem?.tintColor = .white
        navigationController?.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : CustomColor.topBarTextColor], for: .normal)
    }
}
