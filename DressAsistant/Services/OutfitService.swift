//
//  OutfitService.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 22/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

struct OutfitService {
  private let root = "outfits"
  
  func get(withId id:String, completion:@escaping (_ error: CustomError?,
    _ data: Outfit?) -> Void) {
    let db = Firestore.firestore()
    let docRef = db.collection(root)
    
    docRef.document(id).getDocument { (snapshot, error) in
      guard error == nil else {
        print("Error getting documents: \(String(describing: error))")
        completion(CustomError.generic, nil)
        return
      }
      
      if let snapshot = snapshot {
        let outfit = self.convertToOutfit(document: snapshot)
        completion(nil, outfit)
      }
      else {
        completion(CustomError.errorGettingData, nil)
      }
    }
  }
  
  func getRecomendationsForWeather( _ weather: WeatherCondition,
                                    timeOfDay: TimeOfDay,
                                    eventType: EventType,
                                    season: Season, completion:@escaping (_ outfits: [Outfit]) -> Void) {
    //TODO: Fix this
    let affiliateId = AppManager.shared.currentAffiliate?.key as Any
    
    let db = Firestore.firestore()
    let docRef = db.collection(root)
      .whereField("affiliateId", isEqualTo: affiliateId)
      .whereField("weather", isEqualTo: weather.rawValue)
      .whereField("timeOfDay", isEqualTo: timeOfDay.rawValue)
      .whereField("eventType", isEqualTo: eventType.rawValue)
      .whereField("season", isEqualTo: season.rawValue)
    
    docRef.getDocuments { (querySnapshot, err) in
      var data = [Outfit]()
      if let err = err {
        print("Error getting documents: \(err)")
        completion(data)
      } else {
        for document in querySnapshot!.documents {
          if let outfit = self.convertToOutfit(document: document) {
            data.append(outfit)
          }
        }
        completion(data)
      }
    }
  }
  
  func getAll(completion:@escaping (_ error: CustomError?,
    _ data: [Outfit]) -> Void) {
    
    let affiliateId = AppManager.shared.currentAffiliate?.key as Any
    let userId = AuthService().currentUserId as Any
    
    let db = Firestore.firestore()
    let docRef = db.collection(root)
      .whereField("userId", isEqualTo: userId)
      .whereField("affiliateId", isEqualTo: affiliateId)
    
    docRef.getDocuments { (querySnapshot, err) in
      var data = [Outfit]()
      if let err = err {
        print("Error getting documents: \(err)")
        completion(CustomError.errorGettingData, data)
      } else {
        for document in querySnapshot!.documents {
          if let outfit = self.convertToOutfit(document: document) {
            data.append(outfit)
          }
        }
        completion(nil, data)
      }
    }
  }
  
  private func convertToOutfit(document: DocumentSnapshot) -> Outfit? {
    guard let model = document.data() else {
      return nil
    }
    
    var outfit = try! FirestoreDecoder().decode(Outfit.self,
                                              from: model)
    outfit.key = document.documentID    
    return outfit
  }
  
  func save(_ outfit: Outfit, completion:@escaping (_ error: CustomError?,
    _ success: Bool) -> Void) -> String {
    
    let db = Firestore.firestore()
    let docData = try! FirestoreEncoder().encode(outfit)
    
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
  
  func update(key: String, outfit: Outfit, completion:@escaping (_ error: CustomError?,
    _ success: Bool) -> Void) {
    
    let db = Firestore.firestore()
    let docData = try! FirestoreEncoder().encode(outfit)
    
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
  
  func delete(_ outfitId: String, completion:@escaping (_ error: CustomError?,
    _ success: Bool) -> Void) {
    let db = Firestore.firestore()
    db.collection(root).document(outfitId).delete {
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

