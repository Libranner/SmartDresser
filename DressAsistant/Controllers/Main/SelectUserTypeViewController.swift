//
//  SelectUserTypeViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 25/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class SelectUserTypeViewController: BaseViewController {
  private let showAsistantSegueName = "showAsistantWF"
  private let showAffiliateSegueName = "showAffiliateWF"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let userType = AppManager.shared.selectedUserType
    
    if userType == .affiliate {
      performSegue(withIdentifier: showAffiliateSegueName, sender: self)
    }
    else if userType == .assistant {
      performSegue(withIdentifier: showAsistantSegueName, sender: self)
    }
  }
  
  @IBAction func startAsAffiliate(_ sender: Any) {
    AuthService().logout()
    AppManager.shared.saveUserType(userType: .affiliate)
    performSegue(withIdentifier: showAffiliateSegueName, sender: self)
  }
  
  @IBAction func startAsAssistant(_ sender: Any) {
    AppManager.shared.saveUserType(userType: .assistant)
    AppManager.shared.removeAffiliate()
    performSegue(withIdentifier: showAsistantSegueName, sender: self)
  }
}
