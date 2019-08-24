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
      
      //TODO:SE NECESITA OBTENER EL AFFILIADO PARA PODER CHEQUIAR SUS DATOS Y SABER SI YA SE CONECTO CON EL ASISTENTE
      //ESTO DEBERIA HACER EN CONJUNTO CON - [ ] Recordar tipo de usuario que inicio sesión
      /*if let snapshot = snapshot {
        let item = self.convertToItem(document: snapshot)
        completion(nil, item)
      }
      else {
        completion(ItemError.notFound, nil)
      }*/
    }
  }
  
  func getAll(completion:@escaping (_ error: CustomError?,
    _ data: [Affiliate]) -> Void) {
    
    let db = Firestore.firestore()
    let docRef = db.collection(root)
    
    let userId = AuthService().currentUserId as Any
    docRef
      .whereField("userId", isEqualTo: userId)
      .getDocuments { (querySnapshot, err) in
      var data = [Affiliate]()
      if let err = err {
        print("Error getting documents: \(err)")
        completion(CustomError.errorGettingData, data)
      } else {
        for document in querySnapshot!.documents {
          var model = document.data()
          var affiliate = Affiliate(key: document.documentID,
                                    name: model["name"] as! String,
                                    avatarUrl: nil,
                                    birthdate: Date(),
                                    height: model["height"] as! Float,
                                    weight: model["weight"] as! Float,
                                    sex: .none,
                                    hairColor: nil,
                                    eyeColor: nil,
                                    skinColor: nil,
                                    userId: model["userId"] as? String,
                                    isConnected: false)
          
          affiliate.isConnected = model["isConnected"] as? Bool ?? false
          
          if let data = model["hairColor"] as? [String : Any] {
            affiliate.hairColor = try! FirestoreDecoder().decode(HairColor.self,
                                                                 from: data)
          }
          
          if let data = model["skinColor"] as? [String : Any] {
            affiliate.skinColor = try! FirestoreDecoder().decode(SkinColor.self,
                                                                 from: data)
          }
          
          if let data = model["eyeColor"] as? [String : Any] {
            affiliate.eyeColor = try! FirestoreDecoder().decode(EyeColor.self,
                                                                from: data)
          }
          
          if let avatarURL = model["avatarUrl"] as? String {
            affiliate.avatarUrl = URL(string: avatarURL)
          }
          
          let timestamp = model["birthdate"] as! Timestamp
          affiliate.birthdate = Date(timeIntervalSince1970:
            TimeInterval(exactly: timestamp.seconds)!)
          
          let sex: Sex = model["sex"] as! String == Sex.male.rawValue
            ? .male : .female
          affiliate.sex = sex
          
          data.append(affiliate)
        }
        completion(nil, data)
      }
    }
  }
  
  func createRelation(affiliateId: String,
                      completion: @escaping (_ error: CustomError?) -> Void) {
    let db = Firestore.firestore()
    
    db.collection(root).document(affiliateId).updateData(["isConnected" : true]) {
        error in
        if let error = error {
          print("Error updating document: \(error)")
          completion(CustomError.errorSavingData)
        }
        else {
          completion(nil)
        }
      }
  }
  
  func save(_ affiliate: Affiliate, completion:@escaping (_ error: CustomError?,
    _ success: Bool) -> Void) -> String {
    
    let db = Firestore.firestore()
    let docData = try! FirestoreEncoder().encode(affiliate)
    
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
  
  func update(_ affiliate: Affiliate, completion:@escaping (_ error: CustomError?,
    _ success: Bool) -> Void) {
    
    let db = Firestore.firestore()
    let docData = try! FirestoreEncoder().encode(affiliate)
    
    if let key = affiliate.key {
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
    else {
      print("Error updating document: No Key")
      completion(CustomError.errorSavingData, false)
    }
  }
  
  func delete(_ affiliateId: String, completion:@escaping (_ error: CustomError?,
    _ success: Bool) -> Void) {
    let db = Firestore.firestore()
    db.collection(root).document(affiliateId).delete {
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
