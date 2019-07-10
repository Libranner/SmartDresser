//
//  HairStyleService.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 18/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

struct HairStyleService {
  private let root = "hairStyles"
  
  func getAll(completion:@escaping (_ error: CustomError?,
    _ data: [HairStyle]) -> Void) {
    
    let db = Firestore.firestore()
    let docRef = db.collection(root)
    
    docRef.getDocuments { (querySnapshot, err) in
      var data = [HairStyle]()
      if let err = err {
        print("Error getting documents: \(err)")
        completion(CustomError.errorGettingData, data)
      } else {
        for document in querySnapshot!.documents {
          var model = try! FirestoreDecoder().decode(HairStyle.self, from: document.data())
          model.documentID = document.documentID
          data.append(model)
        }
        completion(nil, data)
      }
    }
  }
}
