//
//  SkinColorService.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 06/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

struct SkinColorService {
  private let root = "skinColors"
  
  func getAll(completion:@escaping (_ error: CustomError?,
    _ data: [SkinColor]) -> Void) {
    
    let db = Firestore.firestore()
    let docRef = db.collection(root)
    
    docRef.getDocuments { (querySnapshot, err) in
      var data = [SkinColor]()
      if let err = err {
        print("Error getting documents: \(err)")
        completion(CustomError.errorGettingData, data)
      } else {
        for document in querySnapshot!.documents {
          var model = try! FirestoreDecoder().decode(SkinColor.self, from: document.data())
          model.documentID = document.documentID
          data.append(model)
        }
        completion(nil, data)
      }
    }
  }
}

