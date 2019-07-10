//
//  FIleService.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 09/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import Firebase

struct FileService {
  fileprivate let userPhotosPath = "userPhotos"
  fileprivate let affiliatePhotosPath = "affiliatePhotos"
  
  fileprivate func uploadFile(path: String, data: Data, completion:@escaping (_ error: CustomError?,
    _ success: Bool, _ photoURL: URL?)->Void) {
    
    // Get a reference to the storage service using the default Firebase App
    let storage = Storage.storage()
    
    // Create a storage reference from our storage service
    let storageRef = storage.reference().child(path)
    
    // Create the file metadata
    let metadata = StorageMetadata()
    metadata.contentType = "image/png"
    
    // Upload file and metadata to the object 'images/mountains.jpg'
    let uploadTask = storageRef.putData(data, metadata: metadata)
    
    uploadTask.observe(.success) { snapshot in
      // Upload completed successfully
      storageRef.downloadURL { (url, error) in
        guard let downloadURL = url else {
          completion(CustomError.generic, false, nil)
          print("Error getting the photo URL")
          return
        }
        completion(nil, true, downloadURL)
      }
    }
    
    uploadTask.observe(.failure) { snapshot in
      if let error = snapshot.error as NSError? {
        completion(CustomError.generic, false, nil)
        print("Error uploading User Photo: \(error)")
      }
    }
  }
  
  func uploadUserPhoto(_ data: Data, completion:@escaping (_ error: CustomError?,
    _ success: Bool, _ photoURL: URL?)->Void) {
    
    if let userID = Auth.auth().currentUser?.uid {
      let path = "\(userPhotosPath)/\(userID)"
      uploadFile(path: path, data: data, completion: completion)
    }
    else {
      print("Could not get User ID")
      completion(CustomError.usersNotSignedIn, false, nil)
    }
  }
  
  func uploadAffiliatePhoto(_ data: Data, completion:@escaping (_ error: CustomError?,
    _ success: Bool, _ photoURL: URL?)->Void) {
    let uuid = UUID()
    let path = "\(affiliatePhotosPath)/\(uuid)"
    uploadFile(path: path, data: data, completion: completion)
  }
}
