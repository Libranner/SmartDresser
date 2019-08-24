//
//  ItemService.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 14/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

struct ItemService {
  private let root = "items"
  
  func get(withNFC nfcCode:String, completion:@escaping (_ error: ItemError?,
    _ data: Item?) -> Void) {
    
    let db = Firestore.firestore()
    let docRef = db.collection(root)
    
    docRef.whereField("nfcCode", isEqualTo: nfcCode).limit(to: 1).getDocuments { (querySnapshot, error) in
      guard error == nil else {
        print("Error getting documents: \(String(describing: error))")
        completion(ItemError.generic, nil)
        return
      }
      
      if let snapshot = querySnapshot?.documents.first {
        let item = self.convertToItem(document: snapshot)
        completion(nil, item)
      }
      else {
        completion(ItemError.notFound, nil)
      }
    }
  }
  
  func get(withId id:String, completion:@escaping (_ error: ItemError?,
    _ data: Item?) -> Void) {
    
    let db = Firestore.firestore()
    let docRef = db.collection(root)
    
    docRef.document(id).getDocument { (snapshot, error) in
      guard error == nil else {
        print("Error getting documents: \(String(describing: error))")
        completion(ItemError.generic, nil)
        return
      }

      if let snapshot = snapshot {
        let item = self.convertToItem(document: snapshot)
        completion(nil, item)
      }
      else {
        completion(ItemError.notFound, nil)
      }
    }
  }
  
  fileprivate func parseData(_ err: Error?,
                             _ querySnapshot: QuerySnapshot?,
                             completion:(_ error: CustomError?, _ data: [Item])-> Void) {
    var data = [Item]()
    if let err = err {
      print("Error getting documents: \(err)")
      completion(CustomError.errorGettingData, data)
    } else {
      for document in querySnapshot!.documents {
        if let item = self.convertToItem(document: document) {
          data.append(item)
        }
      }
      completion(nil, data)
    }
  }
  
  func getAll(type: ItemType?, completion:@escaping (_ error: CustomError?,
    _ data: [Item]) -> Void) {
    
    let db = Firestore.firestore()
    let docRef = db.collection(root)
    
    let affiliateId = AppManager.shared.currentAffiliate?.key as Any
    let userId = AuthService().currentUserId as Any
    
    if type != nil {
      docRef
        .whereField("type", isEqualTo: type!.rawValue)
        .whereField("userId", isEqualTo: userId)
        .whereField("affiliateId", isEqualTo: affiliateId)
        .getDocuments { (querySnapshot, err) in
          self.parseData(err, querySnapshot, completion: completion)
      }
    }
    else {
      docRef
        .whereField("userId", isEqualTo: userId)
        .whereField("affiliateId", isEqualTo: affiliateId)
        .getDocuments { (querySnapshot, err) in
        self.parseData(err, querySnapshot, completion: completion)
      }
    }
  }
  
  private func convertToItem(document: DocumentSnapshot) -> Item? {
    guard let model = document.data() else {
      return nil
    }

    var item = try! FirestoreDecoder().decode(Item.self,
                                              from: model)
    item.key = document.documentID
    if let imageURL = model["imageUrl"] as? String {
      item.imageURL = URL(string: imageURL)!
    }
    
    return item
  }
  
  func save(_ item: Item, completion:@escaping (_ error: CustomError?,
    _ success: Bool) -> Void) -> String {
    
    let db = Firestore.firestore()
    let docData = try! FirestoreEncoder().encode(item)
    
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
  
  func update(key: String, item: Item, completion:@escaping (_ error: CustomError?,
    _ success: Bool) -> Void) {
    
    let db = Firestore.firestore()
    let docData = try! FirestoreEncoder().encode(item)

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
  
  func delete(_ itemId: String, completion:@escaping (_ error: CustomError?,
    _ success: Bool) -> Void) {
    let db = Firestore.firestore()
    db.collection(root).document(itemId).delete {
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
