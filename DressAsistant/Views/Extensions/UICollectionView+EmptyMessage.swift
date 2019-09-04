//
//  UICollectionView+EmptyMessage.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 04/09/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

extension UICollectionView {
  func showEmpty(messageId: String) {
    let messageLabel = UIHelper().makeInfoLabelFor(messageId, identifier: nil)
    messageLabel.font = UIFont.systemFont(ofSize: 14)
    messageLabel.frame = CGRect(x: 0,
                                y: 0,
                                width: self.bounds.size.width,
                                height: self.bounds.size.height * 0.80)
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center
    messageLabel.sizeToFit()
    
    self.backgroundView = messageLabel;
  }
  
  func restore() {
    self.backgroundView = nil
  }
}
