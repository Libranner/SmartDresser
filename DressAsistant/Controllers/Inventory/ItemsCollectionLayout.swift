//
//  ItemsCollectionLayout.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 24/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class ItemsCollectionLayout: UICollectionViewFlowLayout {
  convenience init(direction: UICollectionView.ScrollDirection) {
    self.init()
    scrollDirection = direction
    estimatedItemSize = CGSize(width: 1, height: 1)
    
    if direction == .horizontal {
      sectionInset = UIEdgeInsets(top: 5.0,
                   left: 20.0, bottom: 5.0, right: 35.0)
    }
    else {
      sectionInset = UIEdgeInsets(top: CGFloat(UIConstants.defaultTopSpace),
                                  left: 5.0, bottom: 5.0, right: 5.0)
      minimumLineSpacing = 20
      minimumInteritemSpacing = 5
    }
  }
}
