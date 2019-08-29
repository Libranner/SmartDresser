//
//  DeeplinkManager.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 27/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import UIKit

enum DeeplinkType {
  case outfitCreation(outfit: Outfit)
}

class DeeplinkManager {
  static let shared = DeeplinkManager()
  
  func proceedTo(deeplinkType: DeeplinkType) {
    switch deeplinkType {
    case .outfitCreation(let outfit):
      showOutfitCreationScreen(outfit: outfit)
    }
  }
  
  func showOutfitCreationScreen(outfit: Outfit) {
    AffiliateService().get(withId: outfit.affiliateId!) {
      error, affiliate in
      
      guard affiliate != nil else {
        return
      }
      
      AppManager.shared.currentAffiliate = affiliate
      DispatchQueue.main.async {
        if let vc = self.topMostController() {
          let inventoryVC = InventoryViewController(outfit: outfit)
          if let navVC = vc.navigationController {
            navVC.pushViewController(inventoryVC, animated: true)
          }
          else {
            let navVC = UINavigationController(rootViewController: inventoryVC)
            vc.present(navVC, animated: true)
          }
        }
      }
    }
  }
  
  private func topMostController() -> UIViewController? {
    var topController = UIApplication.shared.keyWindow?.rootViewController;
    
    while (topController?.presentedViewController != nil) {
      topController = topController!.presentedViewController!;
    }
    
    return topController;
  }
}
