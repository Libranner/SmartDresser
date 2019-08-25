//
//  AffiliateManager.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 03/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class AppManager {
  enum UserType: Int {
    case affiliate = 1
    case assistant = 2
    case none = 3
  }
  
  private let USER_TYPE_KEY = "USER_TYPE"
  private let AFFILIATE_ID = "AFFILIATE_ID"
  static let shared = AppManager()
  var currentAffiliate: Affiliate?
  
  func saveUserType(userType: UserType) {
    UserDefaults.standard.set(userType.rawValue, forKey: USER_TYPE_KEY)
  }
  
  func saveAffiliateId(_ affiliateId: String){
    UserDefaults.standard.set(affiliateId, forKey: AFFILIATE_ID)
  }
  
  var affiliateId: String? {
    return UserDefaults.standard.string(forKey: AFFILIATE_ID)
  }
  
  func removeAffiliate() {
    UserDefaults.standard.removeObject(forKey: AFFILIATE_ID)
  }
  
  var selectedUserType: UserType {
    return AppManager.UserType(rawValue: UserDefaults.standard.integer(forKey: USER_TYPE_KEY)) ?? .none
  }
}
