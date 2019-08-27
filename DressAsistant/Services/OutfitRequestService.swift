//
//  OutfitRequestService.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 27/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

struct OutfitRequestService {
  private let root = "outfitRequests"
  
  func save(_ outfitRequest: OutfitRequest,
            completion: ((_ error: CustomError?, _ success: Bool) -> Void)? = nil) {
    let db = Firestore.firestore()
    let docData = try! FirestoreEncoder().encode(outfitRequest)
    
    db.collection(root).addDocument(data: docData) {
      error in
      if let error = error {
        print("Error writing document: \(error)")
        if let completion = completion {
          completion(CustomError.errorSavingData, false)
        }
      }
      else {
        if let completion = completion {
          completion(nil, true)
        }
      }
    }
  }
  
  func getAll(completion:@escaping (_ error: CustomError?,
    _ data: [OutfitRequest]) -> Void) {
    let userId = AuthService().currentUserId as Any
    let db = Firestore.firestore()
    let docRef = db.collection(root)
      .whereField("userId", isEqualTo: userId)
    
    docRef.getDocuments { (querySnapshot, err) in
      var data = [OutfitRequest]()
      if let err = err {
        print("Error getting documents: \(err)")
        completion(CustomError.errorGettingData, data)
      } else {
        for document in querySnapshot!.documents {
          let outfitRequest = try! FirestoreDecoder().decode(OutfitRequest.self,
                                                             from: document.data())
          data.append(outfitRequest)
        }
        completion(nil, data)
      }
    }
  }
  
  
  
}
