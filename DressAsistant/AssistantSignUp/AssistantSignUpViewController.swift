//
//  AssistantSignUpViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 07/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import Firebase

class AssistantSignUpViewController: BaseViewController {
  private let CREATE_ACCOUNT_SEGUE_KEY = "showCreateAccount"
  private let SHOW_MAIN_SEGUE_KEY = "showMain"
  
  @IBOutlet var mainStackView: UIStackView!
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var backgroundImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(forName: CustomNotificationName.userHasSigned,
                                           object: nil, queue: nil) {_ in
      DispatchQueue.main.async {
        self.performSegue(withIdentifier: self.CREATE_ACCOUNT_SEGUE_KEY, sender: self)
      }
    }
  }
  
  private func showEmailSentMessage() {
    let emailSentMessage = NSLocalizedString("email-sent", comment: "")
    showMessage(emailSentMessage)
  }
  
  private func showNotEmailMessage() {
    let localizedString = NSLocalizedString("error-empty-field-msg", comment: "")
    let fieldName = NSLocalizedString("email-field", comment: "")
  
    let message = String(format: localizedString, fieldName)
    showMessage(message)
  }
  
  private func showMessage(_ message: String) {
    let alertVC = UIAlertController(title: "", message: message, preferredStyle: .alert)
    
    let okString = NSLocalizedString(BaseViewController.Localizations.okAction, comment: "")

    let okAction = UIAlertAction(title: okString, style: .default)
    alertVC.addAction(okAction)
    
    present(alertVC, animated: true)
  }
  
  @IBAction func signInButtonTapped(_ sender: Any) {
    guard let email = emailTextField.text  else {
      showNotEmailMessage()
      return
    }
    
    AuthService().setupEmailSignIn(email) { [weak self] error in
      if error == nil {
        self?.showEmailSentMessage()
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    AuthService().isAuthenticated { isAuthenticated in
      if isAuthenticated {
        self.performSegue(withIdentifier: self.SHOW_MAIN_SEGUE_KEY, sender: self)
      }
      else {
        AuthService().signInWithEmail { error in
          if error == nil {
            self.performSegue(withIdentifier: self.CREATE_ACCOUNT_SEGUE_KEY, sender: self)
          }
          else {
            DispatchQueue.main.async {
              self.backgroundImageView.isHidden = true
              self.mainStackView.isHidden = false
            }
          }
        }
      }
    }
  }
}
