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
  private let URL_FORMAT = "https://smartdresser-7d3cb.firebaseapp.com?email"

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
    let link = "https://smartdresser-7d3cb.firebaseapp.com/?email=libranner@gmail.com&apiKey=AIzaSyCjP7vWXKUVik3XpiWeWJGJoapePdeeHu4&oobCode=avmAzjLb9EPyw1KQXkU-LQrwsEuBYvoLD58IPBEVdQkAAAFrOYDZ_Q&mode=signIn&lang=en"
    //TODO: Fix this
    //if let link = UserDefaults.standard.string(forKey: LINK_KEY) {
      completion(isSignIn(withLink: link))
    //}
    //completion(false)
  }
  
  func setupEmailSignIn( _ email: String, completion:@escaping (_ error: Error?)-> Void) {
    // [START action_code_settings]
    let actionCodeSettings = ActionCodeSettings()
    actionCodeSettings.url = URL(string: "\(URL_FORMAT)=\(email)")
    // The sign-in operation has to always be completed in the app.
    actionCodeSettings.handleCodeInApp = true
    actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
    
    // [END action_code_settings]
    // [START send_signin_link]
    Auth.auth().sendSignInLink(toEmail:email,
                               actionCodeSettings: actionCodeSettings) { error in
      if let error = error {
        completion(error)
        return
      }
      // The link was successfully sent. Inform the user.
      // Save the email locally so you don't need to ask the user for it again
      // if they open the link on the same device.
      UserDefaults.standard.set(email, forKey: "Email")
      completion(nil)
    }
    
  }
  
  func signInWithEmail(completion:@escaping ((_ error: Error?)-> Void)) {
    // [START signin_emaillink]
    let link = "https://smartdresser-7d3cb.firebaseapp.com/?email=libranner@gmail.com&apiKey=AIzaSyCjP7vWXKUVik3XpiWeWJGJoapePdeeHu4&oobCode=avmAzjLb9EPyw1KQXkU-LQrwsEuBYvoLD58IPBEVdQkAAAFrOYDZ_Q&mode=signIn&lang=en"
    
    let email = "libranner@gmail.com"
    Auth.auth().signIn(withEmail: email, link: link) { (user, error) in
      if let error = error {
        completion(error)
        return
      }
      completion(nil)
    }
  }
}
