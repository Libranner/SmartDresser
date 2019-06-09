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
  
  func uploadUserPhoto(_ data: Data, completion:@escaping (_ success: Bool)->Void) {
    
    // Get a reference to the storage service using the default Firebase App
    let storage = Storage.storage()
    
    // Create a storage reference from our storage service
    let storageRef = storage.reference().child("userPhotos")

    // Create the file metadata
    let metadata = StorageMetadata()
    metadata.contentType = "image/png"
    
    // Upload file and metadata to the object 'images/mountains.jpg'
    let uploadTask = storageRef.putData(data, metadata: metadata)
    
    uploadTask.observe(.success) { snapshot in
      // Upload completed successfully
      completion(true)
    }
    
    uploadTask.observe(.failure) { snapshot in
      if let error = snapshot.error as NSError? {
        completion(false)
        print("Error uploading User Photo: \(error)")
      }
    }

  }
}
