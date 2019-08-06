//
//  BaseViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 25/05/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//
import UIKit
import SnapKit

class BaseViewController: UIViewController {
  //ERROR MESSAGES LOCALIZATIOND IDS
  enum Localizations {
    static let errorModalTitle = "error-modal-title"
    static let errorNoConnection = "error-no-connection-msg"
    static let errorEmptyField = "error-empty-field-msg"
    static let errorCouldNotAuthenticate = "error-could-no-authenticate-msg"
    static let errorUserNotSigned = "error-user-not-signed-msg"
    static let errorGettingData = "error-getting-data"
    static let okAction = "ok-action"
    static let yesAction = "ok-action"
    static let cancelAction = "cancel-action"
    static let removeAction = "remove-action"
  }

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
    
    let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    recognizer.cancelsTouchesInView = false
    view.addGestureRecognizer(recognizer)
  }
  
  @objc func hideKeyboard() {
    self.view.endEditing(true)
  }
  
  fileprivate var connectionErrorMessage: String = {
    return NSLocalizedString(Localizations.errorGettingData, comment: "")
  }()
  
  fileprivate var errorGettingDataMessage: String = {
    return NSLocalizedString(Localizations.errorGettingData, comment: "")
  }()
  
  fileprivate var userNotSignedInMessage: String = {
    return NSLocalizedString(Localizations.errorUserNotSigned, comment: "")
  }()
  
  private func emptyFieldMessage(_ fieldName: String) -> String {
    let localizedString = NSLocalizedString(Localizations.errorEmptyField, comment: "")
    return String(format: localizedString, fieldName)
  }
  
  func showErrorMessage( _ message: String) {
    let title = NSLocalizedString(Localizations.errorModalTitle, comment: "")
    let okString = NSLocalizedString(Localizations.okAction, comment: "")
    
    let alertVC = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: okString, style: .default)
    alertVC.addAction(okAction)
    
    present(alertVC, animated: true)
  }
  
  func showErrorMessage( _ error: CustomError) {
    var message = ""
    switch error as CustomError {
    case .generic, .errorSavingData:
      message = connectionErrorMessage
    case .errorGettingData:
      message = errorGettingDataMessage
    case .emptyField(let fieldName):
      message = emptyFieldMessage(fieldName)
    case .usersNotSignedIn:
      message = userNotSignedInMessage
    }
    
    let title = NSLocalizedString(Localizations.errorModalTitle, comment: "")
    let okString = NSLocalizedString(Localizations.okAction, comment: "")
    
    let alertVC = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: okString, style: .default)
    alertVC.addAction(okAction)
    
    present(alertVC, animated: true)
  }
}

protocol LoadingScreenDelegate {
  var loadingView: LoadingView { get set }
  func hideLoading()
  func showLoading()
}

extension LoadingScreenDelegate where Self: UIViewController {

  func hideLoading() {
    UIView.animate(withDuration: 0.6, delay: 0,
                   options: .curveEaseOut, animations: {
      self.loadingView.alpha = 0
    }) { _ in
      self.view.isUserInteractionEnabled = true
      self.loadingView.removeFromSuperview()
      self.loadingView.alpha = 1
    }
  }
  
  func showLoading() {
    view.isUserInteractionEnabled = false
    
    let window = UIApplication.shared.keyWindow!
    window.addSubview(loadingView)
    
    loadingView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.height.equalTo(150)
      make.width.equalTo(loadingView.snp.height)
    }
  }
}
