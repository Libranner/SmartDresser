//
//  AssistantSignUpViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 07/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import Firebase

class AssistantSignUpViewController: UIViewController {
  private let CREATE_ACCOUNT_SEGUE_KEY = "showCreateAccount"
  
  @IBOutlet weak var emailTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    AuthService().isAuthenticated { isAuthenticated in
      if !isAuthenticated {
        self.performSegue(withIdentifier: self.CREATE_ACCOUNT_SEGUE_KEY, sender: self)
      }
    }
  }  
}
