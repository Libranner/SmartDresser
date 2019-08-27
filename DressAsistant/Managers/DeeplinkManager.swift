//
//  DeeplinkManager.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 27/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

struct DeeplinkManager {
  func fulfillOutfitRequest(_ outfitRequest: OutfitRequest) {
    AffiliateService().get(withId: outfitRequest.affiliateId) {
      error, affiliate in
    
      guard affiliate != nil else {
        return
      }
      
      AppManager.shared.currentAffiliate = affiliate
    }
  }
}
