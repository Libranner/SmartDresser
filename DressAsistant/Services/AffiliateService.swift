//
//  AffiliateService.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 16/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

struct AffiliateService {
  private let root = "affiliates"
  
  func save(_ affiliate: Affiliate, completion:@escaping (_ error: CustomError?,
    _ success: Bool) -> Void) {
    
    let db = Firestore.firestore()
    let docData = try! FirestoreEncoder().encode(affiliate)
    
    db.collection(root).addDocument(data: docData) {
      error in
      if let error = error {
        print("Error writing document: \(error)")
        completion(CustomError.errorSavingData, false)
      }
      else {
        completion(nil, true)
      }
    }
  }
}
