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
  private let root = "users"
  
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
  
  func updateUserInfo() {
    if let userId = Auth.auth().currentUser?.uid ?? AppManager.shared.affiliateId {
      InstanceID.instanceID().instanceID { (result, error) in
        if let error = error {
          print("Error fetching remote instance ID: \(error)")
        } else if let result = result {
          print("Remote instance ID token: \(result.token)")
          self.save(user: User(userId: userId, notificationToken: result.token))
        }
      }
    }
  }
  
  private func save(user: User) {
    let db = Firestore.firestore()
    let docData = ["notificationToken": user.notificationToken]
    
    db.collection(root).document(user.userId).setData(docData) {
      error in
      if let error = error {
        print("Error writing document: \(error)")
      }
    }
  }
  
}
