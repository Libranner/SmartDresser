//
//  ClothesService.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 14/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

struct ClothesService {
  private let root = "clothes"
  
  func getAll(completion:@escaping (_ error: CustomError?,
    _ data: [Clothes]) -> Void) {
    
    let db = Firestore.firestore()
    let docRef = db.collection(root)
    
    docRef.getDocuments { (querySnapshot, err) in
      var data = [Clothes]()
      if let err = err {
        print("Error getting documents: \(err)")
        completion(CustomError.errorGettingData, data)
      } else {
        for document in querySnapshot!.documents {
          
          var model = document.data()
          var clothes = try! FirestoreDecoder().decode(Clothes.self,
                                                       from: document.data())
          
          if let imageURL = model["imageUrl"] as? String {
            clothes.imageURL = URL(string: imageURL)!
          }
          
          data.append(clothes)
        }
        completion(nil, data)
      }
    }
  }
  
  func save(_ clothes: Clothes, completion:@escaping (_ error: CustomError?,
    _ success: Bool) -> Void) -> String {
    
    let db = Firestore.firestore()
    let docData = try! FirestoreEncoder().encode(clothes)
    
    let ref = db.collection(root).addDocument(data: docData) {
      error in
      if let error = error {
        print("Error writing document: \(error)")
        completion(CustomError.errorSavingData, false)
      }
      else {
        completion(nil, true)
      }
    }
    
    return ref.documentID
  }
  
  func update(key: String, clothes: Clothes, completion:@escaping (_ error: CustomError?,
    _ success: Bool) -> Void) {
    
    let db = Firestore.firestore()
    let docData = try! FirestoreEncoder().encode(clothes)

    db.collection(root).document(key).setData(docData) {
      error in
      if let error = error {
        print("Error updating document: \(error)")
        completion(CustomError.errorSavingData, false)
      }
      else {
        completion(nil, true)
      }
    }
  }
  
  func delete(_ clothesId: String, completion:@escaping (_ error: CustomError?,
    _ success: Bool) -> Void) {
    let db = Firestore.firestore()
    db.collection(root).document(clothesId).delete {
      error in
      if let error = error {
        print("Error deleting document: \(error)")
        completion(CustomError.errorSavingData, false)
      }
      else {
        completion(nil, true)
      }
    }
  }
  
}
