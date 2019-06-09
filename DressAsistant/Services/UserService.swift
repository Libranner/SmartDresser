//
//  UserService.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 09/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import Firebase

struct UserService {
  func saveUser(displayName: String, photoURL: URL?, completion:@escaping (_ saved: Bool)->Void) {
    if let request = Auth.auth().currentUser?.createProfileChangeRequest() {
      request.displayName = displayName
      request.photoURL = photoURL
      request.commitChanges { error in
        guard error == nil else {
          print("Error saving user: \(error!)")
          completion(false)
          return
        }
        completion(true)
      }
    }
  }
}
