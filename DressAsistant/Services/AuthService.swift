//
//  AuthService.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 08/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
  private let LINK_KEY = "Link"
  private let EMAIL_KEY = "Email"
  private let URL_FORMAT = "https://smartdresser-7d3cb.firebaseapp.com?email"
  
  var currentUserId: String? {
    return Auth.auth().currentUser?.uid
  }
  
  func logout() {
    try? Auth.auth().signOut()
    UserDefaults.standard.removeObject(forKey: self.EMAIL_KEY)
    UserDefaults.standard.removeObject(forKey: self.LINK_KEY)
  }
  
  func isSignIn(withLink link: String, updateLink: Bool = false) -> Bool {
  
    if Auth.auth().isSignIn(withEmailLink: link) {
      if updateLink {
        UserDefaults.standard.set(link, forKey: LINK_KEY)
      }
      return true
    }
    return false
  }
  
  func isAuthenticated(completion: ((_ authenticated: Bool)-> Void)) {
    if let link = UserDefaults.standard.string(forKey: LINK_KEY) {
      completion(isSignIn(withLink: link))
      return
    }
    
    completion(false)
  }
  
  func setupEmailSignIn( _ email: String, completion:@escaping (_ error: Error?)-> Void) {
    let actionCodeSettings = ActionCodeSettings()
    actionCodeSettings.url = URL(string: "\(URL_FORMAT)=\(email)")
    
    actionCodeSettings.handleCodeInApp = true
    actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)

    Auth.auth().sendSignInLink(toEmail:email,
                               actionCodeSettings: actionCodeSettings) { error in
      if let error = error {
        completion(error)
        return
      }
                                
      // The link was successfully sent. Inform the user.
      // Save the email locally so you don't need to ask the user for it again
      // if they open the link on the same device.
      UserDefaults.standard.set(email, forKey: self.EMAIL_KEY)
      completion(nil)
    }
  }
  
  func signInWithEmail(completion:@escaping ((_ error: Error?)-> Void)) {
    let link = UserDefaults.standard.string(forKey: LINK_KEY)

    guard let unWrappedLink = link else {
      completion(CustomError.generic)
      return
    }
    
    let email = UserDefaults.standard.string(forKey: EMAIL_KEY)
    guard let unWrappedEmail = email else {
      completion(CustomError.generic)
      return
    }
    
    Auth.auth().signIn(withEmail: unWrappedEmail, link: unWrappedLink) { (user, error) in
      if let error = error {
        completion(error)
        return
      }
      completion(nil)
    }
  }
}
