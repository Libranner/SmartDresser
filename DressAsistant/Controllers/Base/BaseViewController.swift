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
  internal static let ERROR_MODAL_TITLE_STRING_ID = "error-modal-title"
  internal static let ERROR_NO_CONNECTION = "error-no-connection-msg"
  internal static let ERROR_EMPTY_FIELD = "error-empty-field-msg"
  internal static let ERROR_COULD_NOT_AUTHENTICATE = "error-could-no-authenticate-msg"
  internal static let ERROR_USER_NOT_SIGNED = "error-user-not-signed-msg"
  
  internal static let OK_ACTION_STRING_ID = "ok-action"
  internal static let CANCEL_ACTION_STRING_ID = "cancel-action"
  
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
    view.addGestureRecognizer(recognizer)
  }
  
  @objc func hideKeyboard() {
    self.view.endEditing(true)
  }
  
  fileprivate var connectionErrorMessage: String = {
    return NSLocalizedString(ERROR_NO_CONNECTION, comment: "")
  }()
  
  fileprivate var userNotSignedInMessage: String = {
    return NSLocalizedString(ERROR_USER_NOT_SIGNED, comment: "")
  }()
  
  private func emptyFieldMessage(_ fieldName: String) -> String {
    let localizedString = NSLocalizedString(BaseViewController.ERROR_EMPTY_FIELD, comment: "")
    return String(format: localizedString, fieldName)
  }
  
  func showErrorMessage( _ error: CustomError) {
    var message = ""
    switch error as CustomError {
    case .generic, .errorSavingData, .errorGettingData:
      message = connectionErrorMessage
    case .emptyField(let fieldName):
      message = emptyFieldMessage(fieldName)
    case .usersNotSignedIn:
      message = userNotSignedInMessage
    }
    
    let title = NSLocalizedString(BaseViewController.ERROR_MODAL_TITLE_STRING_ID, comment: "")
    let okString = NSLocalizedString(BaseViewController.OK_ACTION_STRING_ID, comment: "")
    
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
    }
  }

  func showLoading() {
    view.isUserInteractionEnabled = false
    view.addSubview(loadingView)
    
    loadingView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.height.equalTo(150)
      make.width.equalTo(loadingView.snp.height)
    }
  }
}
